# 🤟 SilentBridge
### Real-time Bidirectional Sign Language ↔ Speech Interpreter

> **Gemini Live Agent Challenge** · **Live Agent Category** · #GeminiLiveAgentChallenge

[![Deploy to Cloud Run](https://img.shields.io/badge/Deploy-Cloud%20Run-4285F4?logo=google-cloud)](https://cloud.google.com/run)
[![Powered by Gemini](https://img.shields.io/badge/Powered%20by-Gemini%202.0-8B5CF6?logo=google)](https://aistudio.google.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## The Problem

**70 million deaf people** worldwide use sign language as their primary language. In most everyday interactions with hearing people — doctors, shops, strangers, workplaces — there is no interpreter available. Existing solutions require typing (slow) or a professional interpreter (expensive). Real-time, zero-friction sign language interpretation did not exist before AI made it possible.

**SilentBridge solves this.**

---

## Demo Video

[![SilentBridge Demo](https://img.shields.io/badge/Watch-Demo%20Video-FF0000?logo=youtube)](YOUR_YOUTUBE_URL_HERE)

> Replace `YOUR_YOUTUBE_URL_HERE` with your YouTube demo link after recording.

---

## Try It Live

🚀 **[Live App](YOUR_FIREBASE_URL_HERE)** · **[API Docs](YOUR_CLOUD_RUN_URL/docs)**

---

## How It Works

### Flow 1 — Deaf → Hearing
```
[Deaf user signs] → [Webcam] → [Browser captures frames @ 1fps]
  → [WebSocket to Cloud Run] → [google-genai SDK]
  → [Gemini Live API interprets sign language]
  → [English text → Web Speech TTS]
  → [Hearing person hears the translation]
```

### Flow 2 — Hearing → Deaf
```
[Hearing person speaks] → [Web Speech Recognition STT]
  → [POST to Cloud Run /simplify] → [Gemini 2.0 Flash]
  → [Plain English simplification]
  → [Displayed as clear text for deaf user to read]
```

---

## Architecture

![Architecture Diagram](architecture/diagram.html)

See `architecture/diagram.html` for the full interactive diagram.

```
┌─────────────────┐         ┌──────────────────────────┐         ┌─────────────────┐
│  DEAF USER      │         │  GOOGLE CLOUD RUN         │         │  HEARING USER   │
│                 │         │                           │         │                 │
│  📷 Webcam      │─frames─▶│  FastAPI Backend          │─text───▶│  📺 Screen      │
│  🌐 Browser     │◀─text───│  google-genai SDK         │◀─speech─│  🌐 Browser     │
│  🔊 TTS output  │         │  Gemini Live API          │         │  🎤 Microphone  │
└─────────────────┘         │  Gemini 2.0 Flash         │         └─────────────────┘
                            └──────────────────────────┘
                                       │
                            ┌──────────────────────────┐
                            │  Firebase Hosting         │
                            │  Frontend (index.html)    │
                            └──────────────────────────┘
```

---

## Tech Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| AI — Sign interpretation | **Gemini Live API** (`gemini-2.0-flash-exp`) | Real-time multimodal video → text |
| AI — Speech simplification | **Gemini 2.0 Flash** | Simplify hearing person's speech |
| AI SDK | **google-generativeai** + **google-genai** (official) | Required SDK per hackathon rules |
| Backend | **FastAPI** on **Google Cloud Run** | WebSocket proxy + REST API |
| Frontend | Vanilla HTML/CSS/JS | Zero dependencies, instant load |
| Speech output | **Web Speech API** (browser) | Free TTS — speaks translations aloud |
| Speech input | **Web Speech Recognition** (browser) | Free STT — transcribes hearing person |
| Frontend hosting | **Firebase Hosting** | Google Cloud, free Spark plan |
| CI/CD | **GitHub Actions** | Auto-deploy on push to main |

---

## Mandatory Requirements ✅

| Requirement | Status | How |
|------------|--------|-----|
| Gemini model | ✅ | `gemini-2.0-flash-exp` (Live) + `gemini-2.0-flash` (REST) |
| Google GenAI SDK | ✅ | `google-generativeai` + `google-genai` in `backend/main.py` |
| Gemini Live API | ✅ | WebSocket session via `client.aio.live.connect()` |
| Hosted on Google Cloud | ✅ | Cloud Run backend + Firebase Hosting frontend |
| Live Agent category | ✅ | Real-time vision + audio, handles continuous stream |
| Multimodal (beyond text) | ✅ | Video in → text out → speech out |
| Barge-in / interruption | ✅ | Live API handles interruptions natively |

---

## Bonus Points ✅

| Bonus | Status |
|-------|--------|
| Blog post / dev content | 📝 See `docs/blog-post.md` — publish to dev.to |
| Automated deployment | ✅ `deploy.sh` + `.github/workflows/deploy.yml` |
| GDG membership | 🔗 Add your GDG profile link here |

---

## Project Structure

```
silentbridge/
├── frontend/
│   └── index.html              ← Full app (single file, zero deps)
├── backend/
│   ├── main.py                 ← FastAPI + google-genai SDK
│   ├── requirements.txt        ← Python dependencies
│   └── Dockerfile              ← Cloud Run container
├── architecture/
│   └── diagram.html            ← System architecture diagram
├── docs/
│   └── blog-post.md            ← Dev.to blog post (publish for +0.6 pts)
├── .github/
│   └── workflows/
│       └── deploy.yml          ← GitHub Actions CI/CD pipeline
├── firebase.json               ← Firebase Hosting config
├── deploy.sh                   ← One-command automated deploy
├── .env.example                ← Environment variables template
└── README.md                   ← This file
```

---

## Quick Start (Local Development)

### Prerequisites
- Python 3.11+
- Google Chrome (for Web Speech API)
- Free Gemini API key from [aistudio.google.com](https://aistudio.google.com)

### 1. Get your free API key
```bash
# Go to https://aistudio.google.com → Get API Key → Create API key
```

### 2. Run backend locally
```bash
cd backend
pip install -r requirements.txt
export GEMINI_API_KEY="your-key-here"
python main.py
# Server starts at http://localhost:8080
```

### 3. Open frontend
```bash
# Option A: Open directly
open frontend/index.html

# Option B: Serve with Python
cd frontend && python3 -m http.server 3000
# Open http://localhost:3000
```

### 4. Configure the app
- In the yellow config banner, enter `http://localhost:8080` as backend URL
- Click Save, then Start Session

---

## Deploy to Google Cloud (Production)

### One-command deploy
```bash
export GEMINI_API_KEY="your-gemini-api-key"
chmod +x deploy.sh
./deploy.sh
```

### Manual steps
```bash
# 1. Deploy backend to Cloud Run
cd backend
gcloud run deploy silentbridge-api \
  --source . \
  --region us-central1 \
  --allow-unauthenticated \
  --set-env-vars GEMINI_API_KEY=$GEMINI_API_KEY

# 2. Deploy frontend to Firebase
cd ..
firebase deploy --only hosting
```

### GitHub Actions (auto-deploy)
Set these secrets in your GitHub repo settings:
- `GCP_PROJECT_ID` — your Google Cloud project ID
- `GCP_SA_KEY` — service account JSON (base64 encoded)
- `GEMINI_API_KEY` — your Gemini API key
- `FIREBASE_TOKEN` — from `firebase login:ci`

Every push to `main` automatically deploys.

---

## Google Cloud Deployment Proof

Evidence that backend runs on Google Cloud:

1. **Health endpoint**: `GET YOUR_CLOUD_RUN_URL/health` returns:
```json
{
  "status": "healthy",
  "cloud_provider": "Google Cloud Run",
  "sdk": "google-generativeai",
  "model": "gemini-2.0-flash-exp"
}
```

2. **Cloud Run console**: `https://console.cloud.google.com/run`

3. **SDK usage in code**: See [`backend/main.py`](backend/main.py) lines using `google.generativeai` and `google.genai`

---

## Cost Breakdown

| Resource | Free Tier | Cost |
|----------|-----------|------|
| Gemini API | AI Studio free key | $0 |
| Cloud Run | 2M requests/month free | $0 |
| Firebase Hosting | 10GB/month free (Spark) | $0 |
| Web Speech API | Browser-native | $0 |
| **Total** | | **$0** |

---

## Findings & Learnings

- **Gemini Live API** excels at continuous visual interpretation — its streaming architecture eliminates the latency of request-response cycles, making real-time sign language interpretation genuinely feasible
- **Frame rate** of ~1fps is sufficient for sign language recognition while keeping API costs minimal
- **Web Speech API** provides surprisingly high-quality TTS with no cost or setup — a perfect complement to Gemini's text output
- **WebSocket proxying** through Cloud Run (rather than direct browser → Gemini connections) is necessary to satisfy the SDK requirement and enables future features like conversation context, authentication, and logging
- The bidirectional nature of the app required careful async architecture — `asyncio.gather()` for concurrent send/receive loops was essential

---

## Future Roadmap

- **MediaPipe hand landmark overlay** — visual feedback showing detected hand positions
- **ISL / BSL support** — extend beyond American Sign Language
- **Conversation memory** — Firestore to persist conversation context
- **Custom vocabulary** — domain-specific signs for medical, legal, educational contexts
- **Mobile app** — Flutter wrapper for iOS/Android

---

## License

MIT License — see [LICENSE](LICENSE)

---

*Built for the Gemini Live Agent Challenge · #GeminiLiveAgentChallenge*
