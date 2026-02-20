#!/bin/bash
# destroy.sh — Destroy infrastructure with Terraform
# Usage: bash scripts/destroy.sh [terraform-dir]

set -euo pipefail

TERRAFORM_DIR="${1:-terraform}"

echo "========================================="
echo "  DESTROY — Terraform Destroy"
echo "========================================="
echo ""

# Check terraform directory exists
if [ ! -d "$TERRAFORM_DIR" ]; then
  echo "ERROR: Terraform directory '$TERRAFORM_DIR' not found."
  exit 1
fi

# Check tfvars exists
if [ ! -f "$TERRAFORM_DIR/terraform.tfvars" ]; then
  echo "ERROR: $TERRAFORM_DIR/terraform.tfvars not found."
  exit 1
fi

# Show current state
echo "Current infrastructure:"
terraform -chdir="$TERRAFORM_DIR" state list 2>/dev/null || echo "  No state found."
echo ""

# Confirm destruction
echo "WARNING: This will destroy ALL infrastructure in '$TERRAFORM_DIR'."
echo "This action cannot be undone."
echo ""
read -p "Type 'destroy' to confirm: " confirm

if [ "$confirm" != "destroy" ]; then
  echo "Aborted."
  exit 0
fi

echo ""
echo "Destroying infrastructure..."
terraform -chdir="$TERRAFORM_DIR" destroy -auto-approve
echo ""

echo "========================================="
echo "  DESTROY COMPLETE ✓"
echo "  Infrastructure has been torn down."
echo "  Monthly cost: $0"
echo "========================================="
