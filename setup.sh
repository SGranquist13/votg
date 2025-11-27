#!/bin/bash

set -e

echo "🚀 Setting up Vibe-on-the-Go..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

# Start infrastructure services
echo "📦 Starting infrastructure services (PostgreSQL, Redis, MinIO)..."
docker-compose up -d

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 5

# Set up server
echo "🔧 Setting up server..."
cd server

if [ ! -f .env ]; then
    echo "📝 Creating server .env file..."
    cp .env.example .env
    
    # Generate a secure master secret
    if command -v openssl &> /dev/null; then
        SECRET=$(openssl rand -hex 32)
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            sed -i '' "s/VIBE_MASTER_SECRET=your-secret-key-here-change-this/VIBE_MASTER_SECRET=$SECRET/" .env
        else
            # Linux
            sed -i "s/VIBE_MASTER_SECRET=your-secret-key-here-change-this/VIBE_MASTER_SECRET=$SECRET/" .env
        fi
        echo "✅ Generated and set VIBE_MASTER_SECRET"
    else
        echo "⚠️  openssl not found. Please manually set VIBE_MASTER_SECRET in server/.env"
        echo "   You can generate one with: openssl rand -hex 32"
    fi
else
    echo "✅ Server .env file already exists"
fi

# Install server dependencies
if [ ! -d "node_modules" ]; then
    echo "📦 Installing server dependencies..."
    yarn install
else
    echo "✅ Server dependencies already installed"
fi

# Run database migrations
echo "🗄️  Running database migrations..."
yarn migrate

cd ..

# Set up mobile app
echo "📱 Setting up mobile app..."
cd mobile

if [ ! -d "node_modules" ]; then
    echo "📦 Installing mobile app dependencies..."
    yarn install
else
    echo "✅ Mobile app dependencies already installed"
fi

cd ..

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Start the server: cd server && yarn dev"
echo "2. Start the mobile app: cd mobile && yarn start:local-server"
echo ""
echo "The server will be available at http://localhost:3005"






