<#
PowerShell helper to deploy the backend to Cloud Run.
This script wraps the gcloud commands from README_DEPLOY_GCP.md and prompts for values.

Usage: run from the backend folder in PowerShell:
  .\deploy_to_gcp.ps1

This script will NOT run automatically—review it, then run. It expects you already ran `gcloud init`.
#>

Param()

Write-Host "Deploy helper for AI Voice Note Backend to Cloud Run"

# Defaults
$project = Read-Host "GCP project id (default: ai-voice-note-82ce3)" -Default "ai-voice-note-82ce3"
$region = Read-Host "Region (default: us-central1)" -Default "us-central1"
$saName = Read-Host "Service account name (default: backend-runner)" -Default "backend-runner"
$firebaseSaPath = Read-Host "Path to Firebase service account JSON (leave blank to skip)"

# Derived
$sa = "$saName@$project.iam.gserviceaccount.com"

Write-Host "Using project: $project, region: $region, service account: $sa"

Write-Host "Enabling required APIs..."
gcloud services enable run.googleapis.com cloudbuild.googleapis.com artifactregistry.googleapis.com secretmanager.googleapis.com firestore.googleapis.com logging.googleapis.com --project $project

Write-Host "Creating service account (if not exists)..."
gcloud iam service-accounts create $saName --display-name "Cloud Run service account for AI voice backend" --project $project || Write-Host "Service account may already exist"

Write-Host "Granting IAM roles to service account..."
gcloud projects add-iam-policy-binding $project --member="serviceAccount:$sa" --role="roles/datastore.user" || Write-Host "role assignment may have failed or already exist"
gcloud projects add-iam-policy-binding $project --member="serviceAccount:$sa" --role="roles/secretmanager.secretAccessor" || Write-Host "role assignment may have failed or already exist"
gcloud projects add-iam-policy-binding $project --member="serviceAccount:$sa" --role="roles/logging.logWriter" || Write-Host "role assignment may have failed or already exist"

Write-Host "Create secrets (will prompt for values). Press Ctrl+C to cancel."
$backendKey = Read-Host "Enter backend API_KEY value (x-api-key) (or press Enter to generate a random key)" -AsSecureString
if (-not $backendKey) { $plainBackendKey = [guid]::NewGuid().ToString() } else { $plainBackendKey = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($backendKey)) }
echo $plainBackendKey | gcloud secrets create BACKEND_API_KEY --data-file=- --project $project || (echo "secret may exist, adding new version"; echo $plainBackendKey | gcloud secrets versions add BACKEND_API_KEY --data-file=- --project $project)

$openAiKey = Read-Host "Enter your OpenAI API Key (or leave blank to skip)" -AsSecureString
if ($openAiKey) {
  $plainOpenAiKey = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($openAiKey))
  echo $plainOpenAiKey | gcloud secrets create OPENAI_API_KEY --data-file=- --project $project || (echo "secret may exist, adding new version"; echo $plainOpenAiKey | gcloud secrets versions add OPENAI_API_KEY --data-file=- --project $project)
}

if ($firebaseSaPath) {
  if (Test-Path $firebaseSaPath) {
    gcloud secrets create FIREBASE_SA --data-file="$firebaseSaPath" --project $project || (echo "secret may exist, adding new version"; gcloud secrets versions add FIREBASE_SA --data-file="$firebaseSaPath" --project $project)
  } else {
    Write-Host "WARNING: Firebase SA path not found: $firebaseSaPath. Skipping FIREBASE_SA creation."
  }
}

Write-Host "Deploying to Cloud Run (source build). This will take a few minutes..."
gcloud run deploy ai-voice-note-backend --source . --region $region --platform managed --service-account $sa --allow-unauthenticated --memory 1Gi --concurrency 1 --project $project

Write-Host "Binding secrets as environment variables (API_KEY, OPENAI_API_KEY if present)..."
if ($openAiKey) {
  gcloud run services update ai-voice-note-backend --region $region --update-secrets API_KEY=BACKEND_API_KEY:latest,OPENAI_API_KEY=OPENAI_API_KEY:latest --project $project
} else {
  gcloud run services update ai-voice-note-backend --region $region --update-secrets API_KEY=BACKEND_API_KEY:latest --project $project
}

if ($firebaseSaPath) {
  gcloud run services update ai-voice-note-backend --region $region --add-file-mount /secrets/firebase-sa.json=FIREBASE_SA:latest --project $project
  gcloud run services update ai-voice-note-backend --region $region --set-env-vars GOOGLE_APPLICATION_CREDENTIALS="/secrets/firebase-sa.json" --project $project
}

Write-Host "Deployment finished. Fetching service URL..."
$url = gcloud run services describe ai-voice-note-backend --region $region --project $project --format="value(status.url)"
Write-Host "Service URL: $url"
Write-Host "Health check:"
curl "$url/health"

Write-Host "Done. If you see issues check Cloud Run logs in GCP console or run gcloud logging read commands."
