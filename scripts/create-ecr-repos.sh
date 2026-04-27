#!/bin/bash
# =============================================================================
# AIOps Project — ECR Repository Creation Script
# Use this to create all required ECR repositories for the CI pipeline.
# =============================================================================

# List of services in our project
SERVICES=(
    "auth"
    "gateway"
    "orders"
    "order-service"
    "product-service"
    "user-service"
    "frontend"
    "assistant"
)

# Get current AWS region or default to eu-north-1
REGION=$(aws configure get region)
REGION=${REGION:-eu-north-1}

echo "Creating ECR repositories in region: $REGION..."

for SERVICE in "${SERVICES[@]}"; do
    echo "Creating repository: $SERVICE..."
    aws ecr create-repository \
        --repository-name "$SERVICE" \
        --region "$REGION" \
        --image-scanning-configuration scanOnPush=true \
        --encryption-configuration encryptionType=AES256 || \
    echo "Repository $SERVICE already exists or failed to create."
done

echo "Done! You can now re-run your CI pipeline."
