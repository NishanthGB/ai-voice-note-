# 🎙️ AI Voice Note Backend

Express.js backend for the AI Voice Note Tracker iOS app. Provides audio transcription, AI summarization, and note persistence via Firebase/Firestore.

**Production URL:** `https://ai-voice-note-backend-965903915503.us-central1.run.app`  
**Status:** 🟢 Live and Operational

---

## ✨ Features

- 🎧 **Audio Transcription** - OpenAI Whisper API
- 🤖 **AI Summarization** - OpenAI GPT-4o-mini
- 📝 **Note Management** - CRUD operations via Firebase Firestore
- 📧 **Contact Form** - Support message submission
- 🔐 **API Authentication** - x-api-key header validation
- ☁️ **Cloud Deployment** - Google Cloud Run

---

## 🚀 Quick Start

### Local Development

```bash
# Install dependencies
npm install

# Set up environment variables
cp .env.sample .env
# Edit .env with your API keys

# Start the server
npm start
# Server runs on http://localhost:5000
```

### Environment Variables

```env
API_KEY=your-backend-api-key
OPENAI_API_KEY=your-openai-api-key
PORT=5000
```

---

## 📁 Project Structure

```
ai-voice-note-backend/
├── server.js              # Main Express server
├── package.json           # Dependencies
├── Dockerfile            # Container config
├── openapi.yaml          # API specification
│
├── config/               # Configuration
│   ├── firebaseConfig.js # Firebase/Firestore setup
│   └── openaiConfig.js   # OpenAI client setup
│
├── controllers/          # Business logic
│   ├── transcriptionController.js  # Audio → text
│   ├── summaryController.js        # Text → AI summary
│   ├── noteController.js           # Note CRUD
│   └── contactController.js        # Contact form
│
├── routes/               # API endpoints
│   ├── transcriptionRoutes.js  # POST /upload
│   ├── summaryRoutes.js        # POST /summary
│   ├── noteRoutes.js           # /notes, /save-note
│   └── contactRoutes.js        # POST /contact
│
├── middleware/           # Express middleware
│   ├── authMiddleware.js       # API key validation
│   └── errorHandler.js         # Error responses
│
├── utils/                # Utilities
│   ├── fileHandler.js          # File operations
│   └── logger.js               # Winston logging
│
├── documentation/        # Documentation files
│   ├── DEPLOYMENT_INFO_FOR_IOS_DEV.md
│   ├── ENDPOINT_TEST_REPORT.md
│   └── ... (11 docs)
│
├── scripts/              # Deployment scripts
│   ├── deploy_to_gcp.ps1      # GCP deployment
│   └── quick-deploy.ps1        # Quick deploy
│
└── uploads/              # Temp audio files
```

---

## 🌐 API Endpoints

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET | `/health` | Health check | No |
| GET | `/` | Service info | No |
| POST | `/upload` | Transcribe audio | Yes |
| POST | `/summary` | Generate AI summary | Yes |
| POST | `/save-note` | Save note to Firebase | Yes |
| GET | `/notes?userId=X` | Get user's notes | Yes |
| DELETE | `/note/:id` | Delete note | Yes |
| POST | `/contact` | Submit contact form | Yes |

**Authentication:** Include `x-api-key` header with all authenticated requests.

---

## 📖 Documentation

- **[OpenAPI Specification](openapi.yaml)** - Complete API docs
- **[Postman Collection](postman_collection.json)** - API testing
- **[Postman Environment](postman_environment.json)** - Environment setup
- **[iOS Integration Guide](documentation/README_FOR_IOS_DEV.md)** - For iOS developers
- **[Deployment Guide](documentation/README_DEPLOY_GCP.md)** - Google Cloud Run setup
- **[All Documentation](documentation/)** - Complete documentation folder

---

## ☁️ Deployment

### Google Cloud Run (Production)

```bash
# Using deployment script
cd scripts
.\deploy_to_gcp.ps1

# Or manual deployment
gcloud run deploy ai-voice-note-backend \
  --source . \
  --region us-central1 \
  --platform managed \
  --allow-unauthenticated \
  --memory 1Gi \
  --project ai-voice-note-82ce3
```

**See [Deployment Guide](documentation/README_DEPLOY_GCP.md) for detailed instructions.**

---

## 🧪 Testing

### Health Check
```bash
curl https://ai-voice-note-backend-965903915503.us-central1.run.app/health
```

### With Postman
1. Import `postman_collection.json`
2. Import `postman_environment.json`
3. Update `apiKey` variable
4. Test all endpoints

### Test Summary Endpoint
```bash
curl -X POST \
  -H "x-api-key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"transcript":"Your text here"}' \
  https://ai-voice-note-backend-965903915503.us-central1.run.app/summary
```

---

## 🔧 Tech Stack

- **Runtime:** Node.js 18
- **Framework:** Express.js
- **Database:** Firebase Firestore
- **AI/ML:** OpenAI API (Whisper + GPT-4o-mini)
- **Deployment:** Google Cloud Run
- **Container:** Docker

---

## 📊 Status

**Backend:** 🟢 Operational  
**All Endpoints:** ✅ Working (8/8)  
**OpenAI Integration:** ✅ Active  
**Firebase Integration:** ✅ Connected  
**Production Deployment:** ✅ Live

---

## 📞 Support

- **Issues:** Check Cloud Run logs in GCP Console
- **Documentation:** See `documentation/` folder
- **API Testing:** Use Postman collection
- **iOS Integration:** See `documentation/README_FOR_IOS_DEV.md`

---

## 📝 License

MIT
