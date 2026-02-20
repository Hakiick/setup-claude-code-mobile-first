---
paths:
  - "terraform/**/*.tf"
  - ".github/workflows/*.yml"
---

# Règles Azure

## Naming conventions

```
Resource Group:        rg-<project>-<env>
App Service Plan:      asp-<project>-<env>
App Service:           app-<project>-<env>
PostgreSQL Server:     psql-<project>-<env>
Database:              db-<name>
Virtual Network:       vnet-<project>-<env>
Subnet:                snet-<project>-<purpose>
NSG:                   nsg-<project>-<env>
Container Registry:    cr<project><env>   (no hyphens, lowercase)
Key Vault:             kv-<project>-<env>
Storage Account:       st<project><env>   (no hyphens, lowercase)
```

- `<env>` : `dev`, `staging`, `prod`
- `<project>` : nom court du projet (lowercase, hyphens OK sauf exceptions)
- Tous les noms en lowercase

## App Service

- **YOU MUST** activer HTTPS only (`https_only = true`)
- **YOU MUST** définir `minimum_tls_version = "1.2"`
- **YOU MUST** désactiver FTPS (`ftps_state = "Disabled"`)
- **YOU MUST** activer HTTP/2 (`http2_enabled = true`)
- **YOU MUST** configurer un health check path
- `always_on = true` sauf pour le tier Free (F1)

## PostgreSQL Flexible Server

- **YOU MUST** activer SSL
- **YOU MUST** configurer les firewall rules (pas de 0.0.0.0/0 sauf dev)
- **YOU MUST** utiliser la version PostgreSQL 16
- SKU Burstable B1ms pour le portfolio (~$15/mois)
- Backup retention : 7 jours minimum
- Connection string via variable d'environnement (`DATABASE_URL`)

## Sécurité

- Managed Identity préférée aux service principals quand possible
- Secrets dans Key Vault ou variables d'environnement (pas en dur)
- NSG restrictif : autoriser uniquement le trafic nécessaire
- TLS 1.2 minimum partout

## Coûts

- Utiliser les SKU Burstable/Basic pour le portfolio
- `terraform destroy` quand l'infra n'est pas utilisée
- Partager un App Service Plan entre plusieurs apps quand possible
- Tags obligatoires : `project`, `environment`, `managed_by`

## Tags obligatoires

```hcl
tags = {
  project     = "<project-name>"
  environment = "<env>"
  managed_by  = "terraform"
}
```
