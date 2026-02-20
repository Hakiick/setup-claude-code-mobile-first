# Equipe Agentique — Azure Deployment Template

> Ce fichier est **auto-généré** par `/init-project` en Phase 5.
> Il documente les agents du projet. Ne le modifie pas manuellement.

## Agents core (toujours présents)

### `forge`
**Rôle** : Team Lead — orchestre les agents, décompose les US, gère les feedback loops
**Modèle** : **Opus 4.6** (obligatoire)
**Toujours présent** : oui (c'est l'orchestrateur principal)

### `stabilizer`
**Rôle** : Quality gate — terraform validate, plan, fmt, Docker build
**Modèle** : **Sonnet 4.6**
**Toujours présent** : oui (toujours en dernier dans le pipeline)
**Responsabilités** :
- Lancer les checks de stabilité (`bash scripts/stability-check.sh`)
- Vérifier terraform validate + plan + fmt
- Vérifier les Docker builds
- Corriger les problèmes simples directement
- Renvoyer les problèmes complexes à l'agent concerné

### `reviewer`
**Rôle** : Revue de code qualité + sécurité infrastructure
**Modèle** : **Sonnet 4.6**
**Quand l'utiliser** : US de priorité haute ou touchant la sécurité
**Responsabilités** :
- Vérifier le respect des règles du projet (`.claude/rules/`)
- Vérifier les bonnes pratiques Terraform et Docker
- Détecter les failles de sécurité infra
- Produire un rapport structuré : critiques + suggestions

---

## Agents spécialisés Azure deployment (pré-configurés)

### `azure-infra`
**Rôle** : Spécialiste Azure Terraform — modules, App Service, PostgreSQL, networking
**Modèle** : **Sonnet 4.6**
**Skill** : `/azure-infra`
**Domaine** : Terraform modules, Azure resources, naming conventions, cost optimization
**Responsabilités** :
- Créer et maintenir les modules Terraform (app-service, database, networking)
- Configurer les App Services (Node.js natif ou Docker)
- Configurer les PostgreSQL Flexible Servers
- Gérer les variables, outputs, et state
- Respecter les naming conventions Azure

### `docker-dev`
**Rôle** : Spécialiste Docker — Dockerfiles, multi-stage builds, optimisation
**Modèle** : **Sonnet 4.6**
**Skill** : `/docker-dev`
**Domaine** : Dockerfiles, docker-compose, image optimization, registries
**Responsabilités** :
- Créer des Dockerfiles multi-stage pour chaque app
- Optimiser les images (Alpine, layer caching, .dockerignore)
- Configurer les health checks Docker
- Assurer la sécurité des images (non-root, no secrets)

### `db-architect`
**Rôle** : Architecte base de données — schemas, migrations, Azure PostgreSQL
**Modèle** : **Sonnet 4.6**
**Skill** : `/db-architect`
**Domaine** : PostgreSQL, schemas, migrations, connection pooling, backup
**Responsabilités** :
- Designer les schemas de base de données
- Configurer Azure Database for PostgreSQL
- Gérer les migrations (Ecto, Prisma, raw SQL)
- Configurer SSL, firewall, connection pooling

### `cicd-dev`
**Rôle** : Spécialiste CI/CD — GitHub Actions, deploy pipelines
**Modèle** : **Sonnet 4.6**
**Skill** : `/cicd-dev`
**Domaine** : GitHub Actions, deployment workflows, environments, secrets
**Responsabilités** :
- Créer les workflows GitHub Actions (build, test, deploy)
- Configurer les environments et secrets
- Mettre en place les pipelines Terraform (plan on PR, apply on merge)
- Configurer le caching et les artifacts

### `security-auditor`
**Rôle** : Auditeur sécurité infrastructure — RBAC, network, secrets
**Modèle** : **Sonnet 4.6**
**Skill** : `/security-auditor`
**Domaine** : Azure RBAC, NSG, secrets management, compliance
**Responsabilités** :
- Auditer la sécurité de l'infrastructure
- Vérifier les RBAC et managed identities
- Vérifier les network policies et firewall rules
- Vérifier la gestion des secrets
- Produire un rapport d'audit structuré

---

## Agents fallback (génériques)

### `architect`
**Modèle** : **Sonnet 4.6**
**Rôle** : Planification architecture infrastructure (read-only)

### `developer`
**Modèle** : **Sonnet 4.6**
**Rôle** : Développeur générique

### `devops`
**Modèle** : **Sonnet 4.6**
**Rôle** : DevOps générique (CI/CD, Docker, Terraform)

### `tester`
**Modèle** : **Sonnet 4.6**
**Rôle** : Tests unitaires et d'intégration

---

## Règles d'équipe

1. Le **stabilizer** intervient TOUJOURS en dernier
2. Les agents de planification (architect) interviennent TOUJOURS en premier
3. Au moins un agent d'infrastructure (azure-infra) est TOUJOURS présent
4. L'ordre d'exécution suit l'ordre défini dans le body de l'issue GitHub
5. Le **forge** évalue le résultat de chaque agent avant de passer au suivant

## Modèles par catégorie

| Catégorie | Agents | Modèle |
|-----------|--------|--------|
| Orchestration | forge, init-project, next-feature | **Opus 4.6** |
| Planification | architect | **Sonnet 4.6** |
| Infrastructure | azure-infra, db-architect | **Sonnet 4.6** |
| Containerisation | docker-dev | **Sonnet 4.6** |
| CI/CD | cicd-dev | **Sonnet 4.6** |
| Sécurité | security-auditor | **Sonnet 4.6** |
| Revue | reviewer | **Sonnet 4.6** |
| Validation | stabilizer | **Sonnet 4.6** |

## Types d'agents

| Catégorie | Pattern de nom | Rôle |
|-----------|---------------|------|
| Planification | `architect` | Analyse et plan avant implémentation |
| Infrastructure | `azure-infra`, `db-architect` | Terraform modules et config Azure |
| Containerisation | `docker-dev` | Dockerfiles et images |
| CI/CD | `cicd-dev` | Pipelines de déploiement |
| Sécurité | `security-auditor` | Audit et compliance |
| Qualité | `reviewer` | Revue de code |
| Validation | `stabilizer` | Quality gate finale |
