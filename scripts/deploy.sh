#!/bin/bash
# deploy.sh — Deploy infrastructure with Terraform
# Usage: bash scripts/deploy.sh [terraform-dir]

set -euo pipefail

TERRAFORM_DIR="${1:-terraform}"

echo "========================================="
echo "  DEPLOY — Terraform Apply"
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
  echo "Copy terraform.tfvars.example to terraform.tfvars and fill in your values."
  exit 1
fi

# Run stability check first
echo "[1/4] Running stability check..."
if ! bash scripts/stability-check.sh; then
  echo ""
  echo "ERROR: Stability check failed. Fix issues before deploying."
  exit 1
fi
echo ""

# Init
echo "[2/4] Terraform init..."
terraform -chdir="$TERRAFORM_DIR" init -input=false
echo ""

# Plan
echo "[3/4] Terraform plan..."
terraform -chdir="$TERRAFORM_DIR" plan -input=false -out=tfplan
echo ""

# Apply
echo "[4/4] Terraform apply..."
echo "Review the plan above. Proceeding with apply..."
terraform -chdir="$TERRAFORM_DIR" apply tfplan
echo ""

# Cleanup plan file
rm -f "$TERRAFORM_DIR/tfplan"

echo "========================================="
echo "  DEPLOY COMPLETE ✓"
echo "========================================="
echo ""

# Show outputs
echo "Outputs:"
terraform -chdir="$TERRAFORM_DIR" output 2>/dev/null || echo "  No outputs defined."
