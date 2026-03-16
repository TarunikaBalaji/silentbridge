🤟 SilentBridge
Real-time Bidirectional Sign Language ↔ Speech Interpreter










AI-powered communication bridge between deaf and hearing individuals, enabling real-time sign language ↔ speech interaction using Gemini Live multimodal AI.

Built for the Gemini Live Agent Challenge.

🏆 Gemini Live Agent Challenge

Category: Live Agents
Focus: Real-time multimodal AI interaction

SilentBridge demonstrates how Gemini Live API can enable natural, real-time human communication across accessibility barriers.

🌍 The Problem

Over 70 million deaf people worldwide rely on sign language as their primary language.

In everyday situations—doctor visits, workplaces, shops, public services—there is rarely a sign language interpreter available.

Existing solutions have major limitations:

• Typing communication is slow and unnatural
• Professional interpreters are expensive and rarely available
• Most apps do not support real-time interaction
• Communication remains difficult in spontaneous situations

Real-time seamless communication between deaf and hearing people has remained a major accessibility challenge.

💡 The Solution

SilentBridge provides a real-time AI communication bridge.

It enables bidirectional conversation between deaf and hearing individuals:

Sign Language → Speech

The system observes hand gestures using a webcam and uses Gemini Live multimodal reasoning to translate gestures into spoken English.

Speech → Simplified Text

Spoken language is converted into text and simplified using Gemini 2.0 Flash, making it easier for deaf users to read.

All interactions happen live in real time.

🎬 Demo Video

👉 (Add your YouTube demo link here)

The demo shows:

• real-time sign language interpretation
• speech-to-text communication
• multimodal AI interaction
• full bidirectional communication flow

🚀 Try It Out

GitHub Repository:

https://github.com/TarunikaBalaji/silentbridge

The project can be run locally following the instructions below.

⚙️ How It Works
Flow 1 — Deaf → Hearing
Deaf user signs
↓
Webcam captures gestures
↓
Frames streamed to backend
↓
FastAPI server on Google Cloud Run
↓
Gemini Live API interprets gestures
↓
Text generated
↓
Web Speech API converts text to speech
↓
Hearing user hears translation
Flow 2 — Hearing → Deaf
Hearing user speaks
↓
Web Speech Recognition converts speech to text
↓
Text sent to backend
↓
Gemini 2.0 Flash simplifies the language
↓
Clear text displayed
↓
Deaf user reads the response


┌─────────────────────────┐         ┌──────────────────────────────┐         ┌──────────────────────┐
│     DEAF USER SIDE      │         │     GOOGLE CLOUD RUN          │         │   HEARING USER SIDE  │
│                         │         │                               │         │                      │
│  📷 Webcam              │─frames──▶  FastAPI Backend              │──text──▶│  📺 Screen display   │
│  Canvas API (1fps JPEG) │         │  google-genai SDK (official)  │         │                      │
│                         │◀─text───│  ┌────────────────────────┐  │◀─speech─│  🎤 Microphone       │
│  🔊 Web Speech TTS      │         │  │  Gemini Live API        │  │         │  Web Speech STT      │
│     speaks aloud        │         │  │  gemini-2.0-flash-exp   │  │         │                      │
└─────────────────────────┘         │  └────────────────────────┘  │         └──────────────────────┘
                                    │  ┌────────────────────────┐  │
                                    │  │  Gemini 2.0 Flash       │  │
                                    │  │  Speech simplification  │  │
                                    │  └────────────────────────┘  │
                                    └──────────────────────────────┘
                                                    │
                                    ┌──────────────────────────────┐
                                    │     Firebase Hosting          │
                                    │     frontend/index.html       │
                                    └──────────────────────────────┘
                                    
Architecture diagram available at:

architecture/diagram.html

🧠 Key Features

• Real-time sign language interpretation
• Bidirectional communication (sign ↔ speech)
• Multimodal AI reasoning with Gemini
• Browser-based interaction (no installation required)
• Accessible communication for deaf and hearing users
• Lightweight and deployable on cloud infrastructure

🛠 Tech Stack
Layer	Technology	Purpose
AI — Sign interpretation	Gemini Live API	Real-time multimodal gesture interpretation
AI — Speech processing	Gemini 2.0 Flash	Simplifies spoken responses
AI SDK	google-genai / google-generativeai	Official Google AI SDK
Backend	FastAPI	Handles API requests and streaming
Hosting	Google Cloud Run	Serverless backend hosting
Frontend	HTML / CSS / JavaScript	Lightweight browser interface
Speech output	Web Speech API	Text-to-speech
Speech input	Web Speech Recognition	Speech-to-text
Frontend hosting	Firebase Hosting	Static hosting
CI/CD	GitHub Actions	Automated deployment pipeline
☁️ Google Cloud Usage

SilentBridge leverages multiple Google Cloud technologies:

• Gemini Live API — real-time multimodal gesture interpretation
• Gemini 2.0 Flash — speech processing and simplification
• Google GenAI SDK — AI integration layer
• Cloud Run — backend deployment
• Firebase Hosting — frontend hosting

These services enable scalable, real-time AI communication.

📂 Project Structure
silentbridge/
├── frontend/
│   └── index.html
├── backend/
│   ├── main.py
│   ├── requirements.txt
│   └── Dockerfile
├── architecture/
│   └── diagram.html
├── docs/
│   └── blog-post.md
├── .github/workflows/
│   └── deploy.yml
├── firebase.json
├── deploy.sh
├── .env.example
└── README.md
▶️ Quick Start
1 Clone the repository
git clone https://github.com/TarunikaBalaji/silentbridge.git
cd silentbridge
2 Install dependencies
pip install -r backend/requirements.txt
3 Add your Gemini API key
export GEMINI_API_KEY=your_api_key

You can obtain an API key from:

https://aistudio.google.com

4 Run the backend
python backend/main.py
5 Open the frontend

Open the file:

frontend/index.html

in your browser.

Allow camera and microphone permissions.

🧪 How to Test the Project

Open the application in your browser

Allow camera and microphone access

Perform hand gestures in front of the webcam

The AI interprets gestures into speech

Speak into the microphone

The system converts speech into readable text

The application runs entirely locally and does not require login credentials.

⚠️ Challenges We Faced

• Interpreting sign gestures in real time
• Managing asynchronous camera and speech streams
• Maintaining low latency during AI inference
• Integrating browser APIs with cloud-hosted AI services

📚 What We Learned

• Multimodal AI agents require streaming pipelines instead of request-response architectures
• Gemini Live enables natural real-time human-AI interaction
• Accessibility-focused AI can significantly improve communication equity
• Cloud-native architectures are essential for scalable AI applications

🔮 Future Improvements

• Support for additional sign languages (ISL, BSL, etc.)
• Higher-accuracy gesture recognition models
• Mobile applications for Android and iOS
• Persistent conversation memory
• Domain-specific vocabulary support for healthcare and education

📜 License

MIT License

🏆 Built For

Gemini Live Agent Challenge

#GeminiLiveAgentChallenge
