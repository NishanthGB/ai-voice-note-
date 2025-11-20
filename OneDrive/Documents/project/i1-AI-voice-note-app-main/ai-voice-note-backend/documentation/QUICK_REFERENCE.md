# 🚀 Quick Reference - Backend Deployment

## Backend URL
```
https://ai-voice-note-backend-965903915503.us-central1.run.app
```

## iOS App Configuration (Info.plist)

```xml
<key>API_BASE_URL</key>
<string>https://ai-voice-note-backend-965903915503.us-central1.run.app</string>

<key>API_KEY</key>
<string>temporary-key-change-me</string>
```

⚠️ **Get the real API_KEY from backend team before production use**

## Test the Backend

```bash
# Health check
curl https://ai-voice-note-backend-965903915503.us-central1.run.app/health

# Expected: {"status":"ok"}
```

## All Endpoints Require Header
```
x-api-key: YOUR_API_KEY_HERE
```

## Main API Endpoints

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/health` | Health check (no auth) |
| POST | `/upload` | Upload audio for transcription |
| POST | `/summary` | Generate AI summary |
| POST | `/save-note` | Save note to Firebase |
| GET | `/notes?userId=XXX` | Get user's notes |
| POST | `/contact` | Submit contact form |

## Files for iOS Developer

1. ✅ `DEPLOYMENT_INFO_FOR_IOS_DEV.md` - Complete documentation
2. ✅ `postman_collection.json` - API testing
3. ✅ `postman_environment.json` - Environment setup
4. ✅ `openapi.yaml` - API specification
5. ✅ `README_FOR_IOS_DEV.md` - Integration guide

## Deployment Status
- ✅ Deployed to Google Cloud Run
- ✅ Health check passing
- ✅ Auto-scaling enabled
- ✅ CORS configured
- ⚠️ Need to update API_KEY with production value

## Next Steps
1. Share this folder with iOS developer
2. Provide real API_KEY securely (not in git)
3. iOS developer adds config to Info.plist
4. Test with Postman collection
5. Integrate APIClient.swift in iOS app
