# 👋 iOS Developer Handoff Guide - AI Voice Note Tracker

**Hi Aditya!** This document has everything you need to integrate the backend with your iOS app.

---

## 🔗 Quick Links

**GitHub Repository:** https://github.com/NishanthGB/ai-voice-note-.git  
**Production Backend:** https://ai-voice-note-backend-965903915503.us-central1.run.app  
**Health Check:** https://ai-voice-note-backend-965903915503.us-central1.run.app/health

---

## 📥 Step 1: Clone the Repository

```bash
git clone https://github.com/NishanthGB/ai-voice-note-.git
cd ai-voice-note-
```

---

## 📮 Step 2: Import Postman Collection (Recommended First Step!)

**Files location:**
```
ai-voice-note-backend/
├── postman_collection.json      ← Import this
└── postman_environment.json     ← Then import this
```

**Import Steps:**
1. Open **Postman Desktop App** (download from https://www.postman.com/downloads/)
2. Click **"Import"** button (top left)
3. Drag and drop both JSON files
4. Select **"AI Voice Note Backend"** environment (top right dropdown)
5. Click the eye icon → Edit environment variables:
   - `baseUrl`: `https://ai-voice-note-backend-965903915503.us-central1.run.app`
   - `apiKey`: `/63HNY9eKaNXBwZQ0q/3WEmeEXl0r9C3Oj3tsK656c4=` (production key)
   - `userId`: `tester`

**Test all endpoints in this order:**
1. ✅ Health Check
2. ✅ Upload Audio (use .m4a file)
3. ✅ Generate Summary
4. ✅ Save Note
5. ✅ Get All Notes
6. ✅ Delete Note
7. ✅ Contact Form

📖 **Complete Postman guide:** See `POSTMAN_QUICK_GUIDE.md` in the repository root

---

## 📱 Step 3: Update iOS App Configuration

### Update Info.plist

Open `AN-Voice-Note-Tracker-App-Info.plist` and update:

```xml
<key>API_BASE_URL</key>
<string>https://ai-voice-note-backend-965903915503.us-central1.run.app</string>

<key>API_KEY</key>
<string>/63HNY9eKaNXBwZQ0q/3WEmeEXl0r9C3Oj3tsK656c4=</string>
```

### Verify APIClient.swift

The `APIClient.swift` file should already be reading these values:

```swift
// This is already configured in your app
guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String,
      let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
    // Error handling
}
```

---

## 🔑 Step 4: API Credentials

**Production API Key (Backend):**
```
/63HNY9eKaNXBwZQ0q/3WEmeEXl0r9C3Oj3tsK656c4=
```

**OpenAI API Key:**  
Already configured in the backend - you don't need to add this to your iOS app.

---

## 🌐 Step 5: API Endpoints Reference

All endpoints require `x-api-key` header (except `/health` and `/`)

### 1. Health Check
```
GET /health
```
**No authentication required**

---

### 2. Upload Audio & Transcribe
```
POST /upload
```
**Headers:**
```
x-api-key: /63HNY9eKaNXBwZQ0q/3WEmeEXl0r9C3Oj3tsK656c4=
Content-Type: multipart/form-data
```
**Body:** Form-data with audio file (key: `audio`)

**Supported formats:** `.m4a`, `.mp3`, `.wav`, `.mp4`, `.flac`, `.ogg`, `.webm`

**Response:**
```json
{
  "transcript": "Your transcribed text here..."
}
```

---

### 3. Generate AI Summary
```
POST /summary
```
**Headers:**
```
x-api-key: /63HNY9eKaNXBwZQ0q/3WEmeEXl0r9C3Oj3tsK656c4=
Content-Type: application/json
```
**Body:**
```json
{
  "transcript": "Your transcribed text..."
}
```

**Response:**
```json
{
  "title": "Meeting Summary Title",
  "summary": "Comprehensive summary...",
  "actionItems": ["Task 1", "Task 2"]
}
```

---

### 4. Save Note
```
POST /save-note
```
**Headers:**
```
x-api-key: /63HNY9eKaNXBwZQ0q/3WEmeEXl0r9C3Oj3tsK656c4=
Content-Type: application/json
```
**Body:**
```json
{
  "userId": "tester",
  "transcript": "Original transcript...",
  "summary": "AI generated summary...",
  "title": "Note title",
  "actionItems": ["Item 1", "Item 2"],
  "timestamp": "2025-11-20T10:30:00Z"
}
```

**Response:**
```json
{
  "success": true,
  "noteId": "abc123xyz456"
}
```

---

### 5. Get All Notes
```
GET /notes?userId=tester
```
**Headers:**
```
x-api-key: /63HNY9eKaNXBwZQ0q/3WEmeEXl0r9C3Oj3tsK656c4=
```

**Response:**
```json
{
  "notes": [
    {
      "id": "abc123",
      "title": "Meeting Notes",
      "summary": "Summary text...",
      "transcript": "Full transcript...",
      "actionItems": ["Task 1"],
      "timestamp": "2025-11-20T10:30:00Z"
    }
  ]
}
```

---

### 6. Delete Note
```
DELETE /note/{noteId}
```
**Headers:**
```
x-api-key: /63HNY9eKaNXBwZQ0q/3WEmeEXl0r9C3Oj3tsK656c4=
```

**Response:**
```json
{
  "success": true,
  "message": "Note deleted successfully"
}
```

---

### 7. Contact Form
```
POST /contact
```
**Headers:**
```
x-api-key: /63HNY9eKaNXBwZQ0q/3WEmeEXl0r9C3Oj3tsK656c4=
Content-Type: application/json
```
**Body:**
```json
{
  "name": "User Name",
  "email": "user@example.com",
  "message": "Support message or feedback..."
}
```

**Response:**
```json
{
  "message": "Contact submitted successfully",
  "contactId": "xyz789"
}
```

---

## 🔄 Step 6: iOS App Flow (Reference)

Here's how your iOS app should interact with the backend:

```
1. User Records Audio
   ↓
2. HomeViewModel.summaryResponseForTranscription()
   ↓
3. AIServiceHelper calls POST /upload
   → Returns: transcript
   ↓
4. AIServiceHelper.generateSummary(transcript)
   → Calls POST /summary
   → Returns: { title, summary, actionItems }
   ↓
5. Display in iOS UI
   ↓
6. User Saves Note
   ↓
7. AIServiceHelper.saveNote(...)
   → Calls POST /save-note
   → Saves to Firebase Firestore
   ↓
8. Success! Note appears in Notes list
```

---

## 🐛 Troubleshooting

### Issue: "401 Unauthorized: Invalid API key"

**Solution:**
- Check Info.plist has correct API_KEY: `/63HNY9eKaNXBwZQ0q/3WEmeEXl0r9C3Oj3tsK656c4=`
- Verify APIClient.swift is adding `x-api-key` header
- Test in Postman first to confirm backend is working

---

### Issue: "400 Unrecognized file format"

**Solution:**
- Use only supported formats: `.m4a`, `.mp3`, `.wav`, `.mp4`, `.flac`, `.ogg`, `.webm`
- iOS app should record in `.m4a` format (recommended)
- Check file is not corrupted

---

### Issue: Server taking too long to respond

**Current Status:** Backend is on Google Cloud Run (production) - should be fast

**If slow:**
- Check your internet connection
- Backend cold start takes ~2-3 seconds (first request)
- OpenAI API calls take 3-10 seconds (normal)
- Test with Postman to verify backend speed

---

### Issue: "404 Not Found"

**Solution:**
- Verify base URL: `https://ai-voice-note-backend-965903915503.us-central1.run.app`
- Check endpoint path (no typos)
- Test health check: `GET /health`

---

## 📚 Additional Documentation

**In the repository:**

1. **`README.md`** (root) - Complete project overview
2. **`POSTMAN_QUICK_GUIDE.md`** - Detailed Postman testing guide
3. **`GITHUB_PUSH_SUMMARY.md`** - Complete summary of what's included
4. **`ai-voice-note-backend/README.md`** - Backend-specific docs
5. **`ai-voice-note-backend/documentation/`** - 11 comprehensive guides including:
   - `README_FOR_IOS_DEV.md` - iOS integration guide
   - `DEPLOYMENT_INFO_FOR_IOS_DEV.md` - Deployment details
   - `ENDPOINT_TEST_REPORT.md` - All endpoints tested
   - `FRONTEND_BACKEND_INTEGRATION.md` - Integration details

---

## ✅ Testing Checklist

Before building the iOS app, verify in Postman:

- [ ] Health check returns 200 OK
- [ ] Upload audio file returns transcript
- [ ] Generate summary returns title, summary, action items
- [ ] Save note returns noteId
- [ ] Get notes returns array of notes
- [ ] Delete note returns success
- [ ] Contact form returns success

Once Postman tests pass, then:

- [ ] Update Info.plist with production URL and API key
- [ ] Build iOS app in Xcode
- [ ] Test recording → transcription flow
- [ ] Test summary generation
- [ ] Test save note
- [ ] Test notes list
- [ ] Test delete note
- [ ] Test contact form

---

## 🎯 Quick Start Summary

```bash
# 1. Clone repo
git clone https://github.com/NishanthGB/ai-voice-note-.git

# 2. Import Postman files (from ai-voice-note-backend/)
#    - postman_collection.json
#    - postman_environment.json

# 3. Update iOS Info.plist
#    API_BASE_URL: https://ai-voice-note-backend-965903915503.us-central1.run.app
#    API_KEY: /63HNY9eKaNXBwZQ0q/3WEmeEXl0r9C3Oj3tsK656c4=

# 4. Test in Postman

# 5. Build and run iOS app
```

---

## 💬 Support

**If you face any issues:**

1. **Test in Postman first** - If Postman works, issue is in iOS code
2. **Check logs** - Google Cloud Run logs available in GCP Console
3. **Compare responses** - Postman vs iOS app responses should match
4. **Review documentation** - Check the `documentation/` folder
5. **Contact Nishanth** - Share specific error messages

---

## 🔐 Important Security Notes

- ✅ Production API key is already configured
- ✅ OpenAI API key is in backend (you don't need it)
- ✅ Firebase credentials are in backend (you don't need them)
- ✅ All sensitive data is protected
- ⚠️ Don't commit API keys to git
- ⚠️ Use production keys only (not test_api_key_123)

---

## 📊 Backend Status

**Production URL:** https://ai-voice-note-backend-965903915503.us-central1.run.app  
**Status:** 🟢 Live and Operational  
**All 8 Endpoints:** ✅ Tested and Working  
**OpenAI Integration:** ✅ Active  
**Firebase Integration:** ✅ Connected  
**Deployment:** Google Cloud Run (us-central1)

---

## 🎉 You're All Set!

Everything is ready for integration. The backend is deployed, documented, and tested. Just clone the repo, import Postman collection, update Info.plist, and you're good to go!

**Need help?** All documentation is in the repository. Start with `README.md` and `POSTMAN_QUICK_GUIDE.md`.

---

*Last Updated: November 20, 2025*  
*Created by: Nishanth GB*  
*For: Aditya Choubisa (iOS Developer)*
