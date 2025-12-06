# Vibe-on-the-Go

**Meta-repository for the Vibe-on-the-Go project**

This repository contains documentation, infrastructure configuration, and setup scripts for the Vibe-on-the-Go project. The project consists of three main components, each in its own repository:

## 📦 Component Repositories

- **[vibe-cli](https://github.com/SGranquist13/vibe-cli)** - Command-line wrapper for AI coding agents (Claude Code, Codex, Gemini CLI, Cursor CLI)
- **[vibe-mobile](https://github.com/SGranquist13/vibe-mobile)** - React Native mobile app (iOS, Android, Web)
- **[vibe-server](https://github.com/SGranquist13/vibe-server)** - Backend server for encrypted sync (self-hosted)

## 🚀 Quick Start

For complete setup instructions, see **[QUICK_START.md](QUICK_START.md)**.

The quickest way to get started:

1. **Clone this repository:**
   ```bash
   git clone https://github.com/SGranquist13/votg.git
   cd votg
   ```

2. **Clone all component repositories:**
   ```bash
   git clone https://github.com/SGranquist13/vibe-cli.git
   git clone https://github.com/SGranquist13/vibe-mobile.git
   git clone https://github.com/SGranquist13/vibe-server.git
   ```

3. **Follow the detailed guide:** See [QUICK_START.md](QUICK_START.md) for step-by-step instructions to set up infrastructure, server, mobile app, and CLI.

## 📚 Documentation

- **[QUICK_START.md](QUICK_START.md)** - Complete setup and usage guide
- **[AGENTS.md](AGENTS.md)** - AI agent development guide
- **[CLAUDE.md](CLAUDE.md)** - Development guidelines
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

## 📄 License

MIT License
