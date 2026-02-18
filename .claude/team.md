# Équipe Agentique — Mobile-First Template

> Ce fichier est **auto-généré** par `/init-project` en Phase 5.
> Il documente les agents du projet. Ne le modifie pas manuellement.

## Agents core (toujours présents)

### `forge`
**Rôle** : Team Lead — orchestre les agents, décompose les US, gère les feedback loops
**Modèle** : **Opus 4.6** (obligatoire)
**Toujours présent** : oui (c'est l'orchestrateur principal)

### `stabilizer`
**Rôle** : Quality gate — build, tests, lint, type-check
**Modèle** : **Opus 4.6**
**Toujours présent** : oui (toujours en dernier dans le pipeline)
**Responsabilités** :
- Lancer les checks de stabilité (`bash scripts/stability-check.sh`)
- Corriger les problèmes simples directement
- Renvoyer les problèmes complexes à l'agent dev concerné

### `reviewer`
**Rôle** : Revue de code qualité + sécurité + accessibilité
**Modèle** : **Opus 4.6**
**Quand l'utiliser** : US de priorité haute ou touchant un domaine critique
**Responsabilités** :
- Vérifier le respect des règles du projet (`.claude/rules/`)
- Détecter les vulnérabilités (OWASP Top 10)
- Vérifier l'accessibilité mobile (WCAG AA)
- Produire un rapport structuré : critiques + suggestions

---

## Agents spécialisés mobile-first (pré-configurés)

### `mobile-dev`
**Rôle** : Développeur mobile-first — responsive, touch, viewport, performance
**Modèle** : **Opus 4.6**
**Skill** : `/mobile-dev`
**Domaine** : Composants responsive, interactions tactiles, viewport management, progressive enhancement
**Responsabilités** :
- Implémenter les composants avec CSS mobile-first (min-width)
- Gérer les touch interactions (44x44px min, Pointer Events API)
- Optimiser la performance mobile (LCP, FID, CLS)
- Utiliser les unités viewport modernes (dvh, svh)
- Gérer les safe-area-inset pour les notches

### `responsive-tester`
**Rôle** : Testeur responsive — breakpoints, viewports, touch, accessibilité
**Modèle** : **Opus 4.6**
**Skill** : `/responsive-tester`
**Domaine** : Tests multi-viewports, touch events, accessibilité mobile, Lighthouse audit
**Responsabilités** :
- Tester sur minimum 3 viewports (mobile, tablette, desktop)
- Vérifier les touch targets (44x44px WCAG)
- Auditer le contraste et l'accessibilité
- Valider les animations et transitions
- Vérifier le Lighthouse mobile score

### `pwa-dev`
**Rôle** : Spécialiste PWA — service worker, manifest, offline, installabilité
**Modèle** : **Opus 4.6**
**Skill** : `/pwa-dev`
**Domaine** : Service workers, stratégies de cache, web app manifest, offline-first UX
**Responsabilités** :
- Implémenter le service worker avec les bonnes stratégies de cache
- Configurer le web app manifest (icônes, couleurs, display)
- Gérer le fallback offline
- Assurer l'installabilité de l'app
- Versionner et nettoyer les caches

---

## Agents fallback (génériques)

### `architect`
**Modèle** : **Opus 4.6**
**Rôle** : Planification architecture (read-only)

### `developer`
**Modèle** : **Opus 4.6**
**Rôle** : Développeur générique

### `tester`
**Modèle** : **Opus 4.6**
**Rôle** : Tests unitaires et d'intégration

---

## Règles d'équipe

1. Le **stabilizer** intervient TOUJOURS en dernier
2. Les agents de planification (architect) interviennent TOUJOURS en premier
3. Au moins un agent de développement (*-dev) est TOUJOURS présent
4. L'ordre d'exécution suit l'ordre défini dans le body de l'issue GitHub
5. Le **forge** évalue le résultat de chaque agent avant de passer au suivant

## Modèles par catégorie

| Catégorie | Agents | Modèle |
|-----------|--------|--------|
| Orchestration | forge, init-project, next-feature | **Opus 4.6** |
| Planification | architect | **Opus 4.6** |
| Développement | mobile-dev, pwa-dev, developer | **Opus 4.6** |
| Revue | reviewer | **Opus 4.6** |
| Test | tester, responsive-tester | **Opus 4.6** |
| Validation | stabilizer | **Opus 4.6** |

## Types d'agents

| Catégorie | Pattern de nom | Rôle |
|-----------|---------------|------|
| Planification | `*-architect`, `architect` | Analyse et plan avant implémentation |
| Développement | `*-dev`, `developer` | Implémentation du code |
| Test | `*-tester`, `tester` | Écriture et exécution des tests |
| Qualité | `reviewer` | Revue de code |
| Validation | `stabilizer` | Quality gate finale |

## Orchestration : `/forge` vs `/next-feature`

| | `/next-feature` | `/forge` |
|---|---|---|
| **Modèle** | Opus 4.6 | Opus 4.6 |
| **Pipeline** | Pipeline linéaire | Team Lead avec feedback loops |
| **Agents** | Agents génériques | Agents spécialisés du projet |
| **Feedback** | Aucun | Boucles dev↔test, dev↔reviewer, stabilizer retry |
| **Décision** | Ordre fixe | Team Lead adapte selon les résultats |
| **Usage** | Features simples | Recommandé par défaut |
