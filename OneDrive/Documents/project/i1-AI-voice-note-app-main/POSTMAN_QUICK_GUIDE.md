# 📮 Postman Collection - Quick Guide for iOS Developer

## Overview

This document explains how to use the included Postman collection to test the AI Voice Note backend APIs. The Postman collection and environment files are included in the repository for easy testing and integration.

---

## 📥 Files Included

Located in `ai-voice-note-backend/`:

- **`postman_collection.json`** - Complete API test collection with all 8 endpoints
- **`postman_environment.json`** - Environment configuration with variables

---

## 🚀 Quick Setup

### Step 1: Import to Postman

1. **Download Postman Desktop App**
   - Visit: https://www.postman.com/downloads/
   - Install the desktop application (recommended over web version for file uploads)

2. **Import Collection**
   - Open Postman
   - Click **"Import"** button (top left)
   - Drag and drop `postman_collection.json`
   - Or click "Upload Files" and select the file

3. **Import Environment**
   - Click **"Import"** again
   - Drag and drop `postman_environment.json`
   - Or select the file manually

### Step 2: Configure Environment

1. **Select Environment**
   - Click the environment dropdown (top right)
   - Select **"AI Voice Note Backend"**

2. **Update Variables**
   - Click the "eye" icon next to environment dropdown
   - Edit these variables:

   ```
   baseUrl: https://ai-voice-note-backend-965903915503.us-central1.run.app
   apiKey: [YOUR_PRODUCTION_API_KEY]
   userId: tester
   ```

   **Important:** Get the production `apiKey` from the project owner or check the backend `.env` file.

---

## 🧪 Testing Endpoints

The collection includes these requests in order:

### 1. Health Check ✅
**GET** `/health`

- No authentication required
- Tests if backend is running
- Expected response: `200 OK` with `{ status: "ok" }`

**Usage:**
```
Click "Send" - should return immediately
```

---

### 2. Get Service Info ℹ️
**GET** `/`

- No authentication required
- Returns service name and version
- Expected response: `200 OK`

---

### 3. Upload Audio 🎤
**POST** `/upload`

- **Authentication:** Required (`x-api-key` header)
- **Body:** Form-data with audio file
- Transcribes audio using OpenAI Whisper
- Expected response: `200 OK` with `{ transcript: "..." }`

**How to test:**
1. Click on the request
2. Go to "Body" tab
3. Ensure "form-data" is selected
4. Click "Select Files" for the `audio` key
5. Choose a `.m4a`, `.mp3`, or `.wav` file
6. Click "Send"

**Example Response:**
```json
{
  "transcript": "This is a test recording about meeting notes."
}
```

---

### 4. Generate Summary 🤖
**POST** `/summary`

- **Authentication:** Required (`x-api-key` header)
- **Body:** JSON with transcript text
- Uses GPT-4o-mini to generate smart summary
- Expected response: Summary with title and action items

**Pre-filled Body:**
```json
{
  "transcript": "Today we had a team meeting to discuss the Q4 roadmap..."
}
```

**Example Response:**
```json
{
  "summary": "Team discussed Q4 roadmap priorities...",
  "title": "Q4 Team Meeting - Product Roadmap",
  "actionItems": [
    "Review design mockups by Friday",
    "Schedule follow-up with stakeholders"
  ]
}
```

---

### 5. Save Note 💾
**POST** `/save-note`

- **Authentication:** Required
- **Body:** JSON with note details
- Saves to Firebase Firestore
- Expected response: Note ID

**Pre-filled Body:**
```json
{
  "userId": "{{userId}}",
  "transcript": "Sample transcript text",
  "summary": "Sample summary",
  "title": "Test Note",
  "actionItems": ["Item 1", "Item 2"],
  "timestamp": "2025-11-20T10:30:00Z"
}
```

**Example Response:**
```json
{
  "success": true,
  "noteId": "abc123xyz456"
}
```

---

### 6. Get All Notes 📋
**GET** `/notes?userId={{userId}}`

- **Authentication:** Required
- **Query Params:** `userId` (from environment variable)
- Retrieves all notes for user
- Expected response: Array of notes

**Example Response:**
```json
{
  "notes": [
    {
      "id": "abc123",
      "title": "Team Meeting Notes",
      "summary": "Discussed Q4 roadmap...",
      "timestamp": "2025-11-20T10:30:00Z"
    },
    {
      "id": "def456",
      "title": "Project Update",
      "summary": "Progress on new features...",
      "timestamp": "2025-11-19T14:20:00Z"
    }
  ]
}
```

---

### 7. Delete Note 🗑️
**DELETE** `/note/:id`

- **Authentication:** Required
- **Path Params:** `noteId` (update in URL)
- Deletes specific note
- Expected response: Success message

**How to test:**
1. First run "Get All Notes" to see available note IDs
2. Copy a note ID
3. In this request, replace `:id` in URL with the copied ID
4. Click "Send"

**Example Response:**
```json
{
  "success": true,
  "message": "Note deleted successfully"
}
```

---

### 8. Contact Form 📧
**POST** `/contact`

- **Authentication:** Required
- **Body:** JSON with contact message
- Submits support/feedback message
- Expected response: Success confirmation

**Pre-filled Body:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "message": "I have a question about the app..."
}
```

---

## 🔑 Authentication

All endpoints (except `/health` and `/`) require the `x-api-key` header.

**How it works:**
- The environment variable `{{apiKey}}` is automatically added to request headers
- Postman replaces `{{apiKey}}` with the actual value from your environment
- No need to manually add headers for each request

**To verify headers:**
1. Click on any authenticated request
2. Go to "Headers" tab
3. You should see: `x-api-key: {{apiKey}}`

---

## 🧪 Testing Workflow

### Full Integration Test

1. **Health Check** → Verify backend is running
2. **Upload Audio** → Get transcript
3. **Generate Summary** → Get AI summary from transcript
4. **Save Note** → Store in Firestore
5. **Get All Notes** → Verify note was saved
6. **Delete Note** → Clean up test data

### Testing Audio Upload

**Prepare test audio:**
- Format: `.m4a`, `.mp3`, or `.wav`
- Duration: 5-30 seconds recommended for testing
- Content: Speak clearly about a topic (meeting notes, ideas, etc.)

**Expected behavior:**
- Upload should complete in 3-10 seconds
- Transcript should match your spoken words
- Quality depends on audio clarity

---

## 🐛 Troubleshooting

### Error: 401 Unauthorized
**Cause:** Missing or invalid API key

**Fix:**
1. Check environment is selected (top right)
2. Verify `apiKey` variable is set correctly
3. Confirm you're using the production API key

---

### Error: 404 Not Found
**Cause:** Wrong base URL or endpoint path

**Fix:**
1. Check `baseUrl` in environment matches production URL
2. Verify endpoint path is correct (no typos)

---

### Error: 500 Internal Server Error
**Cause:** Backend issue (OpenAI API, Firebase, etc.)

**Fix:**
1. Check Cloud Run logs in GCP Console
2. Verify OpenAI API key is valid and has credits
3. Confirm Firebase service account is properly configured

---

### Upload Audio Not Working
**Cause:** File format or size issue

**Fix:**
1. Ensure file is `.m4a`, `.mp3`, or `.wav`
2. Keep file size under 25MB
3. Use Postman Desktop (not web version) for file uploads

---

## 📱 iOS Integration Testing

### Step 1: Test Individual Endpoints
Use Postman to verify each endpoint works correctly before integrating with iOS app.

### Step 2: Compare iOS Responses
When iOS app makes requests, responses should match what you see in Postman.

### Step 3: Debug iOS Issues
If iOS app fails but Postman works:
- Check `Info.plist` has correct `API_BASE_URL` and `API_KEY`
- Verify `APIClient.swift` is adding `x-api-key` header
- Confirm audio file format matches what Postman uses

---

## 📊 Expected Response Times

| Endpoint | Typical Time | Notes |
|----------|--------------|-------|
| Health Check | < 100ms | Instant |
| Get Service Info | < 100ms | Instant |
| Upload Audio | 3-10s | Depends on audio length |
| Generate Summary | 2-5s | AI processing time |
| Save Note | < 500ms | Firebase write |
| Get All Notes | < 500ms | Firebase read |
| Delete Note | < 300ms | Firebase delete |
| Contact Form | < 500ms | Firebase write |

---

## 🎯 Quick Reference

### Production Values
```
Backend URL: https://ai-voice-note-backend-965903915503.us-central1.run.app
API Key: [Ask project owner]
Test User ID: tester
```

### Common Headers
```
x-api-key: [Your API Key]
Content-Type: application/json (for JSON requests)
Content-Type: multipart/form-data (for file uploads)
```

### Sample cURL (for reference)
```bash
# Health Check
curl https://ai-voice-note-backend-965903915503.us-central1.run.app/health

# Generate Summary
curl -X POST \
  -H "x-api-key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"transcript":"Test transcript"}' \
  https://ai-voice-note-backend-965903915503.us-central1.run.app/summary
```

---

## 📚 Additional Resources

- **OpenAPI Spec:** `ai-voice-note-backend/openapi.yaml`
- **Backend README:** `ai-voice-note-backend/README.md`
- **iOS Integration Guide:** `ai-voice-note-backend/documentation/README_FOR_IOS_DEV.md`
- **Deployment Info:** `ai-voice-note-backend/documentation/DEPLOYMENT_INFO_FOR_IOS_DEV.md`

---

## 💡 Tips for iOS Developer

1. **Always test in Postman first** before troubleshooting iOS code
2. **Use the same audio file** in Postman and iOS app to compare results
3. **Check response times** - if Postman is slow, iOS will be too
4. **Save successful requests** in Postman as examples for iOS implementation
5. **Update environment variables** when switching between local and production backends

---

**Need Help?**
- Check backend logs in Google Cloud Run Console
- Review `documentation/` folder for detailed guides
- Test with `curl` commands if Postman has issues

---

*Last Updated: November 20, 2025*
