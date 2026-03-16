#!/bin/bash
# ═══════════════════════════════════════════════════════════
#  SilentBridge — Automated Deployment Script
#  Deploys backend → Google Cloud Run
#          frontend → Firebase Hosting
#
#  Usage:
#    export GEMINI_API_KEY="your-key-here"
#    chmod +x deploy.sh
#    ./deploy.sh
#
#  Or with flags:
#    ./deploy.sh --project my-gcp-project --region us-central1
#
#  This script satisfies the hackathon bonus requirement:
#  "Automating Cloud Deployment using scripts or IaC tools"
# ═══════════════════════════════════════════════════════════
set -euo pipefail

# ── Colors ──────────────────────────────────────────────────
R='\033[0;31m'; G='\033[0;32m'; Y='\033[1;33m'; B='\033[0;34m'; NC='\033[0m'; BOLD='\033[1m'

log()  { echo -e "${G}[deploy]${NC} $1"; }
warn() { echo -e "${Y}[warn]${NC}  $1"; }
err()  { echo -e "${R}[error]${NC} $1"; exit 1; }
step() { echo -e "\n${BOLD}${B}── $1${NC}"; }

echo ""
echo -e "${BOLD}🤟 SilentBridge — Automated Deployment${NC}"
echo "═══════════════════════════════════════"

# ── Parse flags ─────────────────────────────────────────────
PROJECT_ID=""
REGION="us-central1"
SERVICE="silentbridge-api"
FIREBASE_PROJECT=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --project)  PROJECT_ID="$2";  shift 2 ;;
    --region)   REGION="$2";      shift 2 ;;
    --service)  SERVICE="$2";     shift 2 ;;
    --firebase) FIREBASE_PROJECT="$2"; shift 2 ;;
    *) shift ;;
  esac
done

# ── Validate prerequisites ───────────────────────────────────
step "Checking prerequisites"

command -v gcloud >/dev/null 2>&1 || err "gcloud CLI not found. Install: https://cloud.google.com/sdk/docs/install"
command -v node   >/dev/null 2>&1 || err "Node.js not found. Install: https://nodejs.org"

# Gemini API key
if [[ -z "${GEMINI_API_KEY:-}" ]]; then
  echo -e "${Y}Enter your Gemini API key (from aistudio.google.com):${NC}"
  read -rs GEMINI_API_KEY
  echo ""
fi
[[ -z "$GEMINI_API_KEY" ]] && err "GEMINI_API_KEY is required"

# GCP project
if [[ -z "$PROJECT_ID" ]]; then
  PROJECT_ID=$(gcloud config get-value project 2>/dev/null || echo "")
fi
if [[ -z "$PROJECT_ID" ]]; then
  echo -e "${Y}Enter your GCP Project ID:${NC}"
  read -r PROJECT_ID
fi
[[ -z "$PROJECT_ID" ]] && err "GCP Project ID is required"

gcloud config set project "$PROJECT_ID" --quiet
log "Project: $PROJECT_ID | Region: $REGION | Service: $SERVICE"

# ── Enable required APIs ─────────────────────────────────────
step "Enabling Google Cloud APIs"
gcloud services enable \
  run.googleapis.com \
  cloudbuild.googleapis.com \
  artifactregistry.googleapis.com \
  --project "$PROJECT_ID" \
  --quiet
log "APIs enabled ✓"

# ── Prepare backend: copy frontend into static/ ──────────────
step "Preparing backend package"
cp -r frontend backend/static
log "Frontend copied to backend/static/ ✓"

# ── Deploy backend to Cloud Run ──────────────────────────────
step "Deploying backend to Cloud Run"
cd backend

gcloud run deploy "$SERVICE" \
  --source . \
  --region "$REGION" \
  --allow-unauthenticated \
  --set-env-vars "GEMINI_API_KEY=${GEMINI_API_KEY},ENVIRONMENT=production" \
  --memory 512Mi \
  --cpu 1 \
  --min-instances 0 \
  --max-instances 10 \
  --timeout 300 \
  --concurrency 80 \
  --project "$PROJECT_ID" \
  --quiet

BACKEND_URL=$(gcloud run services describe "$SERVICE" \
  --region "$REGION" \
  --project "$PROJECT_ID" \
  --format "value(status.url)")

cd ..

# Clean up static copy
rm -rf backend/static

log "Backend deployed ✓"
log "URL: $BACKEND_URL"

# ── Verify deployment ────────────────────────────────────────
step "Verifying deployment"
sleep 3
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "${BACKEND_URL}/health" || echo "000")
if [[ "$HTTP_STATUS" == "200" ]]; then
  log "Health check passed ✓ (HTTP $HTTP_STATUS)"
  HEALTH=$(curl -s "${BACKEND_URL}/health")
  log "Response: $HEALTH"
else
  warn "Health check returned HTTP $HTTP_STATUS — backend may still be starting"
fi

# ── Deploy frontend to Firebase ──────────────────────────────
step "Deploying frontend to Firebase Hosting"

command -v firebase >/dev/null 2>&1 || {
  warn "Firebase CLI not found — installing..."
  npm install -g firebase-tools --quiet
}

# Inject the backend URL into the frontend
sed -i.bak "s|localStorage.getItem('sb_backend') || ''|localStorage.getItem('sb_backend') || '${BACKEND_URL}'|g" \
  frontend/index.html 2>/dev/null || true

FIREBASE_PROJ="${FIREBASE_PROJECT:-$PROJECT_ID}"

firebase deploy --only hosting --project "$FIREBASE_PROJ" 2>/dev/null && {
  FIREBASE_URL="https://${FIREBASE_PROJ}.web.app"
  log "Frontend deployed ✓ → $FIREBASE_URL"
} || {
  warn "Firebase deploy skipped (run 'firebase init hosting' first, then re-run this script)"
  FIREBASE_URL="(run firebase init hosting first)"
}

# Restore original frontend
mv frontend/index.html.bak frontend/index.html 2>/dev/null || true

# ── Summary ──────────────────────────────────────────────────
echo ""
echo "═══════════════════════════════════════════"
echo -e "${G}${BOLD}🎉 Deployment complete!${NC}"
echo "═══════════════════════════════════════════"
echo ""
echo -e "  ${G}Backend (Cloud Run):${NC}  $BACKEND_URL"
echo -e "  ${G}Frontend (Firebase):${NC}  $FIREBASE_URL"
echo -e "  ${G}Health check:${NC}         ${BACKEND_URL}/health"
echo -e "  ${G}API docs:${NC}             ${BACKEND_URL}/docs"
echo ""
echo -e "${B}For your hackathon submission:${NC}"
echo "  Cloud deployment proof → screenshot:"
echo "  https://console.cloud.google.com/run/detail/${REGION}/${SERVICE}?project=${PROJECT_ID}"
echo ""
echo -e "${B}Or share this Cloud Run URL as your 'Try it out' link:${NC}"
echo "  $BACKEND_URL"
echo ""
