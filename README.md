<div align="center">

# ✨ Vibe-on-the-Go

**Take your AI coding agents anywhere. Work seamlessly across devices with end-to-end encryption.**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![TypeScript](https://img.shields.io/badge/TypeScript-007ACC?logo=typescript&logoColor=white)](https://www.typescriptlang.org/)
[![React Native](https://img.shields.io/badge/React_Native-20232A?logo=react&logoColor=61DAFB)](https://reactnative.dev/)

[Features](#-features) • [Quick Start](#-quick-start) • [Architecture](#-architecture) • [Documentation](#-documentation) • [Security](#-security)

</div>

---

## 🚀 What is Vibe-on-the-Go?

**Vibe-on-the-Go** is a powerful platform that brings your AI coding agents (Claude Code, Codex, and more) to your mobile devices and web browser. Work on your projects from anywhere, switch seamlessly between devices, and maintain complete privacy with zero-knowledge encryption.

### Why Vibe-on-the-Go?

- 📱 **Mobile-First Access** - Control your AI agents from iOS, Android, or any web browser
- ⚡ **Instant Synchronization** - Real-time updates across all your devices
- 🔐 **End-to-End Encryption** - Your data is encrypted before it leaves your device
- 🏠 **Self-Hosted Option** - Full control with your own server infrastructure
- 🔄 **Seamless Device Switching** - Start on desktop, continue on mobile, finish on web
- 🔔 **Push Notifications** - Stay informed about agent activity in real-time
- 🛡️ **Zero-Knowledge Architecture** - Even the server cannot decrypt your data

---

## ✨ Features

### 🔒 **Enterprise-Grade Security**
- End-to-end encryption using TweetNaCl (NaCl library)
- Zero-knowledge server architecture
- Cryptographic challenge-response authentication
- Per-session encryption keys

### 📱 **Cross-Platform Access**
- Native iOS and Android apps
- Progressive Web App (PWA) support
- Responsive web interface
- Real-time synchronization

### ⚡ **Real-Time Sync**
- WebSocket-based instant updates
- Message queue with ordering and deduplication
- Optimistic UI updates
- Automatic reconnection handling

### 🎛️ **Flexible Control**
- Switch between local and remote modes instantly
- Approve tool permissions from your mobile device
- View agent reasoning and thought processes
- Monitor session state and history

### 🏗️ **Self-Hosted & Open Source**
- Complete control over your infrastructure
- Docker Compose setup included
- PostgreSQL and Redis support
- MIT License - use it however you want

---

## 🏗️ Architecture

Vibe-on-the-Go consists of three main components working together:

```
┌─────────────────────────────────────────────────────────────┐
│                    Mobile App                                 │
│  (React Native - iOS / Android / Web)                        │
│  • Real-time session viewing                                 │
│  • Remote agent control                                      │
│  • Push notifications                                        │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        │ WebSocket + HTTP
                        │ (End-to-End Encrypted)
                        │
┌───────────────────────▼─────────────────────────────────────┐
│                    Server                                     │
│  (Node.js + Fastify + PostgreSQL + Redis)                    │
│  • Zero-knowledge encrypted storage                          │
│  • WebSocket message routing                                 │
│  • Authentication & authorization                            │
│  • Session management                                        │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        │ WebSocket + HTTP
                        │ (End-to-End Encrypted)
                        │
┌───────────────────────▼─────────────────────────────────────┐
│                    CLI                                        │
│  (Node.js - Terminal)                                         │
│  • Agent process management                                  │
│  • Session synchronization                                   │
│  • Encryption/decryption                                     │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        │ Process/Stdio
                        │
┌───────────────────────▼─────────────────────────────────────┐
│                    AI Agents                                  │
│  (Claude Code / Codex / Gemini CLI / Cursor CLI)             │
│  • Code generation                                           │
│  • Project analysis                                          │
│  • Tool execution                                            │
└─────────────────────────────────────────────────────────────┘
```

**Key Security Features:**
- 🔐 All communication is encrypted before transmission
- 🛡️ Server operates in zero-knowledge mode (cannot decrypt data)
- 🔑 Per-session encryption keys
- ✍️ Cryptographic signatures for authentication

---

## 🚀 Quick Start

### Prerequisites

- **Node.js** 20+ and npm/yarn
- **Docker** and Docker Compose
- **Git** for cloning repositories

### Installation

1. **Clone the meta-repository:**
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

3. **Follow the complete setup guide:**
   
   📖 **[See QUICK_START.md for detailed instructions →](QUICK_START.md)**

   The quick start guide will walk you through:
   - Setting up infrastructure (PostgreSQL, Redis, MinIO)
   - Configuring and starting the server
   - Setting up the mobile app
   - Installing and configuring the CLI
   - Authenticating and creating your first session

### First Steps After Installation

```bash
# 1. Authenticate your CLI
vibe auth login

# 2. Start a Claude Code session
vibe claude

# 3. Scan the QR code with your mobile app
# 4. Start coding from anywhere!
```

---

## 📦 Component Repositories

Vibe-on-the-Go is built as a modular system with three main components:

| Component | Repository | Description |
|-----------|-----------|-------------|
| **CLI** | [vibe-cli](https://github.com/SGranquist13/vibe-cli) | Command-line wrapper for AI coding agents. Manages agent processes, handles encryption, and syncs with the server. |
| **Mobile** | [vibe-mobile](https://github.com/SGranquist13/vibe-mobile) | React Native app for iOS, Android, and Web. Provides real-time session viewing and remote control. |
| **Server** | [vibe-server](https://github.com/SGranquist13/vibe-server) | Backend server for encrypted sync. Zero-knowledge architecture with PostgreSQL and Redis. |

Each component can be developed and deployed independently while working together seamlessly.

---

## 🛠️ Technology Stack

### CLI
- **Runtime**: Node.js with TypeScript
- **Agents**: Claude Code SDK, Codex MCP, Gemini CLI, Cursor CLI
- **Communication**: Socket.IO for WebSocket connections
- **Encryption**: TweetNaCl (NaCl library)

### Server
- **Framework**: Fastify (high-performance Node.js framework)
- **Database**: PostgreSQL with Prisma ORM
- **Cache**: Redis for session state and real-time data
- **Storage**: MinIO for object storage (optional)
- **WebSockets**: Socket.IO for real-time communication

### Mobile
- **Framework**: React Native with Expo
- **Language**: TypeScript
- **Navigation**: Expo Router
- **State Management**: React Context + Reducers
- **Platforms**: iOS, Android, Web (PWA)

---

## 🔒 Security & Privacy

### Zero-Knowledge Architecture

Vibe-on-the-Go is built with privacy as a core principle:

- **End-to-End Encryption**: All data is encrypted on the client before transmission
- **Zero-Knowledge Server**: The server cannot decrypt your data, even if compromised
- **Per-Session Keys**: Each session uses unique encryption keys
- **Cryptographic Authentication**: Challenge-response signatures prevent MITM attacks
- **Local Key Storage**: Private keys stored securely in `~/.vibe/` with restricted permissions

### Encryption Details

- **Algorithm**: TweetNaCl (NaCl library) - industry-standard cryptography
- **Key Management**: Per-session encryption keys generated client-side
- **Transport**: All WebSocket and HTTP communication encrypted
- **Storage**: Encrypted blobs stored on server (server cannot decrypt)

---

## 📚 Documentation

Comprehensive documentation is available for developers and users:

| Document | Description |
|----------|-------------|
| **[QUICK_START.md](QUICK_START.md)** | Complete setup and usage guide with step-by-step instructions |
| **[AGENTS.md](AGENTS.md)** | AI agent development guide - architecture, integration points, and patterns |
| **[CLAUDE.md](.cursorrules)** | Development guidelines and coding standards |
| **[START_CHECKLIST.md](START_CHECKLIST.md)** | Quick reference checklist for setup |

### Component-Specific Documentation

- **CLI**: See `vibe-cli repository for CLI-specific documentation
- **Server**: See `vibe-server` repository for server development guide
- **Mobile**: See `vibe-mobile` repository for mobile app development guide

---

## 🎯 Use Cases

### Remote Development
Start a coding session on your desktop, continue on your phone during your commute, and finish on your laptop at a coffee shop.

### Team Collaboration
Share agent sessions with team members while maintaining privacy through end-to-end encryption.

### Mobile-First Workflows
Develop and review code changes directly from your mobile device, perfect for code reviews on the go.

### Secure Development
Work with sensitive codebases knowing that your data is encrypted end-to-end and the server cannot access your code.

---

## 🤝 Contributing

We welcome contributions! Each component repository has its own contribution guidelines:

- **[vibe-cli](https://github.com/SGranquist13/vibe-cli)** - CLI contributions
- **[vibe-mobile](https://github.com/SGranquist13/vibe-mobile)** - Mobile app contributions
- **[vibe-server](https://github.com/SGranquist13/vibe-server)** - Server contributions

### Development Setup

1. Clone all repositories (see [Quick Start](#-quick-start))
2. Read the relevant component documentation
3. Check the [AGENTS.md](AGENTS.md) guide for architecture details
4. Follow the coding standards in [CLAUDE.md](.cursorrules)

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## 🌟 Support

- **Documentation**: Check the [Documentation](#-documentation) section above
- **Issues**: Open an issue in the relevant component repository
- **Questions**: Review the [AGENTS.md](AGENTS.md) guide for architecture questions

---

<div align="center">

**Built with ❤️ for developers who want to code from anywhere**

[Get Started](#-quick-start) • [View Documentation](#-documentation) • [Learn More](#-architecture)

</div>
