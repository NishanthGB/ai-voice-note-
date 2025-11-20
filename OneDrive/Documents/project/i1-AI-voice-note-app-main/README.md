# 🎙️ AI Voice Note Tracker

Complete iOS app with Express.js backend for AI-powered voice note transcription and summarization.

**Backend (Production):** `https://ai-voice-note-backend-965903915503.us-central1.run.app`  
**Status:** 🟢 Live and Operational

---

## 📱 Project Overview

AI Voice Note Tracker is a full-stack application that transforms voice recordings into organized, AI-summarized notes. Record audio on iOS, get instant transcription via OpenAI Whisper, and receive intelligent summaries powered by GPT-4o-mini.

### Key Features

- 🎤 **Voice Recording** - Native iOS audio capture
- 🤖 **AI Transcription** - OpenAI Whisper API
- ✨ **Smart Summarization** - GPT-4o-mini with title generation and action items
- 📝 **Note Management** - Full CRUD with Firebase Firestore
- ☁️ **Cloud Backend** - Deployed on Google Cloud Run
- 🔐 **Secure API** - x-api-key authentication
- 📧 **Contact Form** - Built-in support messaging

---

## 🏗️ Architecture

```
┌─────────────────┐
│   iOS App       │ Swift + SwiftUI
│  (Frontend)     │ 
└────────┬────────┘
         │ HTTPS
         │ x-api-key
         ↓
┌─────────────────┐
│  Cloud Run      │ Express.js + Node.js 18
│  (Backend)      │ 
└────────┬────────┘
         │
    ┌────┴────┐
    ↓         ↓
┌────────┐ ┌──────────┐
│ OpenAI │ │ Firebase │
│  API   │ │Firestore │
└────────┘ └──────────┘
```

---

## 📁 Project Structure

```
i1-AI-voice-note-app-main/
│
├── ai-voice-note-backend/          # Node.js Express Backend
│   ├── server.js                   # Main server
│   ├── config/                     # Firebase + OpenAI config
│   ├── controllers/                # Business logic
│   ├── routes/                     # API endpoints
│   ├── middleware/                 # Auth + error handling
│   ├── utils/                      # Utilities
│   ├── documentation/              # 11 comprehensive docs
│   ├── scripts/                    # Deployment scripts
│   ├── postman_collection.json     # 📮 API testing
│   ├── postman_environment.json    # 📮 Environment setup
│   └── README.md                   # Backend docs
│
├── AN-Voice Note Tracker App/      # iOS Swift App
│   ├── AN_Voice_Note_Tracker_AppApp.swift  # App entry
│   ├── MainTabView.swift           # Tab navigation
│   ├── Home/                       # Recording + transcription
│   │   └── ViewModel/
│   │       ├── HomeViewModel.swift # Recording logic
│   │       └── APIClient.swift     # Backend API client
│   ├── Notes/                      # Note list + detail views
│   ├── Settings/                   # App settings
│   ├── Service/                    # API helpers
│   └── AppleAPIs/                  # Speech recognition
│
├── AN-Voice Note Tracker App.xcodeproj/  # Xcode project
│
└── README.md                       # 👈 This file
```

---

## 🚀 Quick Start

### Prerequisites

- **Backend:**
  - Node.js 18+
  - Google Cloud account (for deployment)
  - OpenAI API key
  - Firebase project

- **iOS App:**
  - macOS with Xcode 14+
  - iOS 16+ device/simulator
  - Apple Developer account (for device testing)

### 1️⃣ Backend Setup

```bash
# Navigate to backend
cd ai-voice-note-backend

# Install dependencies
npm install

# Set up environment variables
# Create .env file with:
API_KEY=your-backend-api-key
OPENAI_API_KEY=your-openai-api-key
PORT=5000

# Start local server
npm start
# Server runs on http://localhost:5000
```

**For Production Deployment:**
```bash
# Deploy to Google Cloud Run
cd scripts
.\deploy_to_gcp.ps1
```

See [`ai-voice-note-backend/documentation/README_DEPLOY_GCP.md`](ai-voice-note-backend/documentation/README_DEPLOY_GCP.md) for detailed deployment instructions.

### 2️⃣ iOS App Setup

1. **Open in Xcode:**
   ```bash
   open "AN-Voice Note Tracker App.xcodeproj"
   ```

2. **Configure Backend URL:**
   - Open `AN-Voice-Note-Tracker-App-Info.plist`
   - Update these keys:
     ```xml
     <key>API_BASE_URL</key>
     <string>https://ai-voice-note-backend-965903915503.us-central1.run.app</string>
     <key>API_KEY</key>
     <string>your-production-api-key</string>
     ```

3. **Build and Run:**
   - Select target device/simulator
   - Press `Cmd+R` to build and run

See [`ai-voice-note-backend/documentation/README_FOR_IOS_DEV.md`](ai-voice-note-backend/documentation/README_FOR_IOS_DEV.md) for iOS integration details.

---

## 📮 API Testing with Postman

### Quick Setup

1. **Import Collection:**
   - Open Postman
   - Import `ai-voice-note-backend/postman_collection.json`

2. **Import Environment:**
   - Import `ai-voice-note-backend/postman_environment.json`
   - Update these variables:
     - `baseUrl`: Your backend URL
     - `apiKey`: Your API key

3. **Test Endpoints:**
   - Health Check → Verify backend is running
   - Upload Audio → Test transcription
   - Generate Summary → Test AI summarization
   - Save Note → Test Firebase integration
   - Get Notes → Retrieve all notes
   - Delete Note → Test deletion

### Available Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/health` | Health check |
| GET | `/` | Service info |
| POST | `/upload` | Transcribe audio |
| POST | `/summary` | Generate AI summary |
| POST | `/save-note` | Save note to Firestore |
| GET | `/notes?userId=X` | Get user notes |
| DELETE | `/note/:id` | Delete note |
| POST | `/contact` | Submit contact form |

**Authentication:** All endpoints (except `/health` and `/`) require `x-api-key` header.

---

## 🔧 Technology Stack

### Backend
- **Runtime:** Node.js 18
- **Framework:** Express.js 4.21.2
- **Database:** Firebase Firestore
- **AI/ML:** 
  - OpenAI Whisper (audio transcription)
  - OpenAI GPT-4o-mini (text summarization)
- **Deployment:** Google Cloud Run
- **Container:** Docker

### iOS Frontend
- **Language:** Swift 5
- **UI Framework:** SwiftUI
- **Architecture:** MVVM
- **Audio:** AVFoundation
- **HTTP Client:** URLSession
- **State Management:** @StateObject, @Published

---

## 📖 Documentation

### Backend Documentation (`ai-voice-note-backend/documentation/`)
- **[README_FOR_IOS_DEV.md](ai-voice-note-backend/documentation/README_FOR_IOS_DEV.md)** - iOS integration guide
- **[README_DEPLOY_GCP.md](ai-voice-note-backend/documentation/README_DEPLOY_GCP.md)** - Cloud Run deployment
- **[ENDPOINT_TEST_REPORT.md](ai-voice-note-backend/documentation/ENDPOINT_TEST_REPORT.md)** - API test results
- **[DEPLOYMENT_INFO_FOR_IOS_DEV.md](ai-voice-note-backend/documentation/DEPLOYMENT_INFO_FOR_IOS_DEV.md)** - Production deployment info
- **[FRONTEND_BACKEND_INTEGRATION.md](ai-voice-note-backend/documentation/FRONTEND_BACKEND_INTEGRATION.md)** - Integration guide
- **[GCP_CICD_SETUP.md](ai-voice-note-backend/documentation/GCP_CICD_SETUP.md)** - CI/CD setup
- And 5 more comprehensive guides...

### API Documentation
- **[OpenAPI Specification](ai-voice-note-backend/openapi.yaml)** - Complete API spec
- **[Postman Collection](ai-voice-note-backend/postman_collection.json)** - Ready-to-use API tests
- **[Postman Environment](ai-voice-note-backend/postman_environment.json)** - Environment configuration

### iOS Documentation
- **[README_FRONTEND_CHANGES.md](AN-Voice%20Note%20Tracker%20App/README_FRONTEND_CHANGES.md)** - Frontend changes log

---

## 🔐 Security

- **API Authentication:** All protected endpoints require `x-api-key` header
- **Production API Key:** 256-bit cryptographically secure key
- **Environment Variables:** Sensitive keys stored in `.env` (not committed)
- **Firebase:** Service account authentication
- **CORS:** Configured for production domain

⚠️ **Never commit `.env` files or API keys to version control**

---

## 🧪 Testing

### Backend Testing

**Health Check:**
```bash
curl https://ai-voice-note-backend-965903915503.us-central1.run.app/health
```

**Test with Postman:**
1. Import `postman_collection.json`
2. Import `postman_environment.json`
3. Update `apiKey` variable
4. Run all tests

**Manual cURL Test:**
```bash
curl -X POST \
  -H "x-api-key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"transcript":"Test transcript"}' \
  https://ai-voice-note-backend-965903915503.us-central1.run.app/summary
```

### iOS Testing

1. Open project in Xcode
2. Select simulator/device
3. Run with `Cmd+R`
4. Test recording → transcription → summarization flow

---

## 📊 Current Status

**Backend:**
- 🟢 Deployed to Google Cloud Run
- ✅ All 8 endpoints operational
- ✅ OpenAI integration active
- ✅ Firebase Firestore connected
- ✅ Production API keys configured

**Frontend:**
- ✅ iOS app configured with production backend
- ✅ APIClient reading from Info.plist
- ✅ Recording and transcription working
- ⚠️ Needs testing in Xcode simulator/device

**Integration:**
- ✅ Frontend-backend communication verified
- ✅ Data models aligned
- ✅ Authentication working
- ⚠️ Using hardcoded userId="tester" (needs real auth)

---

## 🚧 Known Issues & Improvements

### To-Do
- [ ] Implement real user authentication (replace hardcoded userId)
- [ ] Test iOS app end-to-end on device
- [ ] Delete unused `AIService.swift` file
- [ ] Add user registration/login flow
- [ ] Implement push notifications for note reminders

### Recommendations
- Replace hardcoded `userId="tester"` in `HomeViewModel.swift`
- Add Firebase Authentication for user management
- Implement note sharing functionality
- Add offline mode with local storage

---

## 👥 For Developers

### Getting the Postman Collection

**Option 1: From Repository**
```bash
# Files are in the backend folder
ai-voice-note-backend/postman_collection.json
ai-voice-note-backend/postman_environment.json
```

**Option 2: Import to Postman**
1. Open Postman Desktop App
2. Click "Import" button (top left)
3. Drag and drop both JSON files
4. Update environment variables with your keys

### API Key Configuration

**Backend API Key:**
- Located in `.env` file (backend)
- Also stored in iOS `Info.plist`
- Required in `x-api-key` header for all protected endpoints

**OpenAI API Key:**
- Stored in backend `.env` file
- Used for Whisper transcription and GPT-4o-mini summarization
- Get yours at: https://platform.openai.com/api-keys

### Local Development Workflow

1. **Start Backend:**
   ```bash
   cd ai-voice-note-backend
   npm install
   npm start
   ```

2. **Update iOS Config:**
   - Set `API_BASE_URL` to `http://localhost:5000`
   - Keep same `API_KEY`

3. **Run iOS App:**
   - Open in Xcode
   - Build and run

4. **Test with Postman:**
   - Import collections
   - Set `baseUrl` to `http://localhost:5000`
   - Test all endpoints

---

## 📞 Support

- **Backend Issues:** Check Cloud Run logs in GCP Console
- **iOS Issues:** Check Xcode console logs
- **API Testing:** Use Postman collection
- **Documentation:** See `ai-voice-note-backend/documentation/` folder

---

## 📝 License

MIT License

---

## 🎉 Acknowledgments

- OpenAI for Whisper and GPT-4o-mini APIs
- Google Cloud for reliable hosting
- Firebase for Firestore database

---

**Built with ❤️ by Nishanth**

*Last Updated: November 20, 2025*