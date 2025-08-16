#!/usr/bin/env bash
#
# generate-tinder-clone.sh
# Recreates the full tinder-clone/ directory & file tree.
# Run from repo root.

REPO="tinder-clone"

# ------------------------------------------------------------
# Helpers
# ------------------------------------------------------------
mk_dirs() {
  for d in "$@"; do
    mkdir -p "${REPO}/${d}"
  done
}

touch_file() {
  f="${REPO}/$1"
  mkdir -p "$(dirname "$f")"
  [ ! -f "$f" ] && touch "$f"
}

# ------------------------------------------------------------
# 1. backend/
# ------------------------------------------------------------
mk_dirs \
  backend/src/auth \
  backend/src/user \
  backend/src/match \
  backend/src/chat \
  backend/src/payment \
  backend/src/ai \
  backend/src/admin \
  backend/src/i18n \
  backend/src/location \
  backend/test

touch_file "backend/src/main.ts"
touch_file "backend/test/stripe-webhook.e2e-spec.ts"
touch_file "backend/dockerfile"
touch_file "backend/swagger.json"
touch_file "backend/nest-cli.json"
touch_file "backend/package.json"

# ------------------------------------------------------------
# 2. ai-service/
# ------------------------------------------------------------
mk_dirs ai-service/model

touch_file "ai-service/main.py"
touch_file "ai-service/model/train_model.ipynb"
touch_file "ai-service/model/face_analyzer.py"
touch_file "ai-service/requirements.txt"
touch_file "ai-service/dockerfile"

# ------------------------------------------------------------
# 3. frontend-web/
# ------------------------------------------------------------
mk_dirs \
  frontend-web/public \
  frontend-web/src/components \
  frontend-web/src/pages \
  frontend-web/src/services \
  frontend-web/src/hooks \
  frontend-web/src/store \
  frontend-web/src/i18n \
  frontend-web/src/navigation

touch_file "frontend-web/src/pages/DiscoverPage.tsx"
touch_file "frontend-web/src/pages/ChatPage.tsx"
touch_file "frontend-web/src/pages/ProfilePage.tsx"
touch_file "frontend-web/src/pages/SubscribePage.tsx"
touch_file "frontend-web/src/services/api.ts"
touch_file "frontend-web/src/services/authService.ts"
touch_file "frontend-web/src/services/paymentService.ts"
touch_file "frontend-web/src/hooks/useDiscover.ts"
touch_file "frontend-web/src/hooks/useSocket.ts"
touch_file "frontend-web/src/App.tsx"
touch_file "frontend-web/dockerfile"
touch_file "frontend-web/package.json"

# ------------------------------------------------------------
# 4. mobile-app/
# ------------------------------------------------------------
mk_dirs \
  mobile-app/assets \
  mobile-app/components \
  mobile-app/screens \
  mobile-app/navigation \
  mobile-app/services \
  mobile-app/hooks \
  mobile-app/utils

touch_file "mobile-app/components/CardSwipe.tsx"
touch_file "mobile-app/components/PhotoUploader.tsx"
touch_file "mobile-app/components/MatchModal.tsx"
touch_file "mobile-app/screens/OnboardingScreen.tsx"
touch_file "mobile-app/screens/DiscoverScreen.tsx"
touch_file "mobile-app/screens/ChatScreen.tsx"
touch_file "mobile-app/screens/ProfileScreen.tsx"
touch_file "mobile-app/screens/SubscribeScreen.tsx"
touch_file "mobile-app/navigation/AppNavigator.tsx"
touch_file "mobile-app/services/api.ts"
touch_file "mobile-app/services/authService.ts"
touch_file "mobile-app/services/socketService.ts"
touch_file "mobile-app/hooks/useSwipe.ts"
touch_file "mobile-app/hooks/useLocation.ts"
touch_file "mobile-app/utils/i18n.ts"
touch_file "mobile-app/app.json"
touch_file "mobile-app/App.tsx"
touch_file "mobile-app/dockerfile"

# ------------------------------------------------------------
# 5. admin-dashboard/
# ------------------------------------------------------------
mk_dirs \
  admin-dashboard/src/pages \
  admin-dashboard/src/services \
  admin-dashboard/src/components

touch_file "admin-dashboard/src/pages/UsersPage.tsx"
touch_file "admin-dashboard/src/pages/ReportsPage.tsx"
touch_file "admin-dashboard/src/pages/RevenuePage.tsx"
touch_file "admin-dashboard/src/pages/ChatReviewPage.tsx"
touch_file "admin-dashboard/src/services/adminApi.ts"
touch_file "admin-dashboard/src/components/.gitkeep"
touch_file "admin-dashboard/src/App.tsx"
touch_file "admin-dashboard/dockerfile"
touch_file "admin-dashboard/package.json"

# ------------------------------------------------------------
# 6. prisma/
# ------------------------------------------------------------
mk_dirs prisma
touch_file "prisma/schema.prisma"
touch_file "prisma/seed.ts"

# ------------------------------------------------------------
# 7. scripts/
# ------------------------------------------------------------
mk_dirs scripts
touch_file "scripts/stripe-webhook-test.js"
touch_file "scripts/generate-swagger.js"

# ------------------------------------------------------------
# 8. Root-level
# ------------------------------------------------------------
touch_file "docker-compose.yml"
touch_file ".env.example"
touch_file "README.md"
touch_file "package.json"

echo "✅  tinder-clone/ directory & file structure generated."
