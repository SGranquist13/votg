# Vibe-on-the-Go

**Meta-repository for the Vibe-on-the-Go project**

This repository contains documentation, infrastructure configuration, and setup scripts for the Vibe-on-the-Go project. The project consists of three main components, each in its own repository:

## 📦 Component Repositories

- **[vibe-cli](https://github.com/SGranquist13/vibe-cli)** - Command-line wrapper for AI coding agents (Claude Code, Codex, Gemini CLI, Cursor CLI)
- **[vibe-mobile](https://github.com/SGranquist13/vibe-mobile)** - React Native mobile app (iOS, Android, Web)
- **[vibe-server](https://github.com/SGranquist13/vibe-server)** - Backend server for encrypted sync (self-hosted)

## 🚀 Quick Start

See [QUICK_START.md](QUICK_START.md) for complete setup instructions.

### Prerequisites

- Node.js 20+ and npm/yarn
- Docker and Docker Compose
- Git

### Setup

1. **Clone all component repositories:**
   ```bash
   git clone https://github.com/SGranquist13/vibe-cli.git
   git clone https://github.com/SGranquist13/vibe-mobile.git
   git clone https://github.com/SGranquist13/vibe-server.git
   ```

2. **Start infrastructure services:**
   ```bash
   docker-compose up -d
   ```

3. **Set up and start the server:**
   ```bash
   cd vibe-server
   cp .env.example .env
   # Edit .env and set VIBE_MASTER_SECRET (generate with: openssl rand -hex 32)
   yarn install
   yarn migrate
   yarn dev
   ```

4. **Set up and start the mobile app:**
   ```bash
   cd vibe-mobile
   yarn install
   yarn start:local-server
   ```

5. **Build and install the CLI:**
   ```bash
   cd vibe-cli
   yarn install
   yarn build
   npm link
   ```

For detailed instructions, see [QUICK_START.md](QUICK_START.md).

## 📚 Documentation

- **[QUICK_START.md](QUICK_START.md)** - Complete setup and usage guide
- **[AGENTS.md](AGENTS.md)** - AI agent development guide
- **[CLAUDE.md](CLAUDE.md)** - Development guidelines
- **[CLI_SETUP.md](CLI_SETUP.md)** - CLI-specific setup instructions
- **[START_CHECKLIST.md](START_CHECKLIST.md)** - Quick reference checklist

## 🏗️ Architecture

```
┌─────────────┐
│   Mobile    │ (React Native - iOS/Android/Web)
│     App     │
└──────┬──────┘
       │
       │ WebSocket + HTTP (Encrypted)
       │
┌──────▼──────┐
│   Server    │ (Node.js + Fastify)
│  (Port 3005)│
└──────┬──────┘
       │
       │ WebSocket + HTTP (Encrypted)
       │
┌──────▼──────┐
│     CLI     │ (Node.js - Terminal)
│  (vibe cmd) │
└──────┬──────┘
       │
       │ Process/Stdio
       │
┌──────▼──────┐
│   Agent     │ (Claude Code / Codex)
│             │
└─────────────┘
```

All communication is **end-to-end encrypted**. The server only sees encrypted blobs.

## 🔄 Syncing with Upstream

This repository is a fork of [slopus/happy](https://github.com/slopus/happy). To sync future changes:

```bash
git fetch upstream
git merge upstream/main  # Or cherry-pick specific commits
```

Each component repository also has an `upstream` remote pointing to the original Happy project for selective syncing.

## 📄 License

MIT License
