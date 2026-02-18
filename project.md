# Setup Claude Code — Mobile-First Template

## Project overview

Template starter pour configurer Claude Code avec un workflow multi-agents optimisé pour le développement mobile-first. Ce template fournit une architecture complète d'agents spécialisés, de scripts d'automatisation, et de règles de qualité pour tout projet web mobile-first.

**Objectif** : Permettre à n'importe quel développeur de démarrer un projet mobile-first avec Claude Code en ayant immédiatement accès à un système d'agents structuré, des scripts de stabilité, et un workflow éprouvé.

---

## Comment utiliser ce template

### 1. Copier le template dans votre projet

```bash
# Cloner le template
git clone https://github.com/Hakiick/setup-claude-code-mobile-first.git

# Copier les fichiers dans votre projet
cp -r setup-claude-code-mobile-first/.claude/ /chemin/vers/votre-projet/
cp -r setup-claude-code-mobile-first/scripts/ /chemin/vers/votre-projet/
cp setup-claude-code-mobile-first/CLAUDE.md /chemin/vers/votre-projet/

# Adapter project.md à votre projet
cp setup-claude-code-mobile-first/project.md /chemin/vers/votre-projet/
# Puis éditer project.md avec les infos de votre projet
```

### 2. Personnaliser

- Modifier `project.md` avec la description de votre projet, vos US, votre stack
- Les agents spécialisés seront auto-générés par `/init-project` en fonction de votre stack
- Les agents mobile-first (`mobile-dev`, `responsive-tester`, `pwa-dev`) sont pré-configurés

### 3. Lancer Claude Code

```bash
cd votre-projet
claude  # ou la commande Claude Code de votre environnement
# Puis lancez /init-project
```

---

## Stack technique (template par défaut)

> Adaptez cette section à votre projet réel avant de lancer `/init-project`.

- **Framework** : [Votre framework — Next.js, Astro, Remix, Nuxt, etc.]
- **UI** : [Votre lib UI — React, Vue, Svelte, etc.]
- **Styling** : [Tailwind CSS, CSS Modules, Styled Components, etc.]
- **Tests** : [Playwright, Vitest, Jest, Cypress, etc.]
- **Linter** : [ESLint, Biome, Prettier, etc.]
- **PWA** : Service Worker + Web App Manifest (optionnel)

---

## Architecture type mobile-first

```
src/
├── components/
│   ├── ui/                 # Composants UI réutilisables (Button, Card, Badge, etc.)
│   ├── layout/             # Layout, Nav, Footer, Sidebar
│   └── [sections]/         # Sections de votre app
├── data/                   # Données centralisées (pas de hardcoding dans les composants)
├── hooks/                  # Custom hooks (useMediaQuery, useViewport, useTouch, etc.)
├── lib/                    # Utilitaires (cn, animations, etc.)
├── styles/                 # Variables CSS, design system, breakpoints
├── pages/ ou app/          # Pages / Routes
└── public/
    ├── manifest.json       # Web App Manifest (PWA)
    └── sw.js               # Service Worker (PWA)
```

---

## Mobile-First Design Principles

### Breakpoints (min-width, progressive enhancement)

```css
/* Mobile first — pas de media query = mobile */
/* Small tablets */   @media (min-width: 640px)  { }
/* Tablets */         @media (min-width: 768px)  { }
/* Desktop */         @media (min-width: 1024px) { }
/* Large desktop */   @media (min-width: 1280px) { }
```

### Touch-First Interactions

- Zone de tap minimum : 44x44px (WCAG)
- Pas de hover-only interactions — toujours un fallback touch/click
- Swipe gestures pour la navigation (si pertinent)
- Focus visible pour la navigation clavier
- Safe-area-inset pour les notches/barres de navigation

### Performance Mobile

- **LCP** (Largest Contentful Paint) : < 2.5s
- **FID** (First Input Delay) : < 100ms
- **CLS** (Cumulative Layout Shift) : < 0.1
- **Bundle initial** : < 200KB gzipped
- **Images** : formats modernes (WebP/AVIF), srcset, lazy-loading
- **Fonts** : preload, subset, font-display: swap

### Progressive Enhancement

1. **Niveau 1 (mobile)** : contenu lisible, navigation fonctionnelle, formulaires utilisables
2. **Niveau 2 (tablette)** : layouts enrichis, sidebars, multi-colonnes
3. **Niveau 3 (desktop)** : animations avancées, hover effects, layouts complexes
4. **Niveau 4 (PWA)** : offline, push notifications, installation

---

## User Stories (template — à remplacer par les vôtres)

### Phase 1 — Foundation (high priority)

- [US-01] Setup projet + design system | Initialiser le projet avec la stack choisie, configurer le design system responsive, créer les composants UI de base, configurer les breakpoints mobile-first | haute
  - Team: mobile-dev, stabilizer

- [US-02] Layout responsive + navigation mobile | Créer le layout principal responsive, navigation mobile (hamburger menu ou bottom nav), sticky header, smooth scroll | haute | après:US-01
  - Team: mobile-dev, responsive-tester, stabilizer

### Phase 2 — Core features (high priority)

- [US-03] Pages principales (mobile-first) | Implémenter les pages principales avec design mobile-first, contenu responsive, images optimisées | haute | après:US-02
  - Team: mobile-dev, stabilizer

### Phase 3 — PWA + Polish (medium priority)

- [US-04] PWA setup | Configurer le service worker, web app manifest, icônes, splash screen, stratégie de cache offline-first | moyenne | après:US-03
  - Team: pwa-dev, stabilizer

- [US-05] Responsive polish + accessibility | Audit responsive complet, ARIA labels, contraste WCAG AA, focus management, touch targets, Lighthouse > 90 mobile | moyenne | après:US-03
  - Team: responsive-tester, reviewer, stabilizer

---

## Agents du template

### Agents core (communs à tous les projets)

| Agent | Rôle |
|-------|------|
| `forge` | Team Lead — orchestre les agents, feedback loops, livre stable |
| `stabilizer` | Quality gate — build, tests, lint, type-check |
| `reviewer` | Revue de code qualité + sécurité |
| `architect` | Planifie l'architecture technique |
| `developer` | Développeur générique |
| `tester` | Tests (unit, integration, e2e) |

### Agents spécialisés mobile-first

| Agent | Rôle |
|-------|------|
| `mobile-dev` | Développeur mobile-first — responsive, touch, viewport, performance |
| `responsive-tester` | Testeur responsive — breakpoints, viewports, touch, accessibility |
| `pwa-dev` | Spécialiste PWA — service worker, manifest, offline, installabilité |

### Agents auto-générés par `/init-project`

Selon votre stack, `/init-project` peut générer des agents supplémentaires :
- `frontend-dev` (React, Vue, Svelte...)
- `api-dev` (Express, Fastify, NestJS...)
- `db-architect` (PostgreSQL, MongoDB...)
- `e2e-tester` (Playwright, Cypress...)
- etc.

---

## SEO & Performance

- Meta tags Open Graph + Twitter Cards
- Viewport meta tag correctement configuré
- Responsive images avec srcset
- Font preload
- Service Worker pour le cache (PWA)
- Score Lighthouse cible : > 90 sur les 4 métriques (mobile)
