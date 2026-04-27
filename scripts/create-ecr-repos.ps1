# =============================================================================
# AIOps Project — ECR Repository Creation Script (PowerShell)
# =============================================================================

$services = @(
    "auth",
    "gateway",
    "orders",
    "order-service",
    "product-service",
    "user-service",
    "frontend",
    "assistant"
)

# Get current AWS region
$region = aws configure get region
if (-not $region) { $region = "eu-north-1" }

Write-Host "Creating ECR repositories in region: $region..." -ForegroundColor Cyan

foreach ($service in $services) {
    Write-Host "Creating repository: $service..." -ForegroundColor Yellow
    aws ecr create-repository `
        --repository-name $service `
        --region $region `
        --image-scanning-configuration scanOnPush=true `
        --encryption-configuration encryptionType=AES256 `
        | Out-Null

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Successfully created $service" -ForegroundColor Green
    } else {
        Write-Host "Repository $service already exists or error occurred." -ForegroundColor Gray
    }
}

Write-Host "Done! You can now re-run your CI pipeline." -ForegroundColor Cyan
