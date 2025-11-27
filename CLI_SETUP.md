# CLI Setup for Vibe-on-the-Go

## Quick Start

The CLI tool is now part of this repository! Build and install it:

### 1. Build and Install the CLI

```bash
cd cli
yarn install
yarn build
npm link
```

The CLI defaults to `http://localhost:3005` for local development, so no environment variables needed!

### 2. Authenticate

First, you need to authenticate the CLI with your mobile app account:

```bash
vibe auth login
```

This will:
1. Generate a QR code in your terminal
2. Open the mobile app and go to Settings → Account → Link New Device
3. Scan the QR code with your phone
4. The CLI will be authenticated

### 3. Start a Session

Once authenticated, start a Claude Code session:

```bash
vibe claude
```

Or with options:

```bash
vibe claude --resume
```

### 4. View in Mobile App

After starting a session, you should see your machine appear in the mobile app under "Machines" or in the main session list.

## Troubleshooting

### If the CLI can't connect to the server:

1. Make sure the server is running: `cd server && yarn dev`
2. The CLI defaults to `http://localhost:3005` - you can override with `VIBE_SERVER_URL`:
   ```bash
   export VIBE_SERVER_URL=http://localhost:3005
   ```
3. Try using your PC's IP address instead of localhost if connecting from a different device:
   ```bash
   # Find your IP (Windows)
   ipconfig
   
   # Then use: http://YOUR_IP:3005
   export VIBE_SERVER_URL=http://YOUR_IP:3005
   ```

### If authentication fails:

1. Make sure you're logged into the mobile app
2. Make sure the server URL in the mobile app matches your CLI server URL
3. Try `vibe auth login --force` to force re-authentication

## Configuration

The CLI uses these environment variables (all optional, defaults work for local dev):
- `VIBE_SERVER_URL` - Server URL (default: `http://localhost:3005`)
- `VIBE_HOME_DIR` - Home directory for CLI data (default: `~/.vibe`)
- `VIBE_EXPERIMENTAL` - Enable experimental features
- `VIBE_DISABLE_CAFFEINATE` - Disable caffeinate on macOS

