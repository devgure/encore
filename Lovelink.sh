#!/usr/bin/env bash
# ------------------------------------------------------------
#  init-lovelink.sh  –  scaffold the whole Lovelink repo layout
# ------------------------------------------------------------
set -euo pipefail

PROJECT_DIR="lovelink"

# -----------------------------------------------------------
# 1. Create the directory skeleton
# -----------------------------------------------------------
echo "Creating project structure …"
mkdir -p "$PROJECT_DIR"/{backend/{src/{auth,user,match,location,chat,payment,admin,ai,i18n,docs,prisma},test},mobile/{screens,components,navigation,services,assets},web/{public,src/{pages,components,store,i18n,services}},admin/{src/{resources,dashboard},public},ai_service/{src/{models,notebooks,utils},scripts,tests},scripts,.github/workflows}

# -----------------------------------------------------------
# 2. Touch empty files that must exist (but don’t yet need content)
# -----------------------------------------------------------
echo "Creating empty files …"

# backend
touch "$PROJECT_DIR"/backend/src/{main.ts,app.module.ts}
touch "$PROJECT_DIR"/backend/src/prisma/{schema.prisma,seed.ts}
touch "$PROJECT_DIR"/backend/test/stripe.webhook.spec.ts
touch "$PROJECT_DIR"/backend/{Dockerfile,docker-compose.yml,nest-cli.json,package.json,swagger.json}

# mobile
touch "$PROJECT_DIR"/mobile/{screens/{AuthScreen.tsx,HomeScreen.tsx,MatchScreen.tsx,ChatScreen.tsx,ProfileScreen.tsx,SettingsScreen.tsx},components/{SwipeCard.tsx,CameraUpload.tsx,ChatBubble.tsx},navigation/AppNavigator.tsx,services/{api.ts,auth.ts},App.tsx,app.config.ts,babel.config.js,package.json,Dockerfile}

# web
touch "$PROJECT_DIR"/web/{public/index.html,src/{App.tsx,main.tsx},package.json,Dockerfile}

# admin
touch "$PROJECT_DIR"/admin/{src/{App.tsx,resources/{users.tsx,reports.tsx,subscriptions.tsx},dashboard/index.tsx},package.json,Dockerfile}
touch "$PROJECT_DIR"/admin/public/.gitkeep   # keep empty dir

# ai_service
touch "$PROJECT_DIR"/ai_service/{requirements.txt,Dockerfile,pyproject.toml}
touch "$PROJECT_DIR"/ai_service/src/{main.py,models/matching_model.pkl,notebooks/train_matching_model.ipynb,utils/face_verify.py}

# scripts
touch "$PROJECT_DIR"/scripts/{seed-prisma.ts,setup-oauth.md}

# GitHub Actions
touch "$PROJECT_DIR"/.github/workflows/ci.yml

# repo root
touch "$PROJECT_DIR"/{docker-compose.yml,.env.example,README.md,LICENSE}

# -----------------------------------------------------------
# 3. Done
# -----------------------------------------------------------
echo "✅ Lovelink project scaffold created under ./$PROJECT_DIR"
