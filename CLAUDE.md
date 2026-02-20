# Setup Claude Code — Azure Deployment Template

Tu es un orchestrateur de projet. Workflow strict et séquentiel.

Contexte du projet : @project.md

## Règles IMPORTANTES

- **YOU MUST** stabiliser (terraform validate + plan + lint) avant de passer à la feature suivante
- **YOU MUST** travailler sur une seule feature à la fois
- **YOU MUST** nettoyer le contexte (`/compact`) entre chaque feature
- **YOU MUST** utiliser l'équipe agentique assignée à chaque US
- **YOU MUST** faire des commits au format `type(scope): description` (ex: `feat(infra): add app service module`)
- **YOU MUST** nommer les branches au format `type/scope/description-courte` (ex: `feat/infra/app-service-module`)
- **YOU MUST** utiliser `rebase` — JAMAIS `merge` pour intégrer les changements de `main`
- **YOU MUST** créer la branche sur GitHub dès le début (`git push -u origin <branch>`)
- **YOU MUST** lancer `bash scripts/stability-check.sh` AVANT tout push
- **YOU MUST** re-lancer le stability check APRÈS chaque rebase
- **YOU MUST** vérifier l'éligibilité d'une US avant de la démarrer (`bash scripts/check-us-eligibility.sh <numero>`)
- **YOU MUST NOT** démarrer une US dont les dépendances ne sont pas satisfaites
- **YOU MUST NOT** merger dans main si le stability check échoue
- **YOU MUST NOT** utiliser `git push --force` — utilise `--force-with-lease` uniquement

## Skills disponibles

### Skills core (toujours présents)

| Skill | Usage |
|-------|-------|
| `/init-project` | **Setup automatique** : analyse le projet, brainstorm les US, génère agents + règles + issues |
| `/forge` | **Team Lead** : décompose une US, délègue aux agents spécialisés, feedback loops, livre stable |
| `/next-feature` | Pipeline linéaire simple (alternative à /forge pour les features simples) |
| `/reviewer` | Revue de code qualité + sécurité |
| `/stabilizer` | Vérifie terraform validate + plan + lint + format |

### Skills spécialisés Azure deployment (générés pour ce template)

| Skill | Usage |
|-------|-------|
| `/azure-infra` | Spécialiste Azure Terraform — App Service, PostgreSQL, networking, modules réutilisables |
| `/docker-dev` | Spécialiste Docker — Dockerfile multi-stage, docker-compose, optimisation images |
| `/db-architect` | Architecte base de données — schemas, migrations, connection pooling, backup strategies |
| `/cicd-dev` | Spécialiste CI/CD — GitHub Actions, pipelines de déploiement, environments, secrets |
| `/security-auditor` | Auditeur sécurité infra — RBAC, network policies, secrets management, compliance |

### Skills fallback (génériques)

| Skill | Usage |
|-------|-------|
| `/architect` | Planifie l'architecture infrastructure d'une feature |
| `/developer` | Implémente une feature |
| `/devops` | CI/CD, Docker, cloud deployment, Terraform, monitoring |
| `/tester` | Écrit et lance les tests |

## Commandes

```bash
# === Terraform ===
terraform init                        # Initialiser les providers
terraform validate                    # Valider la syntaxe
terraform fmt -check -recursive       # Vérifier le formatage
terraform plan -out=tfplan            # Planifier les changements
terraform apply tfplan                # Appliquer les changements
terraform destroy                     # Détruire l'infrastructure

# === Docker ===
docker build -t <app>:<tag> .         # Construire une image
docker compose up -d                  # Lancer les services localement
docker compose down                   # Arrêter les services

# === Stabilité & Workflow ===
bash scripts/stability-check.sh       # Check complet (validate + plan + fmt + lint)
bash scripts/pre-merge-check.sh       # Vérification pré-merge
bash scripts/check-us-eligibility.sh --list     # US éligibles
bash scripts/check-us-eligibility.sh <numero>   # Vérifier une US spécifique
bash scripts/deploy.sh                # Déployer (terraform apply)
bash scripts/destroy.sh               # Détruire (terraform destroy)

# === Multi-Agent tmux (Forge) ===
bash scripts/forge-panes.sh --init             # Lancer l'orchestrateur
bash scripts/forge-add-agents.sh <a1> <a2>     # Ajouter des agents
bash scripts/forge-add-agents.sh --cleanup     # Retirer TOUS les agents
bash scripts/agent-status.sh                   # Dashboard des agents
bash scripts/dispatch.sh <agent> "prompt"      # Envoyer une tâche
bash scripts/collect.sh <agent> --wait         # Lire le résultat

# === GitHub ===
gh issue list                         # Voir les issues
```

## Workflow

1. `/init-project` — Analyse le projet, identifie les besoins de déploiement, génère agents + issues
2. `/forge` — Pour chaque US : analyse, décompose, délègue, feedback loops, stabilize, merge, done
3. Répète 2 jusqu'à ce que toutes les US soient done

---

## Forge — Protocole d'orchestration multi-agents

Le `/forge` est le Team Lead. Il orchestre une équipe d'agents via le système tmux + `.forge/`.

### Architecture `.forge/`

```
.forge/
├── tasks/          # Tâches par agent
│   └── <agent>.md
├── status/         # Statut (idle | working | done | error | offline)
│   └── <agent>
└── results/        # Résultats
    └── <agent>.md
```

### Phase 0 — Sélection de l'US

```bash
bash scripts/check-us-eligibility.sh <numero>
gh issue view <numero> --json number,title,body,labels --jq '.'
```

**YOU MUST NOT** continuer si exit 1.

### Phase 1 — Analyse et décomposition

1. **Comprendre le scope** — critères d'acceptance, dépendances, type d'infrastructure
2. **Analyser le projet existant** — stack, runtime, DB, ports
3. **Choisir l'équipe** — agents listés dans l'issue
4. **Créer les agents tmux** :

```bash
bash scripts/forge-add-agents.sh <agent1> <agent2> ...
bash scripts/forge-add-agents.sh --list
```

5. **Décomposer en sous-tâches** (TodoWrite)

**Ordre d'exécution :**
- `architect` → en premier (planification)
- `azure-infra`, `db-architect` → infrastructure
- `docker-dev` → containerisation
- `cicd-dev` → pipelines
- `security-auditor` → audit
- `reviewer` → revue
- `stabilizer` → toujours en dernier

### Phase 2 — Setup Git

```bash
git checkout main && git pull --rebase origin main
git checkout -b type/scope/description-courte
git push -u origin type/scope/description-courte
gh issue edit <numero> --add-label "in-progress" --remove-label "task"
```

### Phase 3 — Exécution du pipeline

Tous les agents Task() utilisent `model: "sonnet"`.

#### Évaluation par le Team Lead

| Après agent | Check | Si échec |
|------------|-------|----------|
| `azure-infra` | `terraform validate && terraform plan` | → Renvoyer avec erreurs |
| `docker-dev` | `docker build -t test .` | → Renvoyer avec build log |
| `db-architect` | Vérifier schemas/migrations | → Renvoyer |
| `cicd-dev` | Syntaxe workflows | → Renvoyer |
| `security-auditor` | Critiques vs suggestions | → Critiques = renvoyer au dev |
| `reviewer` | Critiques vs suggestions | → Critiques = renvoyer au dev |
| `stabilizer` | `bash scripts/stability-check.sh` | → Simple = corrige ; Complexe = renvoyer |

#### Feedback loops

| Boucle | Max itérations |
|--------|---------------|
| infra ↔ tester | 3 |
| infra ↔ reviewer | 2 |
| stabilizer retry | 5 |

### Phase 4 — Rebase final + Merge

```bash
git fetch origin main && git rebase origin/main
bash scripts/stability-check.sh
git checkout main && git merge type/scope/description-courte
git push origin main
git branch -d type/scope/description-courte
git push origin --delete type/scope/description-courte
```

### Phase 5 — Clôture

```bash
gh issue edit <numero> --add-label "done" --remove-label "in-progress"
gh issue close <numero>
bash scripts/forge-add-agents.sh --cleanup
git checkout main && git pull --rebase origin main
```

### Gestion des erreurs

| Situation | Décision |
|-----------|----------|
| terraform validate échoue | → Renvoyer à azure-infra avec les erreurs |
| terraform plan montre des destructions non voulues | → Alerter l'utilisateur |
| Docker build échoue | → Renvoyer à docker-dev |
| Security audit critique | → Dev corrige → Security-auditor re-check |
| Stabilizer échoue (format) | → Stabilizer corrige directement |
| Stabilizer échoue (validation error) | → Dev corrige → Stabilizer re-check |
| Rebase avec conflits | → Résoudre → Stabilizer re-check tout |
| > 3 itérations dev/test | → Alerter l'utilisateur |
| > 5 itérations stabilizer | → Alerter l'utilisateur |
| Dépendance bloquée | → Marquer blocked, passer à une autre US |

### Modèles des agents

| Catégorie | Agents | Modèle |
|-----------|--------|--------|
| Orchestration | forge | **Opus 4.6** (obligatoire) |
| Planification | architect | **Sonnet 4.6** |
| Infrastructure | azure-infra, db-architect | **Sonnet 4.6** |
| Containerisation | docker-dev | **Sonnet 4.6** |
| CI/CD | cicd-dev | **Sonnet 4.6** |
| Sécurité | security-auditor | **Sonnet 4.6** |
| Revue | reviewer | **Sonnet 4.6** |
| Validation | stabilizer | **Sonnet 4.6** |

**IMPORTANT : Tous les agents Task() DOIVENT utiliser `model: "sonnet"`. Le forge reste sur Opus 4.6.**

---

## Stratégie Git

```
main ─────────────────────────────────────────────
  │                                        ↑
  └── feat/scope/feature ──── rebase ──── merge ── delete branch
```

- **Rebase only** : `git fetch origin main && git rebase origin/main`
- **Push feature** : `git push --force-with-lease origin <branch>`
- **Merge** : `git checkout main && git merge <branch>`
- **Après merge** : vérifier que main est stable

## Azure Deployment Principles

- **Infrastructure as Code** — Tout en Terraform, rien en manuel
- **Ephemeral infrastructure** — `terraform apply` pour déployer, `terraform destroy` pour couper
- **Modules réutilisables** — Un module par ressource (app-service, database, networking)
- **Secrets management** — Variables sensibles dans `terraform.tfvars` (gitignored), jamais en dur
- **Cost-conscious** — SKU les plus économiques (B1, Burstable B1ms)
- **PaaS-first** — App Service plutôt que des VMs
- **Docker for non-native runtimes** — Docker container pour Elixir, Go, Rust
- **Health checks** — Endpoint `/api/health` sur chaque app
- **SSL/TLS par défaut** — HTTPS only, TLS 1.2 minimum

## Azure Naming Conventions

```
Resource Group:     rg-<project>-<env>
App Service Plan:   asp-<project>-<env>
App Service:        app-<project>-<env>
PostgreSQL Server:  psql-<project>-<env>
Virtual Network:    vnet-<project>-<env>
Container Registry: cr<project><env>
```

## Code rules (IaC)

- HCL bien formaté (`terraform fmt`)
- Variables typées avec descriptions et validations
- Pas de valeurs en dur — tout en variables
- Outputs documentés pour chaque module
- Pas de `terraform apply` sans `terraform plan` d'abord
- Pas de credentials dans le code
- Modules versionnés et testables indépendamment
- Naming conventions Azure cohérentes

## Stability

- `terraform validate` doit passer après chaque modification
- `terraform plan` ne doit pas montrer de destructions non voulues
- `terraform fmt -check` doit passer
- Les Dockerfiles doivent builder sans erreur
- Ne jamais désactiver un check pour le faire passer
- Chaque US doit être stable AVANT de passer à la suivante
