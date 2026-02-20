---
paths:
  - "terraform/**/*.tf"
  - "**/*.tf"
---

# Règles Terraform

## Format et style

- **YOU MUST** formater avec `terraform fmt` avant chaque commit
- **YOU MUST** utiliser des types et descriptions pour toutes les variables
- **YOU MUST** documenter les outputs avec `description`
- **YOU MUST NOT** hardcoder des valeurs — tout en variables ou locals
- **YOU MUST NOT** utiliser `terraform apply` sans `terraform plan` d'abord

## Structure des modules

```
modules/<name>/
├── main.tf          # Resources
├── variables.tf     # Input variables (typed, documented, validated)
└── outputs.tf       # Output values (documented)
```

- Chaque module est autonome et testable indépendamment
- Pas de provider dans les modules (hérité du root)
- Pas de backend dans les modules (défini au root)

## Variables

```hcl
variable "example" {
  description = "What this variable controls"
  type        = string
  default     = "value"

  validation {
    condition     = length(var.example) > 0
    error_message = "Example must not be empty."
  }
}
```

- Marquer `sensitive = true` pour les secrets (passwords, keys, connection strings)
- Toujours fournir une `description`
- Utiliser des `validation` blocks quand pertinent

## Provider

```hcl
terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}
```

- Version du provider pinned avec `~>` (minor updates OK)
- `required_version` pour Terraform lui-même

## State

- State file en remote (Azure Storage) pour le travail en équipe
- Locking activé pour éviter les modifications concurrentes
- State local acceptable pour le développement solo

## Sécurité

- `terraform.tfvars` dans `.gitignore` (contient les secrets)
- `terraform.tfvars.example` committé (template sans valeurs sensibles)
- Variables sensibles marquées `sensitive = true`
- Pas de credentials dans les fichiers .tf
