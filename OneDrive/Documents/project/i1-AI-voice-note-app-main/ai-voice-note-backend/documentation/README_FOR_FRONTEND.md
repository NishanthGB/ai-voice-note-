# Frontend Integration Guide — AI Voice Note Backend

This document explains how to set up and test the backend for the iOS frontend (AN-Voice Note Tracker App). Share this file with the iOS developer so they can connect the app to the API and test using Postman.

## Files to share with the iOS developer

- `openapi.yaml` — OpenAPI 3.0 spec describing the API. Import into Postman or other tools.
- `postman_collection.json` — Postman collection with Save Note, Get Notes, Upload audio, and Generate Summary requests.
- `.env.sample` — sample environment file for the backend. Copy to `.env` and fill values.

## Backend quick setup (for whoever runs the server)

### Local run (optional)

1. Install dependencies and start the server (in `ai-voice-note-backend`):

   npm install
   npm start

2. Create a `.env` from `.env.sample` and set values. Example:

   API_KEY=YOUR_API_KEY_HERE
   PORT=5000
   OPENAI_API_KEY=your_openai_api_key_here

3. Verify the server is running:

   curl -I http://localhost:5000

### Production (Cloud Run) URL

Once the backend is deployed to Google Cloud Run, the service will provide a public URL (example: `https://ai-voice-note-backend-xxxxx-uc.a.run.app`). Update the Postman environment and Info.plist to use that URL. No ngrok headers are needed in production.

## Postman usage

1. Import `postman_collection.json` into Postman (File → Import).
2. Select the provided environment `AI Voice Note - Cloud Run` (included in `postman_environment.json`).
   - `baseUrl` = `https://<YOUR_CLOUD_RUN_URL>`
   - `apiKey` = `YOUR_API_KEY_HERE`
   - `userId` = `tester`
3. Test the requests in the collection:
   - Save Note: POST /save-note (body sample included)
   - Get Notes: GET /notes?userId={{userId}}
   - Upload Audio: POST /upload (use form-data, field name `audio`)
   - Generate Summary: POST /summary with JSON `{ "transcript": "..." }`

## How the iOS developer should configure their project

Option A — Backend runs on the same Mac as Xcode

- No change required if `AIService.swift` DEBUG baseURL is `http://localhost:5000`.
- Ensure the backend `.env` `API_KEY` equals the value used in the app (replace with your secure key).

Option B — Backend runs on a different machine

- Find the backend machine's LAN IP (e.g., `192.168.1.100`).
- Update `AIService.swift` baseURL (or Info.plist `API_BASE_URL`) to `http://<BACKEND_IP>:5000`.
- Ensure Windows/macOS firewall allows inbound port 5000.

### Recommended configuration in Xcode (Info.plist)

Add these keys to Info.plist (so the app doesn't hardcode keys):

- `API_BASE_URL` = `https://<YOUR_CLOUD_RUN_URL>`
- `API_KEY` = `YOUR_API_KEY_HERE`

Then the `APIClient` (provided in `Home/ViewModel/APIClient.swift`) will read these values automatically.

## Testing the full flow (suggested)

1. Record or pick a small audio file (m4a) and test `/upload` in Postman.
2. Copy the returned `transcript` and POST it to `/summary` to get title/summary/action items.
3. POST `/save-note` with title/transcript/summary/userId.
4. GET `/notes?userId=...` to confirm persistence.

## How to share the project/files with the iOS developer

Preferred (clean & reproducible):

1. Push your branch to a Git hosting service (GitHub, GitLab, Bitbucket). Share the repo link and branch name.
2. Include `openapi.yaml`, `postman_collection.json`, and `.env.sample` in the repo (do NOT commit `.env`).

Quick alternatives:

- Zip the `ai-voice-note-backend` folder and send via Google Drive, Dropbox, or direct email attachment (avoid pushing secrets).
- Send the `postman_collection.json` and `openapi.yaml` via Slack/Email if you don't want to share the whole repo.

## Troubleshooting

-- If `/upload` or `/summary` return errors mentioning OpenAI, ensure `OPENAI_API_KEY` is set in Cloud Run environment variables or Secret Manager.
-- If the app cannot reach the backend, confirm the Cloud Run service is healthy and the `baseUrl` matches the deployed URL.
-- If the app receives 401 responses, confirm `x-api-key` header matches `API_KEY` in Cloud Run/Secret Manager environment variables.

If you want, I can produce a short email template you can paste into Slack or email to your friend with step-by-step actions.

---

## Sharing the backend with an iOS developer

- Preferred: deploy to Google Cloud Run (see `README_DEPLOY_GCP.md`) and share the permanent URL.
- Alternative local options (if Render is unavailable):
   - Provide LAN IP and open firewall port 5000.
   - Use ngrok or Cloudflare Tunnel to expose your local server temporarily (scripts remain in the repo for fallback use).
