#!/usr/bin/env bash
# ---------------------------------------------------------------
# generate-etincell.sh
# Creates the full directory / file skeleton for the etincell
# project exactly as provided in the user prompt.
# ---------------------------------------------------------------

set -euo pipefail

ROOT_DIR="etincell"

echo "Creating project structure under ./$ROOT_DIR …"

# -----------------------------------------------------------------
# Helper: create directory and all necessary parents
# -----------------------------------------------------------------
mk_dir() {
  mkdir -p "$ROOT_DIR/$1"
}

# Helper: create empty file (and its parent dirs)
mk_file() {
  mkdir -p "$(dirname "$ROOT_DIR/$1")"
  touch "$ROOT_DIR/$1"
}

# -----------------------------------------------------------------
# Root level
# -----------------------------------------------------------------
mk_dir ""
mk_file ".env.example"
mk_file "docker-compose.yml"
mk_file "README.md"

# -----------------------------------------------------------------
# client-mobile
# -----------------------------------------------------------------
mk_dir "client-mobile/assets/images"
mk_dir "client-mobile/components/cards"
mk_dir "client-mobile/components/ui"
mk_dir "client-mobile/components/camera"
mk_dir "client-mobile/hooks"
mk_dir "client-mobile/navigation"
mk_dir "client-mobile/screens"
mk_dir "client-mobile/services"
mk_dir "client-mobile/utils"

mk_file "client-mobile/components/cards/UserCard.tsx"
mk_file "client-mobile/components/ui/Button.tsx"
mk_file "client-mobile/components/ui/Loading.tsx"
mk_file "client-mobile/components/camera/FaceUploadCamera.tsx"
mk_file "client-mobile/hooks/useAuth.ts"
mk_file "client-mobile/hooks/useMatches.ts"
mk_file "client-mobile/hooks/useLocation.ts"
mk_file "client-mobile/navigation/AppNavigator.tsx"
mk_file "client-mobile/screens/AuthScreen.tsx"
mk_file "client-mobile/screens/HomeScreen.tsx"
mk_file "client-mobile/screens/ChatScreen.tsx"
mk_file "client-mobile/screens/ProfileScreen.tsx"
mk_file "client-mobile/screens/PremiumScreen.tsx"
mk_file "client-mobile/services/api.ts"
mk_file "client-mobile/services/authService.ts"
mk_file "client-mobile/services/locationService.ts"
mk_file "client-mobile/services/socketService.ts"
mk_file "client-mobile/utils/swipeGesture.ts"
mk_file "client-mobile/App.tsx"
mk_file "client-mobile/app.json"

# -----------------------------------------------------------------
# client-web
# -----------------------------------------------------------------
mk_dir "client-web/public"
mk_dir "client-web/src/pages"
mk_dir "client-web/src/components/SwipeStack"
mk_dir "client-web/src/components/Layout"
mk_dir "client-web/src/services"
mk_dir "client-web/src/hooks"
mk_dir "client-web/src/store/slices"
mk_dir "client-web/src/i18n"

mk_file "client-web/public/index.html"
mk_file "client-web/src/pages/Home.tsx"
mk_file "client-web/src/pages/Login.tsx"
mk_file "client-web/src/pages/Chat.tsx"
mk_file "client-web/src/pages/Profile.tsx"
mk_file "client-web/src/components/SwipeStack/Card.tsx"
mk_file "client-web/src/components/SwipeStack/SwipeArea.tsx"
mk_file "client-web/src/services/api.ts"
mk_file "client-web/src/services/auth.ts"
mk_file "client-web/src/hooks/useWebSocket.ts"
mk_file "client-web/src/hooks/useAuth.ts"
mk_file "client-web/src/store/store.ts"
mk_file "client-web/src/store/slices/authSlice.ts"
mk_file "client-web/src/i18n/en.json"
mk_file "client-web/src/i18n/es.json"
mk_file "client-web/src/App.tsx"
mk_file "client-web/Dockerfile"
mk_file "client-web/package.json"

# -----------------------------------------------------------------
# server
# -----------------------------------------------------------------
mk_dir "server/src/prisma"
mk_dir "server/src/modules/auth/dto"
mk_dir "server/src/modules/user"
mk_dir "server/src/modules/chat"
mk_dir "server/src/modules/match"
mk_dir "server/src/modules/subscription"
mk_dir "server/src/modules/admin"
mk_dir "server/src/modules/socket"
mk_dir "server/src/modules/ai"
mk_dir "server/src/guards"
mk_dir "server/src/i18n/en"
mk_dir "server/src/swagger"

mk_file "server/src/app.module.ts"
mk_file "server/src/main.ts"
mk_file "server/src/prisma/schema.prisma"
mk_file "server/src/modules/auth/auth.controller.ts"
mk_file "server/src/modules/auth/auth.service.ts"
mk_file "server/src/modules/subscription/subscription.controller.ts"
mk_file "server/src/modules/subscription/stripe.webhook.controller.ts"
mk_file "server/src/modules/admin/admin.controller.ts"
mk_file "server/src/modules/socket/socket.gateway.ts"
mk_file "server/src/modules/ai/ai.controller.ts"
mk_file "server/src/guards/ws-jwt.guard.ts"
mk_file "server/src/i18n/en/messages.json"
mk_file "server/src/swagger/swagger.config.ts"
mk_file "server/Dockerfile"
mk_file "server/nest-cli.json"
mk_file "server/package.json"

# -----------------------------------------------------------------
# ai-service
# -----------------------------------------------------------------
mk_dir "ai-service/model"
mk_dir "ai-service/scripts"

mk_file "ai-service/main.py"
mk_file "ai-service/model/train_model.ipynb"
mk_file "ai-service/scripts/train_matching_model.py"
mk_file "ai-service/requirements.txt"
mk_file "ai-service/Dockerfile"

# -----------------------------------------------------------------
# admin
# -----------------------------------------------------------------
mk_dir "admin/src/resources"

mk_file "admin/src/dataProvider.ts"
mk_file "admin/src/App.tsx"
mk_file "admin/src/resources/UserList.tsx"
mk_file "admin/src/resources/SubscriptionList.tsx"
mk_file "admin/Dockerfile"
mk_file "admin/package.json"

# -----------------------------------------------------------------
# scripts
# -----------------------------------------------------------------
mk_dir "scripts"

mk_file "scripts/seed.ts"
mk_file "scripts/test-stripe-webhook.js"
mk_file "scripts/generate-swagger.js"

echo
echo "✅ Done! Project skeleton created under './$ROOT_DIR'"
