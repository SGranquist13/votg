# AGENTS.md - AI Agent Development Guide

This document provides comprehensive guidance for AI agents (Claude Code, Codex, and similar tools) working on the Vibe-on-the-Go codebase. It covers project structure, architecture, agent integration points, and development guidelines.

## Table of Contents

1. [Project Overview](#project-overview)
2. [Component Breakdown](#component-breakdown)
3. [Agent Integration Points](#agent-integration-points)
4. [Architecture & Data Flow](#architecture--data-flow)
5. [Key Files Reference](#key-files-reference)
6. [Development Guidelines](#development-guidelines)
7. [Common Patterns](#common-patterns)

---

## Project Overview

**Vibe-on-the-Go** is a multi-component system that enables mobile and web access to Claude Code and Codex with end-to-end encryption. The project consists of three main components:

- **CLI** (`cli/`) - Command-line wrapper for Claude Code and Codex
- **Server** (`server/`) - Backend server for encrypted sync (self-hosted)
- **Mobile** (`mobile/`) - React Native mobile app (iOS, Android, Web)

### Key Features

- 📱 Mobile access to Claude Code and Codex
- 🔔 Push notifications for agent events
- ⚡ Instant device switching (local ↔ remote)
- 🔐 End-to-end encryption (zero-knowledge server)
- 🏠 Self-hosted server option

### Technology Stack

- **CLI**: Node.js, TypeScript, Claude Code SDK, Socket.IO
- **Server**: Node.js, Fastify, PostgreSQL (Prisma), Redis, Socket.IO
- **Mobile**: React Native, Expo, TypeScript, Socket.IO

---

## Component Breakdown

### 1. CLI Component (`cli/`)

**Purpose**: Wraps Claude Code and Codex to enable remote control and session sharing.

**Key Responsibilities**:
- Spawns and manages Claude Code/Codex processes
- Handles authentication with mobile app
- Manages session state and synchronization
- Provides daemon service for background session management
- Bridges agent output to encrypted server communication

**Entry Points**:
- `cli/src/index.ts` - Main CLI entry point
- `cli/src/claude/runClaude.ts` - Claude Code session runner
- `cli/src/codex/runCodex.ts` - Codex session runner
- `cli/src/daemon/run.ts` - Background daemon service

**Key Modules**:
- `cli/src/api/` - Server communication and encryption
- `cli/src/claude/` - Claude Code integration
- `cli/src/codex/` - Codex integration
- `cli/src/daemon/` - Background service management

**Documentation**: See [`cli/CLAUDE.md`](cli/CLAUDE.md) for detailed CLI development guidelines.

### 2. Server Component (`server/`)

**Purpose**: Zero-knowledge backend that stores encrypted data and syncs between devices.

**Key Responsibilities**:
- Stores encrypted session data (cannot decrypt)
- Manages WebSocket connections for real-time sync
- Handles authentication and authorization
- Provides REST API for session/machine management
- Routes encrypted messages between CLI and mobile

**Entry Points**:
- `server/sources/main.ts` - Server entry point
- `server/sources/app/api/api.ts` - API server setup

**Key Modules**:
- `server/sources/app/` - Application logic
- `server/sources/storage/` - Database and storage utilities
- `server/sources/modules/` - Reusable modules

**Documentation**: See [`server/CLAUDE.md`](server/CLAUDE.md) for detailed server development guidelines.

### 3. Mobile Component (`mobile/`)

**Purpose**: React Native app for viewing and controlling Claude Code/Codex sessions.

**Key Responsibilities**:
- Displays real-time session updates
- Allows remote control of agent sessions
- Handles authentication via QR code
- Manages encrypted sync state
- Provides push notifications

**Entry Points**:
- `mobile/index.ts` - App entry point
- `mobile/sources/app/_layout.tsx` - Root navigation

**Key Modules**:
- `mobile/sources/sync/` - Real-time sync engine
- `mobile/sources/auth/` - Authentication logic
- `mobile/sources/app/` - Screen components
- `mobile/sources/components/` - Reusable UI components

**Documentation**: See [`mobile/CLAUDE.md`](mobile/CLAUDE.md) for detailed mobile development guidelines.

---

## Agent Integration Points

> **📚 Detailed Integration Documentation**: For comprehensive details on how each agent is integrated, see:
> - **Claude Code**: [`cli/docs/CLAUDE_CODE_INTEGRATION.md`](cli/docs/CLAUDE_CODE_INTEGRATION.md) - Complete architecture, message flow, mode switching, and extensibility guide
> - **Codex**: [`cli/docs/CODEX_INTEGRATION.md`](cli/docs/CODEX_INTEGRATION.md) - MCP integration, event processing, permission system, and extensibility guide
>
> **⚠️ Before modifying agent integration code**, review the relevant integration documentation to understand the architecture and patterns.

### Claude Code Integration

Claude Code is integrated through two modes:

#### 1. Local/Interactive Mode
- **File**: `cli/src/claude/claudeLocal.ts`
- **How it works**: Spawns Claude Code as a subprocess and watches session files
- **Use case**: Direct terminal interaction with Claude Code
- **Key files**:
  - `cli/src/claude/claudeLocal.ts` - Process spawning and file watching
  - `cli/src/claude/loop.ts` - Main control loop for mode switching

#### 2. Remote Mode
- **File**: `cli/src/claude/claudeRemote.ts`
- **How it works**: Uses Claude Code SDK to run queries programmatically
- **Use case**: Mobile app controls the agent remotely
- **Key files**:
  - `cli/src/claude/claudeRemote.ts` - SDK-based remote execution
  - `cli/src/claude/sdk/query.ts` - SDK query wrapper

#### Session Management
- **File**: `cli/src/claude/runClaude.ts`
- Creates encrypted session with server
- Manages WebSocket connection for real-time sync
- Handles mode switching (local ↔ remote)
- Processes agent messages and forwards to mobile

**📖 See [`cli/docs/CLAUDE_CODE_INTEGRATION.md`](cli/docs/CLAUDE_CODE_INTEGRATION.md) for detailed documentation on:**
- Dual-mode architecture and mode switching
- Message flow and encryption
- Permission system and tool approval
- MCP integration and custom tools
- Session management and resume
- Error handling and cleanup
- Extensibility patterns

### Codex Integration

Codex is integrated via MCP (Model Context Protocol):

#### MCP Client
- **File**: `cli/src/codex/codexMcpClient.ts`
- **How it works**: Connects to Codex via MCP stdio bridge
- **Key files**:
  - `cli/src/codex/codexMcpClient.ts` - MCP client implementation
  - `cli/src/codex/vibeMcpStdioBridge.ts` - Stdio bridge for MCP communication
  - `cli/src/codex/runCodex.ts` - Main Codex session runner

#### Permission Handling
- **File**: `cli/src/codex/utils/permissionHandler.ts`
- Intercepts tool permission requests
- Forwards to mobile app for approval
- Processes approved/denied responses

**📖 See [`cli/docs/CODEX_INTEGRATION.md`](cli/docs/CODEX_INTEGRATION.md) for detailed documentation on:**
- MCP-based architecture
- Event processing and message types
- Reasoning and diff processors
- Permission system (elicitation protocol)
- Session management and resume
- STDIO bridge for Vibe tools
- Error handling and mode changes
- Extensibility patterns

### Message Flow

```
Agent (Claude Code/Codex)
    ↓
CLI Wrapper (runClaude.ts / runCodex.ts)
    ↓
Encryption Layer (encryption.ts)
    ↓
WebSocket (apiSession.ts)
    ↓
Server (socket.ts)
    ↓
Mobile App (sync/apiSocket.ts)
```

### Agent State Management

- **AgentState**: Stores agent-specific state (permissions, tool calls, etc.)
- **Metadata**: Session metadata (path, host, version, etc.)
- **Message Queue**: Handles message ordering and deduplication
- **Files**:
  - `cli/src/api/types.ts` - Type definitions
  - `cli/src/utils/MessageQueue2.ts` - Message queue implementation

---

## Architecture & Data Flow

### System Architecture

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

### Authentication Flow

1. **CLI**: `vibe auth login` generates QR code
2. **Mobile**: Scans QR code or uses web URL
3. **Server**: Validates challenge-response signature
4. **Result**: CLI receives auth token, machine ID created

**Key Files**:
- `cli/src/commands/auth.ts` - Auth command handler
- `cli/src/api/auth.ts` - Authentication logic
- `server/sources/app/auth/auth.ts` - Server auth validation

### Session Creation Flow

1. **CLI**: `vibe claude` or `vibe codex` creates session
2. **Server**: Creates encrypted session record
3. **CLI**: Establishes WebSocket connection
4. **Mobile**: Receives session update via WebSocket
5. **Agent**: Starts processing (local or remote mode)

**Key Files**:
- `cli/src/claude/runClaude.ts` - Claude session creation
- `cli/src/codex/runCodex.ts` - Codex session creation
- `server/sources/app/api/routes/sessions.ts` - Session API

### Real-Time Sync Flow

1. **Agent** produces message (tool call, text, etc.)
2. **CLI** encrypts message and sends via WebSocket
3. **Server** stores encrypted blob and broadcasts to connected clients
4. **Mobile** receives update, decrypts, and updates UI
5. **Mobile** can send commands back (mode switch, permissions, etc.)

**Key Files**:
- `cli/src/api/apiSession.ts` - Session WebSocket client
- `server/sources/app/api/socket/sessionUpdateHandler.ts` - Session sync handler
- `mobile/sources/sync/` - Mobile sync engine

### Encryption

- **Algorithm**: TweetNaCl (NaCl library)
- **Key Management**: Per-session encryption keys
- **Server**: Zero-knowledge (cannot decrypt messages)
- **Files**:
  - `cli/src/api/encryption.ts` - Encryption utilities
  - `mobile/sources/encryption/` - Mobile encryption

---

## Key Files Reference

### CLI Component

#### Core Entry Points
- `cli/src/index.ts` - CLI argument parsing and command routing
- `cli/src/claude/runClaude.ts` - Claude Code session runner
- `cli/src/codex/runCodex.ts` - Codex session runner

#### API & Communication
- `cli/src/api/api.ts` - Main API client
- `cli/src/api/apiSession.ts` - WebSocket session client
- `cli/src/api/apiMachine.ts` - Machine-scoped WebSocket client
- `cli/src/api/auth.ts` - Authentication logic
- `cli/src/api/encryption.ts` - Encryption utilities

#### Agent Integration
- `cli/src/claude/claudeLocal.ts` - Local/interactive Claude Code
- `cli/src/claude/claudeRemote.ts` - Remote Claude Code (SDK)
- `cli/src/claude/loop.ts` - Main control loop
- `cli/src/claude/sdk/query.ts` - Claude Code SDK wrapper
- `cli/src/codex/codexMcpClient.ts` - Codex MCP client
- `cli/src/codex/vibeMcpStdioBridge.ts` - MCP stdio bridge

#### Daemon Service
- `cli/src/daemon/run.ts` - Daemon main loop
- `cli/src/daemon/controlServer.ts` - Daemon HTTP control server
- `cli/src/daemon/controlClient.ts` - Daemon control client

#### Utilities
- `cli/src/utils/MessageQueue2.ts` - Message queue with ordering
- `cli/src/persistence.ts` - Local storage (credentials, settings)
- `cli/src/configuration.ts` - Configuration management

### Server Component

#### Core
- `server/sources/main.ts` - Server entry point
- `server/sources/app/api/api.ts` - API server setup
- `server/sources/app/api/socket.ts` - WebSocket server setup

#### API Routes
- `server/sources/app/api/routes/sessions.ts` - Session management
- `server/sources/app/api/routes/machines.ts` - Machine management
- `server/sources/app/api/routes/auth.ts` - Authentication

#### Socket Handlers
- `server/sources/app/api/socket/sessionUpdateHandler.ts` - Session sync
- `server/sources/app/api/socket/machineUpdateHandler.ts` - Machine updates
- `server/sources/app/api/socket/rpcHandler.ts` - RPC handling

#### Storage
- `server/sources/storage/db.ts` - Prisma database client
- `server/sources/storage/redis.ts` - Redis client

### Mobile Component

#### Core
- `mobile/sources/app/_layout.tsx` - Root navigation
- `mobile/index.ts` - App entry point

#### Sync Engine
- `mobile/sources/sync/apiSocket.ts` - WebSocket client
- `mobile/sources/sync/reducer/reducer.ts` - Message reducer
- `mobile/sources/sync/types.ts` - Sync type definitions

#### Authentication
- `mobile/sources/auth/AuthContext.tsx` - Auth state management
- `mobile/sources/auth/qrScanner.ts` - QR code scanning

#### UI Components
- `mobile/sources/components/` - Reusable components
- `mobile/sources/app/(app)/` - Screen components

---

## Development Guidelines

### Code Style

#### TypeScript
- **Strict typing**: No untyped code
- **Explicit types**: Function parameters and return types
- **Minimal classes**: Prefer functions and modules
- **JSDoc comments**: Comprehensive documentation headers

#### Import Style
- **CLI**: Use `@/` alias for src imports (e.g., `import { logger } from '@/ui/logger'`)
- **Server**: Use `@/` alias for sources imports
- **Mobile**: Use `@/` alias for sources imports

#### File Organization
- **CLI**: Group by feature (api/, claude/, codex/, etc.)
- **Server**: Group by layer (app/, storage/, modules/, utils/)
- **Mobile**: Group by feature (app/, sync/, auth/, components/)

### Error Handling

- **Graceful degradation**: Handle errors without crashing
- **Specific error messages**: Clear, actionable error messages
- **Abort controllers**: Use for cancellable operations
- **Process lifecycle**: Proper cleanup on exit

### Testing

- **CLI**: Vitest, no mocking (real API calls)
- **Server**: Vitest with test files (`.spec.ts`)
- **Mobile**: Vitest (Jest preset), minimal existing tests

### Logging

- **CLI**: File-based logging to avoid interfering with terminal UI
- **Server**: Structured logging with timestamps
- **Mobile**: Console logging (can send to server for debugging)

### Security

- **Encryption**: All sensitive data encrypted before transmission
- **Key storage**: Private keys in `~/.vibe/` with restricted permissions
- **Zero-knowledge**: Server cannot decrypt user data
- **Challenge-response**: Authentication uses cryptographic signatures

### Common Patterns

#### Session Management
```typescript
// Create session
const api = await ApiClient.create(credentials);
const session = await api.getOrCreateSession({ tag, metadata, state });

// Create session client
const sessionClient = new ApiSessionClient(token, session);
await sessionClient.connect();

// Send message
sessionClient.sendClaudeSessionMessage(encryptedMessage);
```

#### Mode Switching
```typescript
// Switch from local to remote
sessionClient.sendSessionEvent({ type: 'switch', mode: 'remote' });

// Switch from remote to local
sessionClient.sendSessionEvent({ type: 'switch', mode: 'local' });
```

#### Permission Handling
```typescript
// Request permission
const permission = await requestPermission(toolName, args);

// Handle response
if (permission.approved) {
    // Execute tool
} else {
    // Handle denial
}
```

---

## Common Patterns

### 1. Message Queue Pattern

Used for ordering and deduplicating messages:

```typescript
const queue = new MessageQueue2();
queue.add(message, priority);
const next = await queue.next();
```

**Files**:
- `cli/src/utils/MessageQueue2.ts`

### 2. RPC Pattern

Remote procedure calls between CLI and mobile:

```typescript
// Register handler
rpcHandlerManager.register('method-name', async (params) => {
    return result;
});

// Call from mobile
const result = await rpcClient.call('method-name', params);
```

**Files**:
- `cli/src/api/rpc/rpcHandlerManager.ts`
- `server/sources/app/api/socket/rpcHandler.ts`

### 3. Encryption Pattern

Encrypt before sending, decrypt after receiving:

```typescript
// Encrypt
const encrypted = encrypt(key, variant, data);
const encoded = encodeBase64(encrypted);

// Decrypt
const decoded = decodeBase64(encoded);
const decrypted = decrypt(key, variant, decoded);
```

**Files**:
- `cli/src/api/encryption.ts`
- `mobile/sources/encryption/`

### 4. WebSocket Event Pattern

Emit events, listen for updates:

```typescript
// Emit
socket.emit('message', { sid: sessionId, message: encrypted });

// Listen
socket.on('update', (data) => {
    // Handle update
});
```

**Files**:
- `cli/src/api/apiSession.ts`
- `server/sources/app/api/socket.ts`

### 5. State Synchronization Pattern

Optimistic updates with version control:

```typescript
// Update with version
await updateState((current) => ({
    ...current,
    version: current.version + 1,
    data: newData
}));
```

**Files**:
- `cli/src/api/apiSession.ts`
- `server/sources/app/api/routes/sessions.ts`

---

## Quick Reference

### Starting Development

1. **Infrastructure**: `docker-compose up -d`
2. **Server**: `cd server && yarn dev`
3. **Mobile**: `cd mobile && yarn start:local-server`
4. **CLI**: `cd cli && yarn build && npm link`

### Common Commands

```bash
# CLI
vibe auth login          # Authenticate
vibe claude              # Start Claude Code
vibe codex               # Start Codex
vibe daemon start        # Start background service
vibe doctor              # Diagnostics

# Server
yarn dev                 # Start server
yarn migrate             # Run migrations
yarn test                # Run tests

# Mobile
yarn start:local-server  # Start with local server
yarn typecheck           # Type check
```

### Environment Variables

**CLI**:
- `VIBE_SERVER_URL` - Server URL (default: `http://localhost:3005`)
- `VIBE_HOME_DIR` - Home directory (default: `~/.vibe`)

**Server**:
- `DATABASE_URL` - PostgreSQL connection string
- `REDIS_URL` - Redis connection string
- `VIBE_MASTER_SECRET` - Master encryption key (required)

**Mobile**:
- `EXPO_PUBLIC_VIBE_SERVER_URL` - Server URL

---

## Additional Resources

- **Quick Start**: See [`QUICK_START.md`](QUICK_START.md) for setup instructions
- **CLI Guide**: See [`cli/CLAUDE.md`](cli/CLAUDE.md) for CLI-specific guidelines
- **Server Guide**: See [`server/CLAUDE.md`](server/CLAUDE.md) for server-specific guidelines
- **Mobile Guide**: See [`mobile/CLAUDE.md`](mobile/CLAUDE.md) for mobile-specific guidelines
- **Agent Integration Docs**: 
  - [`cli/docs/CLAUDE_CODE_INTEGRATION.md`](cli/docs/CLAUDE_CODE_INTEGRATION.md) - Complete Claude Code integration guide
  - [`cli/docs/CODEX_INTEGRATION.md`](cli/docs/CODEX_INTEGRATION.md) - Complete Codex integration guide
- **Main README**: See [`README.md`](README.md) for project overview

---

## Notes for AI Agents

When working on this codebase:

1. **Read component-specific CLAUDE.md files** first for detailed guidelines
2. **Check agent integration docs** - Before modifying agent code, review:
   - [`cli/docs/CLAUDE_CODE_INTEGRATION.md`](cli/docs/CLAUDE_CODE_INTEGRATION.md) for Claude Code changes
   - [`cli/docs/CODEX_INTEGRATION.md`](cli/docs/CODEX_INTEGRATION.md) for Codex changes
3. **Understand the encryption model** - server cannot decrypt data
4. **Respect the zero-knowledge architecture** - don't add server-side decryption
5. **Follow existing patterns** - message queue, RPC, WebSocket events
6. **Test across components** - changes may affect CLI, server, and mobile
7. **Check type safety** - run `yarn typecheck` after changes
8. **Consider real-time sync** - changes to session state affect all connected clients
9. **Handle errors gracefully** - don't crash the agent session
10. **Use proper logging** - file-based for CLI, structured for server
11. **Maintain backward compatibility** - unless explicitly breaking changes

### When to Check Integration Documentation

Check the agent integration documentation when:
- **Modifying agent integration code** (`cli/src/claude/` or `cli/src/codex/`)
- **Adding new message types** or event handlers
- **Changing permission systems** or tool approval flows
- **Modifying session management** or resume logic
- **Adding new MCP tools** or servers
- **Implementing mode switching** or state transitions
- **Adding new agents** or integration methods
- **Debugging message flow** or encryption issues

---

*Last updated: 2025-01-27*

