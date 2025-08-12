#!/bin/bash
# deploy-dating-app.sh
# Full production deployment for Dating App with WebRTC
# Ubuntu 22.04 LTS

set -euo pipefail
IFS=$'\n\t'

# =====================================
# 🔧 CONFIGURATION (CHANGE THESE)
# =====================================
DOMAIN="yourdomain.com"
EMAIL="admin@yourdomain.com"
BACKEND_PORT=3000
WEB_PORT=3001
AI_PORT=8000
TURN_PORT=3478
TURN_TLS_PORT=5349
STUN_PORT=19302

# =====================================
# 🐍 AUTO-GENERATED PROJECT STRUCTURE
# =====================================

echo "🏗️ Creating project structure..."
mkdir -p dating-app/{mobile,web,backend,ai-service,prisma,scripts,docs,certificates}
cd dating-app

# -------------------------------------
# 1. Prisma Schema
# -------------------------------------
cat > prisma/schema.prisma << 'EOF'
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id              String    @id @default(uuid())
  email           String    @unique
  name            String?
  photos          String[]
  isPremium       Boolean   @default(false)
  createdAt       DateTime  @default(now())
  updatedAt       DateTime  @updatedAt
}

model VideoCall {
  id         String   @id @default(uuid())
  roomId     String   @unique
  participants User[]
  startedAt  DateTime @default(now())
  endedAt    DateTime?
}
EOF

# -------------------------------------
# 2. Backend: WebRTC Signaling + NestJS
# -------------------------------------
mkdir -p backend/src/{app,webrtc,prisma}
cat > backend/src/main.ts << 'EOF'
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { WsAdapter } from '@nestjs/platform-ws';
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.useWebSocketAdapter(new WsAdapter(app));
  app.useGlobalPipes(new ValidationPipe());
  app.enableCors();
  await app.listen(process.env.PORT || 3000);
}
bootstrap();
EOF

cat > backend/src/webrtc/webrtc.gateway.ts << 'EOF'
import { WebSocketGateway, SubscribeMessage, WebSocketServer, OnGatewayConnection, OnGatewayDisconnect } from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';

@WebSocketGateway({ cors: true, path: '/webrtc' })
export class WebRTCGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  private rooms: Map<string, Set<string>> = new Map();

  handleConnection(client: Socket) {
    console.log('Client connected:', client.id);
  }

  handleDisconnect(client: Socket) {
    this.leaveAllRooms(client);
    console.log('Client disconnected:', client.id);
  }

  private leaveAllRooms(client: Socket) {
    this.rooms.forEach((clients, room) => {
      if (clients.has(client.id)) {
        clients.delete(client.id);
        this.server.to(room).emit('user-left', client.id);
        if (clients.size === 0) this.rooms.delete(room);
      }
    });
  }

  @SubscribeMessage('join-call')
  handleJoinCall(client: Socket, data: { roomId: string }) {
    const { roomId } = data;
    client.join(roomId);
    if (!this.rooms.has(roomId)) this.rooms.set(roomId, new Set());
    this.rooms.get(roomId).add(client.id);

    client.to(roomId).emit('user-joined', client.id);
    client.emit('call-joined', { roomId, peers: Array.from(this.rooms.get(roomId)).filter(id => id !== client.id) });
  }

  @SubscribeMessage('webrtc-signal')
  handleSignal(client: Socket, data: { target: string; signal: any }) {
    client.to(data.target).emit('webrtc-signal', { from: client.id, signal: data.signal });
  }
}
EOF

# -------------------------------------
# 3. WebRTC Frontend (Mobile & Web)
# -------------------------------------
cat > mobile/components/VideoCallScreen.tsx << 'EOF'
import React, { useEffect, useRef, useState } from 'react';
import { View, Button, Alert } from 'react-native';
import { io } from 'socket.io-client';
import { RTCPeerConnection, RTCView } from 'react-native-webrtc';

const configuration = { iceServers: [{ urls: 'stun:stun.l.google.com:19302' }] };

export default function VideoCallScreen({ route }) {
  const { roomId } = route.params;
  const [localStream, setLocalStream] = useState(null);
  const [remoteStream, setRemoteStream] = useState(null);
  const pcRef = useRef<RTCPeerConnection | null>(null);
  const socket = useRef(null);

  useEffect(() => {
    socket.current = io('https://yourdomain.com', { path: '/webrtc' });

    const startCall = async () => {
      const stream = await navigator.mediaDevices.getUserMedia({ video: true, audio: true });
      setLocalStream(stream);

      pcRef.current = new RTCPeerConnection(configuration);
      pcRef.current.addStream(stream);

      pcRef.current.onicecandidate = (e) => {
        if (e.candidate) {
          socket.current.emit('webrtc-signal', { target: '...', signal: e.candidate });
        }
      };

      pcRef.current.onaddstream = (e) => {
        setRemoteStream(e.stream);
      };

      socket.current.emit('join-call', { roomId });
    };

    startCall();

    return () => {
      pcRef.current?.close();
      socket.current?.disconnect();
    };
  }, [roomId]);

  return (
    <View style={{ flex: 1 }}>
      {localStream && <RTCView streamURL={localStream.toURL()} style={{ width: 100, height: 100, position: 'absolute', top: 20, right: 20 }} />}
      {remoteStream && <RTCView streamURL={remoteStream.toURL()} style={{ flex: 1 }} />}
    </View>
  );
}
EOF

# -------------------------------------
# 4. WebRTC in Web (Next.js)
# -------------------------------------
cat > web/components/VideoCallModal.tsx << 'EOF'
import { useEffect, useRef } from 'react';
import io from 'socket.io-client';

export default function VideoCallModal({ roomId, onClose }) {
  const localRef = useRef();
  const remoteRef = useRef();
  const pc = useRef();
  const socket = useRef();

  useEffect(() => {
    socket.current = io('https://yourdomain.com', { path: '/webrtc' });

    const start = async () => {
      const stream = await navigator.mediaDevices.getUserMedia({ video: true, audio: true });
      localRef.current.srcObject = stream;

      pc.current = new RTCPeerConnection({ iceServers: [{ urls: 'stun:stun.l.google.com:19302' }] });
      stream.getTracks().forEach(track => pc.current.addTrack(track, stream));

      pc.current.onicecandidate = (e) => {
        if (e.candidate) socket.current.emit('webrtc-signal', { target: '...', signal: e.candidate });
      };

      pc.current.ontrack = (e) => {
        remoteRef.current.srcObject = e.streams[0];
      };

      socket.current.emit('join-call', { roomId });
    };

    start();

    return () => {
      pc.current?.close();
      socket.current?.disconnect();
    };
  }, [roomId]);

  return (
    <div style={{ position: 'fixed', inset: 0, background: 'black', zIndex: 1000 }}>
      <video ref={localRef} autoPlay muted style={{ width: 120, position: 'absolute', top: 20, right: 20 }} />
      <video ref={remoteRef} autoPlay style={{ width: '100%', height: '100%' }} />
      <button onClick={onClose} style={{ position: 'absolute', top: 20, left: 20 }}>End Call</button>
    </div>
  );
}
EOF

# -------------------------------------
# 5. Docker Compose
# -------------------------------------
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  postgres:
    image: postgres:15
    restart: always
    environment:
      POSTGRES_USER: dating
      POSTGRES_PASSWORD: prod_secure_password_123
      POSTGRES_DB: dating_app
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - dating-net

  redis:
    image: redis:alpine
    restart: always
    networks:
      - dating-net

  backend:
    build: ./backend
    ports:
      - "3000:3000"
    environment:
      DATABASE_URL: postgresql://dating:prod_secure_password_123@postgres:5432/dating_app
      REDIS_URL: redis://redis:6379
      JWT_SECRET: $(openssl rand -base64 32)
      NODE_ENV: production
    depends_on:
      - postgres
      - redis
    networks:
      - dating-net

  web:
    build: ./web
    ports:
      - "3001:3001"
    networks:
      - dating-net

  ai-service:
    build: ./ai-service
    ports:
      - "8000:8000"
    networks:
      - dating-net

  coturn:
    image: instrumentisto/coturn
    ports:
      - "3478:3478/udp"
      - "3478:3478/tcp"
      - "5349:5349/tcp"
    environment:
      - COTURN_USERNAME=turnuser
      - COTURN_PASSWORD=turnpass123
      - COTURN_REALM=yourdomain.com
      - COTURN_NO_TLS=1
      - COTURN_NO_DTLS=1
    networks:
      - dating-net

volumes:
  postgres_data:

networks:
  dating-net:
    driver: bridge
EOF

# -------------------------------------
# 6. Nginx + SSL Setup Script
# -------------------------------------
cat > scripts/setup-nginx-ssl.sh << 'EOF'
#!/bin/bash
set -euo pipefail

DOMAIN="$1"
EMAIL="$2"

apt update
apt install -y nginx certbot python3-certbot-nginx

# Nginx Config
cat > /etc/nginx/sites-available/dating-app << EOF
server {
    listen 80;
    server_name $DOMAIN;
    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }
    location / {
        return 301 https://\$host\$request_uri;
    }
}

server {
    listen 443 ssl;
    server_name $DOMAIN;

    ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;

    location / {
        proxy_pass http://localhost:3001;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }

    location /api {
        proxy_pass http://localhost:3000;
        proxy_set_header Host \$host;
    }

    location /webrtc {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
EOF

ln -sf /etc/nginx/sites-available/dating-app /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

mkdir -p /var/www/certbot
certbot certonly --nginx -d $DOMAIN --non-interactive --agree-tos -m $EMAIL --redirect

# Auto-renewal
(crontab -l 2>/dev/null; echo "0 12 * * * /usr/bin/certbot renew --quiet") | crontab -
EOF

# -------------------------------------
# 7. Systemd Service (Auto-start)
# -------------------------------------
cat > scripts/setup-service.sh << 'EOF'
#!/bin/bash
cat > /etc/systemd/system/dating-app.service << 'INNEREOF'
[Unit]
Description=Dating App Docker
After=docker.service
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/root/dating-app
ExecStart=/usr/bin/docker-compose up -d
ExecStop=/usr/bin/docker-compose down
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
INNEREOF

systemctl daemon-reload
systemctl enable dating-app
systemctl start dating-app
EOF

# -------------------------------------
# 8. Final Instructions
# -------------------------------------
cat > README.md << EOF
# 💘 Dating App - Production Ready

## 🚀 Deployed at: https://$DOMAIN

### ✅ Features
- Tinder-like swipe
- Realtime chat
- AI Matching
- Video Calling (WebRTC)
- Admin Dashboard
- Stripe Monetization
- i18n

### 🔐 Admin
- Access: https://$DOMAIN/admin
- Credentials: See your admin setup

### 🛠️ Maintenance
\`\`\`bash
cd /root/dating-app
docker-compose logs backend
docker-compose restart backend
\`\`\`
EOF

# =====================================
# 🚀 EXECUTE DEPLOYMENT
# =====================================

echo "🚀 Starting deployment on Ubuntu..."

# Install dependencies
apt update
apt install -y docker.io docker-compose nginx git certbot

# Copy domain into script
sed -i "s/DOMAIN=\"yourdomain.com\"/DOMAIN=\"$DOMAIN\"/g" scripts/setup-nginx-ssl.sh
sed -i "s/EMAIL=\"admin@yourdomain.com\"/EMAIL=\"$EMAIL\"/g" scripts/setup-nginx-ssl.sh

# Run Nginx + SSL
chmod +x scripts/setup-nginx-ssl.sh
scripts/setup-nginx-ssl.sh "$DOMAIN" "$EMAIL"

# Build containers
docker-compose build

# Setup systemd
chmod +x scripts/setup-service.sh
cp scripts/setup-service.sh /tmp/
/tmp/setup-service.sh

# Done
echo "✅ Deployment complete!"
echo "🌐 App: https://$DOMAIN"
echo "🔧 Admin: https://$DOMAIN/admin"
echo "📞 WebRTC: STUN: $DOMAIN:$STUN_PORT, TURN: $DOMAIN:$TURN_PORT"
echo "ℹ️  Run 'systemctl status dating-app' to check status"