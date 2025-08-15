#!/usr/bin/env bash
# generate.sh – recreate the full sparkr-dating-app repository structure

set -euo pipefail

ROOT_DIR="sparkr-dating-app"

# -----------------------------------------------------------------------------
# Helper: create an empty file with all necessary parent directories
# -----------------------------------------------------------------------------
touch_file() {
  mkdir -p "$(dirname "$1")"
  [ -f "$1" ] || touch "$1"
}

# -----------------------------------------------------------------------------
# Create the root folder
# -----------------------------------------------------------------------------
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR"

# -----------------------------------------------------------------------------
# backend/
# -----------------------------------------------------------------------------
touch_file "backend/src/main.ts"
touch_file "backend/src/app.module.ts"

touch_file "backend/src/modules/auth/auth.controller.ts"
touch_file "backend/src/modules/auth/auth.service.ts"
mkdir -p backend/src/modules/auth/dto

touch_file "backend/src/modules/user/user.controller.ts"
touch_file "backend/src/modules/user/user.service.ts"
mkdir -p backend/src/modules/user/dto

touch_file "backend/src/modules/match/match.controller.ts"
touch_file "backend/src/modules/match/match.service.ts"

touch_file "backend/src/modules/chat/chat.gateway.ts"
touch_file "backend/src/modules/chat/chat.service.ts"

touch_file "backend/src/modules/subscription/subscription.controller.ts"
touch_file "backend/src/modules/subscription/stripe.webhook.ts"

touch_file "backend/src/modules/admin/admin.controller.ts"
touch_file "backend/src/modules/admin/analytics.service.ts"

touch_file "backend/src/modules/ai/ai.controller.ts"

touch_file "backend/src/guards/jwt-auth.guard.ts"

touch_file "backend/src/prisma/prisma.service.ts"
touch_file "backend/src/prisma/seed.ts"

touch_file "backend/src/utils/location.util.ts"

touch_file "backend/src/i18n/i18n.service.ts"

mkdir -p backend/migrations
mkdir -p backend/test
touch_file "backend/test/subscription.webhook.spec.ts"

touch_file "backend/docker-compose.yml"
touch_file "backend/Dockerfile"
touch_file "backend/nest-cli.json"
touch_file "backend/package.json"
mkdir -p backend/swagger-ui

# -----------------------------------------------------------------------------
# web/
# -----------------------------------------------------------------------------
touch_file "web/src/App.tsx"
touch_file "web/src/main.tsx"

touch_file "web/src/components/SwipeCard.tsx"
touch_file "web/src/components/ChatWindow.tsx"
touch_file "web/src/components/LanguageSwitcher.tsx"

touch_file "web/src/screens/LoginScreen.tsx"
touch_file "web/src/screens/HomeScreen.tsx"
touch_file "web/src/screens/ChatScreen.tsx"
touch_file "web/src/screens/ProfileScreen.tsx"

touch_file "web/src/store/userSlice.ts"
touch_file "web/src/store/store.ts"

touch_file "web/src/services/api.ts"
touch_file "web/src/services/supabase.ts"

touch_file "web/src/i18n/index.ts"
mkdir -p web/src/assets
mkdir -p web/public

touch_file "web/Dockerfile"
touch_file "web/tailwind.config.js"
touch_file "web/vite.config.ts"
touch_file "web/package.json"

# -----------------------------------------------------------------------------
# mobile/
# -----------------------------------------------------------------------------
touch_file "mobile/App.tsx"

touch_file "mobile/app/_layout.tsx"
touch_file "mobile/app/login/index.tsx"
touch_file "mobile/app/home/index.tsx"
touch_file "mobile/app/chat/index.tsx"
touch_file "mobile/app/profile/index.tsx"

touch_file "mobile/components/SwipeCard.tsx"
touch_file "mobile/components/CameraUpload.tsx"
touch_file "mobile/components/ChatBubble.tsx"

touch_file "mobile/navigation/RootLayout.tsx"

touch_file "mobile/hooks/useGeolocation.ts"

touch_file "mobile/utils/socket.ts"

touch_file "mobile/services/api.ts"

mkdir -p mobile/assets

touch_file "mobile/babel.config.js"
touch_file "mobile/app.json"
touch_file "mobile/package.json"

# -----------------------------------------------------------------------------
# ai/
# -----------------------------------------------------------------------------
touch_file "ai/matcher/train_model.py"
touch_file "ai/matcher/model.pkl"
touch_file "ai/matcher/embeddings.npy"

touch_file "ai/facial/detect_faces.py"
touch_file "ai/facial/score_photos.py"

touch_file "ai/notebooks/ai_matcher_training.ipynb"

touch_file "ai/requirements.txt"

touch_file "ai/FastAPI/main.py"
touch_file "ai/FastAPI/Dockerfile"

# -----------------------------------------------------------------------------
# admin/
# -----------------------------------------------------------------------------
touch_file "admin/admin.js"
touch_file "admin/controllers/analytics.controller.ts"
touch_file "admin/views/dashboard.hbs"

# -----------------------------------------------------------------------------
# Root-level files
# -----------------------------------------------------------------------------
touch_file "docker-compose.yml"
touch_file ".env.example"
touch_file ".gitignore"
touch_file "README.md"
touch_file "LICENSE"

echo "✅  Repository structure created under ./$ROOT_DIR"
