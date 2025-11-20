# AI Voice Note Backend - Deployment Information for iOS Developer

## 🚀 Backend is Live!

**Service URL:** `https://ai-voice-note-backend-965903915503.us-central1.run.app`

**Deployment Date:** November 20, 2025

---

## ✅ Quick Setup for iOS App

### 1. Configure Info.plist in Xcode

Add or update these keys in your `Info.plist`:

```xml
<key>API_BASE_URL</key>
<string>https://ai-voice-note-backend-965903915503.us-central1.run.app</string>

<key>API_KEY</key>
<string>temporary-key-change-me</string>
```

**⚠️ IMPORTANT:** The `API_KEY` above is temporary. Contact the backend team for the actual production API key.

### 2. Test the Connection

The backend is deployed and responding. You can test the health endpoint:

```bash
curl https://ai-voice-note-backend-965903915503.us-central1.run.app/health
```

Expected response:
```json
{"status":"ok"}
```

---

## 📡 Available API Endpoints

### Health Check
- **GET** `/health`
- Returns: `{"status":"ok"}`

### Root
- **GET** `/`
- Returns: Service name, status, and uptime

### Audio Transcription
- **POST** `/upload`
- Headers: `x-api-key: YOUR_API_KEY`
- Body: `multipart/form-data` with `audio` file field
- Returns: `{"transcript": "..."}`

### Generate Summary
- **POST** `/summary`
- Headers: 
  - `x-api-key: YOUR_API_KEY`
  - `Content-Type: application/json`
- Body: `{"transcript": "your transcript text here"}`
- Returns: `{"title": "...", "summary": "...", "action_items": [...]}`

### Save Note
- **POST** `/save-note`
- Headers: 
  - `x-api-key: YOUR_API_KEY`
  - `Content-Type: application/json`
- Body: 
```json
{
  "userId": "user123",
  "title": "Note Title",
  "summary": "Note summary",
  "transcript": "Full transcript",
  "actionItems": ["item1", "item2"]
}
```
- Returns: `{"message": "Note saved successfully", "noteId": "..."}`

### Get Notes
- **GET** `/notes?userId=YOUR_USER_ID`
- Headers: `x-api-key: YOUR_API_KEY`
- Returns: Array of saved notes

### Contact Form
- **POST** `/contact`
- Headers: 
  - `x-api-key: YOUR_API_KEY`
  - `Content-Type: application/json`
- Body:
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "message": "Your message here"
}
```

---

## 🔑 Authentication

All API requests (except `/health` and `/`) require the `x-api-key` header:

```
x-api-key: YOUR_API_KEY_HERE
```

The iOS app should automatically include this header using the `APIClient.swift` class.

---

## 📱 iOS Integration

Your iOS project already includes `APIClient.swift` which handles all API communication. It will:

1. Read `API_BASE_URL` and `API_KEY` from Info.plist
2. Automatically add the `x-api-key` header to all requests
3. Handle errors and responses

Example usage in your Swift code:

```swift
// Upload audio
APIClient.shared.uploadAudio(fileURL: audioURL) { result in
    switch result {
    case .success(let transcript):
        print("Transcript: \(transcript)")
    case .failure(let error):
        print("Error: \(error)")
    }
}

// Generate summary
APIClient.shared.generateSummary(transcript: transcript) { result in
    // Handle result
}

// Save note
APIClient.shared.saveNote(note: noteData) { result in
    // Handle result
}

// Get notes
APIClient.shared.getNotes(userId: userId) { result in
    // Handle result
}
```

---

## 🧪 Testing with Postman

Two files are provided for API testing:
1. `postman_collection.json` - All API endpoints configured
2. `postman_environment.json` - Environment variables

**Steps to test:**
1. Import both files into Postman
2. Update the environment variables:
   - `baseUrl`: `https://ai-voice-note-backend-965903915503.us-central1.run.app`
   - `apiKey`: Get the actual key from backend team
   - `userId`: Use any test user ID like `tester`
3. Test each endpoint

---

## 🔧 Technical Details

### Deployment Platform
- **Platform:** Google Cloud Run
- **Region:** us-central1 (Iowa, USA)
- **Memory:** 1 GB
- **Concurrency:** Auto-scaling
- **Access:** Public (requires API key in headers)

### Dependencies
- Node.js 18
- Express.js
- Firebase Admin SDK
- OpenAI API
- Multer (file uploads)

### Environment Variables
The backend uses these environment variables:
- `API_KEY` - For authentication (required)
- `OPENAI_API_KEY` - For AI features (required)
- `PORT` - Set automatically by Cloud Run
- `GOOGLE_APPLICATION_CREDENTIALS` - Firebase service account

---

## 🐛 Troubleshooting

### 401 Unauthorized
- **Cause:** Missing or incorrect `x-api-key` header
- **Solution:** Verify the API key in Info.plist matches the backend key

### 500 Internal Server Error
- **Cause:** Backend configuration issue or missing OpenAI API key
- **Solution:** Contact backend team to check Cloud Run logs

### 502/503 Bad Gateway
- **Cause:** Service is restarting or cold start
- **Solution:** Wait a few seconds and retry. First request after idle may be slow.

### CORS Errors
- **Cause:** Backend CORS is configured, but double-check your request headers
- **Solution:** Ensure you're using the correct Content-Type header

---

## 📊 Monitoring & Logs

Backend logs are available in Google Cloud Console:
- [Cloud Run Service Dashboard](https://console.cloud.google.com/run/detail/us-central1/ai-voice-note-backend?project=ai-voice-note-82ce3)
- [Logs](https://console.cloud.google.com/logs/query?project=ai-voice-note-82ce3)

---

## 📞 Support

If you encounter any issues:
1. Check the troubleshooting section above
2. Review the API documentation in `openapi.yaml`
3. Contact the backend team with:
   - Error message
   - Request you're trying to make
   - API key being used (first/last 4 chars only)

---

## 🔄 Updates & Redeployment

**Note for Backend Team:** To redeploy with updated secrets:

1. Update secrets in GCP Secret Manager (requires proper IAM permissions)
2. Use the deployment script:
```powershell
cd ai-voice-note-backend
.\deploy_to_gcp.ps1
```

Or manually:
```powershell
gcloud run deploy ai-voice-note-backend \
  --source . \
  --region us-central1 \
  --platform managed \
  --service-account backend-runner@ai-voice-note-82ce3.iam.gserviceaccount.com \
  --allow-unauthenticated \
  --memory 1Gi \
  --project ai-voice-note-82ce3
```

---

## ✅ Checklist for iOS Developer

- [ ] Add `API_BASE_URL` to Info.plist
- [ ] Add `API_KEY` to Info.plist (get real key from backend team)
- [ ] Verify `APIClient.swift` is in your Xcode project
- [ ] Test `/health` endpoint with curl or browser
- [ ] Import Postman collection and test all endpoints
- [ ] Test audio upload with a real .m4a or .wav file
- [ ] Test the full flow: upload → summary → save → retrieve
- [ ] Handle error cases in your iOS app UI

---

**Happy Coding! 🎉**

For questions about the iOS app architecture, refer to `README_FOR_IOS_DEV.md` and `README_FOR_FRONTEND.md`.
