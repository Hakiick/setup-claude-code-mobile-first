# Azure Deployment — Portfolio Apps

## Project overview

Déploiement sur Azure (PaaS) de 3 applications portfolio reconstruites. Chaque app utilise Azure App Service + Azure Database for PostgreSQL (si nécessaire). L'infrastructure est définie en Terraform et peut être créée/détruite à la demande.

**Objectif** : Déployer chaque app sur Azure avec un `terraform apply`, la rendre accessible publiquement, et pouvoir la détruire avec `terraform destroy` pour contrôler les coûts.

---

## Applications à déployer

### ChessGame
- **Stack** : Next.js 14, React 18, TypeScript, Tailwind CSS, Framer Motion
- **Runtime** : Node.js 20 LTS (natif App Service)
- **Database** : Non
- **Type** : SSR / Static export
- **Ports** : 3000 (Next.js default)
- **Health check** : `/`

### FakedIndeed
- **Stack** : Next.js, TypeScript, Tailwind CSS
- **Runtime** : Node.js 20 LTS (natif App Service)
- **Database** : PostgreSQL (utilisateurs, offres d'emploi)
- **Type** : Full-stack (API routes + SSR)
- **Ports** : 3000
- **Health check** : `/api/health`

### TimeManager (T-POO-700-STG_1)
- **Stack** : Elixir/Phoenix (backend) + Vue 3 (frontend) + PostgreSQL
- **Runtime** : Docker container (Elixir non supporté nativement sur App Service)
- **Database** : PostgreSQL (utilisateurs, time entries, teams)
- **Type** : Full-stack (API REST + SPA)
- **Ports** : 4000 (Phoenix), 5173 (Vue dev) → 80 en production
- **Health check** : `/api/health`

---

## Stack technique (déploiement)

- **IaC** : Terraform (~> 4.0 azurerm provider)
- **Container** : Docker (multi-stage builds)
- **CI/CD** : GitHub Actions
- **Cloud** : Azure (App Service + PostgreSQL Flexible Server)
- **SSL** : Géré par App Service (HTTPS par défaut)
- **Secrets** : terraform.tfvars (local) + GitHub Secrets (CI/CD)

---

## Architecture cible

```
Azure Resource Group: rg-portfolio-<env>
├── App Service Plan: asp-portfolio-<env>
│   ├── App Service: app-chessgame-<env>      (Node.js 20)
│   ├── App Service: app-fakedindeed-<env>    (Node.js 20)
│   └── App Service: app-timemanager-<env>    (Docker)
├── PostgreSQL Flexible Server: psql-portfolio-<env>
│   ├── Database: fakedindeed
│   └── Database: timemanager
└── (optionnel) Container Registry: crportfolio<env>
```

### Coût estimé (budget)
- App Service Plan B1 (shared) : ~$13/mois
- PostgreSQL Burstable B1ms : ~$15/mois
- **Total : ~$28/mois** (les 3 apps sur un plan partagé)
- `terraform destroy` → 0 euros

---

## Structure Terraform

```
terraform/
├── main.tf                  # Resource group, shared resources
├── variables.tf             # Variables globales
├── outputs.tf               # URLs des apps déployées
├── providers.tf             # Azure provider configuration
├── terraform.tfvars.example # Template de configuration
├── modules/
│   ├── app-service/         # Module App Service (Node.js ou Docker)
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── database/            # Module PostgreSQL Flexible Server
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── networking/          # Module VNet + NSG (optionnel)
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── apps/                    # Configuration par app
│   ├── chessgame.tf
│   ├── fakedindeed.tf
│   └── timemanager.tf
└── docker/                  # Dockerfiles par app
    ├── chessgame/
    │   └── Dockerfile
    ├── fakedindeed/
    │   └── Dockerfile
    └── timemanager/
        ├── Dockerfile.api   # Elixir/Phoenix
        └── Dockerfile.front # Vue 3 (build static → nginx)
```

---

## User Stories

### Phase 1 — Foundation (high priority)

- [US-01] Terraform base + modules | Créer le squelette Terraform : provider, resource group, modules app-service et database réutilisables, variables, outputs | haute
  - Team: architect, azure-infra, stabilizer

- [US-02] ChessGame deployment | Déployer ChessGame sur Azure App Service (Node.js). Pas de DB. URL accessible publiquement | haute | après:US-01
  - Team: azure-infra, docker-dev, stabilizer

### Phase 2 — Full-stack apps (high priority)

- [US-03] FakedIndeed deployment | Déployer FakedIndeed sur App Service (Node.js) + PostgreSQL. Migrations DB, variables d'environnement, health check | haute | après:US-01
  - Team: azure-infra, db-architect, docker-dev, stabilizer

- [US-04] TimeManager deployment | Déployer TimeManager (Elixir/Phoenix + Vue 3) via Docker. PostgreSQL, multi-container, build multi-stage | haute | après:US-01
  - Team: azure-infra, db-architect, docker-dev, stabilizer

### Phase 3 — CI/CD + Polish (medium priority)

- [US-05] GitHub Actions pipelines | Créer les workflows CI/CD pour les 3 apps : build, test, deploy to Azure on push to main | moyenne | après:US-02,US-03,US-04
  - Team: cicd-dev, stabilizer

- [US-06] Security audit + hardening | Audit sécurité : RBAC, network policies, secrets rotation, PostgreSQL SSL, App Service access restrictions | moyenne | après:US-05
  - Team: security-auditor, reviewer, stabilizer
