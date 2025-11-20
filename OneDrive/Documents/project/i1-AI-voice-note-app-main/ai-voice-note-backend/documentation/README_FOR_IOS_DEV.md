README for iOS Developer — Backend Handoff (Updated 2025-11-05)

This guide explains exactly what your iOS teammate needs to plug the Swift frontend into the Node/Express backend deployed on Google Cloud Run.

## What to hand over
- `README_FOR_IOS_DEV.md` (this file)
- `README_FOR_FRONTEND.md` (short Postman + backend primer)
- `postman_collection.json`
- `postman_environment.json` (points at the Render URL placeholder)
- `openapi.yaml`
- `AN-Voice Note Tracker App/Home/ViewModel/APIClient.swift` (drop-in HTTP client)
- `.env.sample` (never share your real `.env`)

## Runtime values to share explicitly
- Base URL: **https://<YOUR_CLOUD_RUN_URL>** (Cloud Run provides this after deployment)
- API key header: **x-api-key: YOUR_API_KEY_HERE** (stored in Secret Manager / Cloud Run env)

## Security reminders
- Keep `OPENAI_API_KEY` server-side only. Do **not** give it to the iOS developer.
- Rotate the short API key (`API_KEY` in Render) when you revoke access.

## How the iOS developer should configure the app
1. Open Xcode → Info.plist and set:
   - `API_BASE_URL` = `https://<YOUR_CLOUD_RUN_URL>`
   - `API_KEY` = `YOUR_API_KEY_HERE`
2. Ensure your project includes `Home/ViewModel/APIClient.swift` (already in repo). It automatically adds the API key header.
3. Build & run. The app can now call `APIClient.shared` methods (`uploadAudio`, `generateSummary`, `saveNote`, `getNotes`).

## If they prefer to run the backend themselves (localhost)
1. Copy `.env.sample` to `.env`, set `OPENAI_API_KEY` and `API_KEY`.
2. Install/start backend:
   ```powershell
   npm install
   npm start
   ```
3. Set Info.plist `API_BASE_URL = http://localhost:5000`.
4. Optional: run `./start-ngrok.ps1 -ForceRestart` only if you need a temporary tunnel (not required when using Render).

## Happy-path checks (Postman or curl)
1. `GET {{baseUrl}}/health` → `{ "status": "ok" }`
2. `POST {{baseUrl}}/upload` (form-data `audio` file) → `{ "transcript": "..." }`
3. `POST {{baseUrl}}/summary` with transcript JSON → `{ "title", "summary", "action_items" }`
4. `POST {{baseUrl}}/save-note` → `{ "message": "Note saved successfully", "noteId": "..." }`
5. `GET {{baseUrl}}/notes?userId=tester` → list of saved notes

- `baseUrl = https://<YOUR_CLOUD_RUN_URL>`
- `apiKey = YOUR_API_KEY_HERE`
- `userId = tester`

## Troubleshooting cheat sheet
- **401 Unauthorized** → `x-api-key` missing/mismatched.
- **500 AI errors** → backend missing valid `OPENAI_API_KEY`.
-- **Cloud Run 502/503** → service restarting or scaling; check Cloud Run logs in GCP console.

## Copy/paste status e-mail / Slack message
```

Hi! Backend is live on Cloud Run at https://<YOUR_CLOUD_RUN_URL> for the AN Voice Note app.

Set these in Info.plist:
• API_BASE_URL = https://<YOUR_CLOUD_RUN_URL>
• API_KEY = YOUR_API_KEY_HERE

Postman collection + environment attached. Headers already include x-api-key so you can test immediately. Ping me if you hit issues.
```

Need me to rotate the API key or redeploy? Just ask.