---
paths:
  - "**/Dockerfile*"
  - "**/docker-compose*.yml"
  - "**/.dockerignore"
---

# Règles Docker

## Dockerfile

- **YOU MUST** utiliser des multi-stage builds (séparer build et runtime)
- **YOU MUST** utiliser des images Alpine ou distroless comme base runtime
- **YOU MUST** exécuter en tant qu'utilisateur non-root (USER node, USER nobody)
- **YOU MUST** inclure un HEALTHCHECK dans chaque Dockerfile de production
- **YOU MUST** créer un `.dockerignore` complet
- **YOU MUST NOT** copier des fichiers secrets dans les layers (.env, credentials)
- **YOU MUST NOT** utiliser le tag `:latest` en production — utiliser des versions fixes
- **YOU MUST NOT** exécuter `apt-get upgrade` dans les builds (non reproductible)

## Multi-stage pattern

```dockerfile
# Stage 1: Build
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build

# Stage 2: Runtime
FROM node:20-alpine AS runner
WORKDIR /app
RUN addgroup -g 1001 -S appgroup && adduser -S appuser -u 1001
COPY --from=builder --chown=appuser:appgroup /app/dist ./dist
USER appuser
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://localhost:3000/health || exit 1
CMD ["node", "dist/server.js"]
```

## .dockerignore (minimum)

```
node_modules
.git
.env
.env.*
*.md
.github
terraform
.claude
.forge
```

## Docker Compose

- Services nommés explicitement
- Ports mappés uniquement si nécessaire
- Health checks sur chaque service
- Variables d'environnement via `.env` file (pas en dur)
- Volumes nommés pour la persistance (pas de bind mounts en prod)

## Sécurité

- Images scannées pour les vulnérabilités
- Pas de secrets dans les ARG ou ENV du Dockerfile
- Filesystem read-only quand possible
- Limiter les capabilities
