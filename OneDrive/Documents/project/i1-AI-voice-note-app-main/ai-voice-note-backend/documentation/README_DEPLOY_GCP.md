# Deploying AI Voice Note Backend to Google Cloud Run

This document gives step-by-step, copy-paste commands to deploy the backend to Google Cloud Run. It assumes you already ran `gcloud init` and selected project `ai-voice-note-82ce3` (the project you used earlier).

Summary
- Target: Cloud Run (managed)
- Build: either Cloud Buildpacks (`gcloud run deploy --source .`) or Dockerfile + Cloud Build
- Secrets: stored in Secret Manager (API key, OpenAI key, Firebase service account JSON)
- Service account: create `backend-runner` for Cloud Run with minimal roles

Notes before you begin
- Keep your source code as-is; `server.js` honors `process.env.PORT`.
- If you want production Firestore, provide a Firebase service account JSON and mount it as a secret.
- The repository already contains `Dockerfile` and `openapi.yaml`.

Step 0 — Change to backend directory
```powershell
cd "D:\nish\Downloads\i1-AI-voice-note-app-main (1)\i1-AI-voice-note-app-main\ai-voice-note-backend"
```

Step 1 — Enable required APIs (run once)
```powershell
gcloud services enable run.googleapis.com cloudbuild.googleapis.com `
  artifactregistry.googleapis.com secretmanager.googleapis.com `
  firestore.googleapis.com logging.googleapis.com
```

Step 2 — Create a Cloud Run service account and grant minimal roles
```powershell
$PROJECT="ai-voice-note-82ce3"
gcloud iam service-accounts create backend-runner --display-name "Cloud Run service account for AI voice backend"
$SA="backend-runner@$PROJECT.iam.gserviceaccount.com"

gcloud projects add-iam-policy-binding $PROJECT --member="serviceAccount:$SA" --role="roles/datastore.user"
gcloud projects add-iam-policy-binding $PROJECT --member="serviceAccount:$SA" --role="roles/secretmanager.secretAccessor"
gcloud projects add-iam-policy-binding $PROJECT --member="serviceAccount:$SA" --role="roles/logging.logWriter"
```

Step 3 — Add secrets to Secret Manager
- Create secrets for your API key and OpenAI key. Replace values with yours.
```powershell
gcloud secrets create BACKEND_API_KEY --data-file=- <<EOF
YOUR_API_KEY_HERE
EOF

gcloud secrets create OPENAI_API_KEY --data-file=- <<EOF
sk-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
EOF
```

- If using Firebase/Firestore in production, create a secret from your service account JSON:
```powershell
gcloud secrets create FIREBASE_SA --data-file="C:\path\to\firebase-service-account.json"
```

Step 4 — Deploy to Cloud Run (source build, simplest)
```powershell
gcloud run deploy ai-voice-note-backend `
  --source . `
  --region us-central1 `
  --platform managed `
  --service-account $SA `
  --allow-unauthenticated `
  --memory 1Gi `
  --concurrency 1
```

Notes:
- The command above builds and deploys the application. On completion it prints the service URL.

Step 5 — Bind secrets as environment variables
```powershell
gcloud run services update ai-voice-note-backend `
  --region us-central1 `
  --update-secrets API_KEY=BACKEND_API_KEY:latest,OPENAI_API_KEY=OPENAI_API_KEY:latest
```

Step 6 — Mount Firebase SA JSON and set GOOGLE_APPLICATION_CREDENTIALS (optional)
```powershell
gcloud run services update ai-voice-note-backend `
  --region us-central1 `
  --add-file-mount /secrets/firebase-sa.json=FIREBASE_SA:latest

gcloud run services update ai-voice-note-backend `
  --region us-central1 `
  --set-env-vars GOOGLE_APPLICATION_CREDENTIALS="/secrets/firebase-sa.json"
```

Step 7 — Verify deployment and test endpoints
```powershell
# Get service URL
$URL = gcloud run services describe ai-voice-note-backend --region us-central1 --format="value(status.url)"
echo $URL

# Health check
curl "$URL/health"

# Test contact endpoint (header x-api-key must match the secret value you set)
curl -X POST "$URL/contact" -H "x-api-key: YOUR_API_KEY_HERE" -H "Content-Type: application/json" -d '{"email":"you@example.com","subject":"test","description":"hello"}'
```

Troubleshooting & tips
- If you see permission errors for Firestore, ensure the `backend-runner` service account has Firestore role and the correct project.
- If you get out-of-memory errors during transcription, increase `--memory` to 2Gi or more.
- Cloud Run's filesystem is ephemeral — use Cloud Storage for persistent uploads.

Rollbacks
- You can re-deploy a previous revision in the Cloud Run console or use `gcloud run revisions list` and `gcloud run services update-traffic`.

CI/CD
- Consider adding a Cloud Build trigger or GitHub Actions to build and deploy from `main` automatically.
