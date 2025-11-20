# Quick Cloud Run Deploy Script
# Run this script and DO NOT interrupt it - it takes 2-3 minutes

$ErrorActionPreference = "Continue"

Write-Host "=== Starting Cloud Run Deployment ===" -ForegroundColor Green
Write-Host "Project: ai-voice-note-82ce3"
Write-Host "Region: us-central1"
Write-Host "This will take 2-3 minutes. Please do not interrupt."
Write-Host ""

# Deploy to Cloud Run
Write-Host "Deploying to Cloud Run..." -ForegroundColor Yellow
gcloud run deploy ai-voice-note-backend `
  --source . `
  --region us-central1 `
  --platform managed `
  --allow-unauthenticated `
  --memory 1Gi `
  --concurrency 80 `
  --timeout 300 `
  --project ai-voice-note-82ce3 `
  --quiet

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "=== Deployment Successful! ===" -ForegroundColor Green
    
    # Attach secrets
    Write-Host "Attaching secrets..." -ForegroundColor Yellow
    gcloud run services update ai-voice-note-backend `
      --region us-central1 `
      --update-secrets API_KEY=BACKEND_API_KEY:latest,OPENAI_API_KEY=OPENAI_API_KEY:latest `
      --project ai-voice-note-82ce3
    
    # Get URL
    Write-Host ""
    $url = gcloud run services describe ai-voice-note-backend `
      --region us-central1 `
      --project ai-voice-note-82ce3 `
      --format="value(status.url)"
    
    Write-Host "=== DEPLOYMENT COMPLETE ===" -ForegroundColor Green
    Write-Host ""
    Write-Host "Backend URL: $url" -ForegroundColor Cyan
    Write-Host "Backend API Key: a3f2c9d4-6b8e-4f3a-9c2d-1b2e3f4a5b6c" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Test with:" -ForegroundColor Yellow
    Write-Host "curl -H `"x-api-key: a3f2c9d4-6b8e-4f3a-9c2d-1b2e3f4a5b6c`" $url/health"
    Write-Host ""
    Write-Host "Update your iOS Info.plist with:" -ForegroundColor Yellow
    Write-Host "  API_BASE_URL: $url"
    Write-Host "  API_KEY: a3f2c9d4-6b8e-4f3a-9c2d-1b2e3f4a5b6c"
} else {
    Write-Host ""
    Write-Host "=== Deployment Failed ===" -ForegroundColor Red
    Write-Host "Check the error messages above."
}
