# Setup Claude Code — Mobile-First Template

Tu es un orchestrateur de projet. Workflow strict et séquentiel.

Contexte du projet : @project.md

## Règles IMPORTANTES

- **YOU MUST** stabiliser (build + tests + lint) avant de passer à la feature suivante
- **YOU MUST** travailler sur une seule feature à la fois
- **YOU MUST** nettoyer le contexte (`/compact`) entre chaque feature
- **YOU MUST** utiliser l'équipe agentique assignée à chaque US
- **YOU MUST** faire des commits au format `type(scope): description` (ex: `feat(frontend): add responsive nav`)
- **YOU MUST** nommer les branches au format `type/scope/description-courte` (ex: `feat/frontend/responsive-nav`)
- **YOU MUST** nommer les PR au format `type(scope): description` (même format que les commits)
- **YOU MUST** utiliser `rebase` — JAMAIS `merge` pour intégrer les changements de `main`
- **YOU MUST** créer la branche sur GitHub dès le début (`git push -u origin <branch>`)
- **YOU MUST** créer une PR via `gh pr create` après stabilisation
- **YOU MUST** lancer `bash scripts/stability-check.sh` AVANT tout push
- **YOU MUST** re-lancer le stability check APRÈS chaque rebase
- **YOU MUST** vérifier l'éligibilité d'une US avant de la démarrer (`bash scripts/check-us-eligibility.sh <numero>`)
- **YOU MUST NOT** démarrer une US dont les dépendances ne sont pas satisfaites
- **YOU MUST NOT** merger une PR si le stability check échoue
- **YOU MUST NOT** utiliser `git push --force` — utilise `--force-with-lease` uniquement

## Skills disponibles

### Skills core (toujours présents)

| Skill | Usage |
|-------|-------|
| `/init-project` | **Setup automatique** : analyse le projet, brainstorm les US, génère agents + règles + issues |
| `/forge` | **Team Lead** : décompose une US, délègue aux agents spécialisés, feedback loops, livre stable |
| `/next-feature` | Pipeline linéaire simple (alternative à /forge pour les features simples) |
| `/reviewer` | Revue de code qualité + sécurité |
| `/stabilizer` | Vérifie build + tests + lint + type-check |

### Skills spécialisés mobile-first (générés pour ce template)

| Skill | Usage |
|-------|-------|
| `/mobile-dev` | Développeur mobile-first — responsive design, touch interactions, viewport management |
| `/responsive-tester` | Testeur responsive — breakpoints, touch events, viewports, accessibility |
| `/pwa-dev` | Spécialiste PWA — service workers, manifest, offline-first, installabilité |

### Skills fallback (génériques, utilisés si pas d'agents générés)

| Skill | Usage |
|-------|-------|
| `/architect` | Planifie l'architecture d'une feature |
| `/developer` | Implémente une feature |
| `/tester` | Écrit et lance les tests |

Après `/init-project`, consulte `.claude/team.md` pour voir les agents disponibles.

## Commandes

```bash
# === Dev & Build ===
npm run dev                           # Dev server
npm run build                         # Build
npm run preview                       # Preview build
npm test                              # Tests
npm run lint                          # Lint/format check
npm run type-check                    # Type check

# === Stabilité & Workflow ===
bash scripts/stability-check.sh       # Check complet de stabilité
bash scripts/pre-merge-check.sh       # Vérification pré-merge d'une branche
bash scripts/check-us-eligibility.sh --list     # US éligibles (dépendances vérifiées)
bash scripts/check-us-eligibility.sh <numero>   # Vérifier une US spécifique
bash scripts/search-skills.sh --stack           # Chercher des skills communautaires
bash scripts/install-skill.sh <owner/repo>      # Installer un skill depuis GitHub

# === Multi-Agent tmux (Forge) ===
bash scripts/forge-panes.sh --agents <a1> <a2>  # Lancer une session multi-agents tmux
bash scripts/forge-panes.sh --list              # Voir les agents actifs
bash scripts/forge-panes.sh --kill              # Fermer la session forge
bash scripts/agent-status.sh                    # Dashboard des agents
bash scripts/dispatch.sh <agent> "prompt"       # Envoyer une tâche à un agent
bash scripts/collect.sh <agent>                 # Lire le résultat d'un agent
bash scripts/collect.sh <agent> --wait          # Attendre et lire le résultat

# === GitHub ===
gh issue list                         # Voir les issues
gh pr list                            # Voir les PRs ouvertes
gh pr view <numero>                   # Détail d'une PR
```

## Workflow

1. `/init-project` — Analyse le projet, brainstorm, génère agents + règles, crée les issues
2. `/forge` — Pour chaque US (par priorité) :
   analyse, décompose, délègue aux agents, feedback loops, stabilize, PR, done, clean context
3. Répète 2 jusqu'à ce que toutes les US soient done

> `/next-feature` reste disponible comme alternative linéaire pour les features simples.

## Stratégie Git

```
main ─────────────────────────────────────────────
  │                                        ↑
  └── feat/scope/feature ──── rebase ──── PR ── squash merge ── delete branch
```

- **Rebase only** : `git fetch origin main && git rebase origin/main`
- **Push** : `git push --force-with-lease origin <branch>`
- **PR** : `gh pr create --base main`
- **Après merge** : vérifier que main est stable

## Mobile-First Principles

- **Design mobile d'abord** — Commencer par les écrans < 640px, puis élargir
- **Touch-first interactions** — Zones de tap minimum 44x44px, pas de hover-only
- **Performance budget** — LCP < 2.5s, FID < 100ms, CLS < 0.1
- **Viewport-aware** — Gérer le viewport mobile (100dvh, safe-area-inset)
- **Progressive enhancement** — Fonctionnalités de base sur mobile, enrichies sur desktop
- **Offline-capable** — Service worker pour le contenu critique
- **Responsive images** — srcset, sizes, formats modernes (WebP/AVIF)

## Code rules

- TypeScript strict partout
- Mobile-first responsive design
- Pas de `console.log` en production
- Pas de code commenté — supprimer ou créer une issue
- Fonctions courtes (< 50 lignes)
- Nommage explicite, pas d'abréviations cryptiques
- Try/catch sur les appels API externes
- Valider les inputs utilisateur
- Pas de `any` en TypeScript — utilise des types stricts

## Responsive breakpoints

```
--breakpoint-sm:  640px    /* Small mobile → large mobile */
--breakpoint-md:  768px    /* Mobile → Tablet */
--breakpoint-lg:  1024px   /* Tablet → Desktop */
--breakpoint-xl:  1280px   /* Desktop → Large desktop */
--breakpoint-2xl: 1536px   /* Large desktop → Ultra-wide */
```

## Performance targets

- Lighthouse > 90 sur les 4 métriques (mobile)
- Core Web Vitals : LCP < 2.5s, FID < 100ms, CLS < 0.1
- Bundle size < 200KB (gzipped, initial load)
- Images lazy-loaded avec placeholder blur
- Fonts preloaded, subset si possible
- Animations GPU-accelerated (transform, opacity)
- Pas de layout shift

## Stability

- Après chaque modification : le serveur doit démarrer sans erreur
- Le build doit passer
- Les tests doivent passer
- Ne jamais désactiver un test pour le faire passer
- Chaque US doit être stable AVANT de passer à la suivante
