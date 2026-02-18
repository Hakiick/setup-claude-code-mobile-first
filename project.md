# Setup Claude Code — Mobile-First Template

## Project overview

Template starter pour configurer Claude Code avec un workflow multi-agents optimisé pour le développement mobile-first. Ce template fournit une architecture complète d'agents spécialisés, de scripts d'automatisation, et de règles de qualité pour tout projet web mobile-first.

**Objectif** : Permettre à n'importe quel développeur de démarrer un projet mobile-first avec Claude Code en ayant immédiatement accès à un système d'agents structuré, des scripts de stabilité, et un workflow éprouvé.

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

## SEO & Performance

- Meta tags Open Graph + Twitter Cards
- Viewport meta tag correctement configuré
- Responsive images avec srcset
- Font preload
- Service Worker pour le cache (PWA)
- Score Lighthouse cible : > 90 sur les 4 métriques (mobile)
