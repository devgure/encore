#!/bin/bash

# create-sparkly-app.sh
# Creates the full Sparkly Dating App project structure

set -e  # Exit on any error

echo "🚀 Creating Sparkly Dating App structure..."

PROJECT_NAME="sparkly-dating-app"
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# -----------------------------------------------------------------------------
# Root Files
# -----------------------------------------------------------------------------

cat > .gitignore << 'EOF'
node_modules/
dist/
build/
*.log
.env
.env.local
coverage/
.DS_Store
*.pem
*.p8

# Expo
.expo/
.eas/

# Python
__pycache__/
*.pyc
*.pyo
*.pyd
.Python
*.so

# Docker
.dockerignore
EOF

cat > .env.example << 'EOF'
# Database
DATABASE_URL=postgresql://sparkly:sparklypass@db:5432/sparkly?schema=public

# JWT
JWT_SECRET=your_ultra_secure_32_char_secret_key_here_1234

# Stripe
STRIPE_API_KEY=sk_test_XXXXXXXXXXXXXXXXXXXXXX
STRIPE_WEBHOOK_SECRET=whsec_XXXXXXXXXXXXXXXXXXXXXX
STRIPE_PREMIUM_PRICE_ID=price_XXXXXXXXXXXXXXXXXXXXXX

# AI Engine
AI_SERVICE_URL=http://ai-engine:8000/predict

# Auth
GOOGLE_CLIENT_ID=your-google-client-id
APPLE_CLIENT_ID=com.sparkly.app

# App
FRONTEND_URL=http://localhost:3001
ADMIN_URL=http://localhost:3002
MOBILE_SCHEME=sparkly
EOF

cat > README.md << 'EOF'
# Sparkly Dating App 💘

A Tinder-like, AI-powered, location-based dating app with monetization, real-time chat, facial recognition, and admin dashboard.

## 🚀 Features

- 📱 React Native (Expo) Mobile App
- 💻 Next.js Responsive Web
- 👨‍💼 Admin CRUD Panel (React Admin)
- 🔐 OAuth (Google, Apple)
- 💳 Stripe Subscriptions + Webhooks
- 🤖 AI Matching Engine (Python + FastAPI)
- 💬 Realtime Chat (Socket.IO)
- 🌍 i18n (en, es)
- 📍 GPS-Based Matching
- 🧪 Unit & E2E Tests
- 🛠️ CI/CD (GitHub Actions)
- 📚 OpenAPI (Swagger) Docs

## 📦 Tech Stack

- **Frontend**: React Native (Expo), Next.js, React Admin
- **Backend**: NestJS, FastAPI (AI)
- **Database**: PostgreSQL (Prisma ORM), Redis
- **Auth**: Firebase Auth / Auth0 (OAuth)
- **Payments**: Stripe
- **Realtime**: Socket.IO
- **AI**: scikit-learn, FastAPI
- **I18n**: i18next
- **DevOps**: Docker, GitHub Actions

## 🚀 Quick Start

```bash
git clone https://github.com/yourusername/sparkly-dating-app.git
cd sparkly-dating-app
cp .env.example .env

# Start services
docker-compose up -d

# Run migrations
npx prisma migrate dev --name init
npx prisma db seed

# Start API
cd services/api && npm run start:dev

# Start AI Engine
cd services/ai-engine && uvicorn main:app --reload

# Start Web
cd apps/web && npm run dev

# Start Mobile
cd apps/mobile && npx expo start