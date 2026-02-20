---
paths:
  - "terraform/**/*.tf"
  - "**/Dockerfile*"
  - ".github/workflows/*.yml"
---

# Règles de stabilité

- IMPORTANT : Après toute modification d'infrastructure, lance /stabilizer ou vérifie manuellement terraform validate + plan + fmt
- Ne désactive jamais un check existant pour "faire passer" une feature
- Ne supprime jamais une règle de validation sans justification documentée
- Chaque feature doit être stable AVANT de passer à la suivante
- `terraform validate` doit passer après chaque modification de .tf
- `terraform fmt -check` doit passer avant chaque commit
- `terraform plan` ne doit pas montrer de destructions non voulues
- Les Dockerfiles doivent builder sans erreur
- Les workflows GitHub Actions doivent être syntaxiquement valides
