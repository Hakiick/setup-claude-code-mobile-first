# Règles de style de code (IaC)

## Terraform (HCL)
- `terraform fmt` avant chaque commit
- Variables typées avec `description` et `validation` quand pertinent
- Pas de valeurs hardcodées — utilise `variable` ou `locals`
- Outputs documentés avec `description`
- Resources nommées avec les conventions Azure (rg-, asp-, app-, psql-)
- Un module par ressource logique

## Dockerfile
- Multi-stage builds obligatoires
- Images Alpine ou distroless comme base runtime
- Utilisateur non-root
- HEALTHCHECK configuré
- .dockerignore complet

## YAML (GitHub Actions, docker-compose)
- Indentation à 2 espaces
- Pas de trailing whitespace
- Noms de jobs et steps explicites

## Général
- Pas de secrets en dur dans le code
- Pas de code commenté — supprimer ou créer une issue
- Nommage explicite, pas d'abréviations cryptiques
- Fichiers organisés logiquement par scope
