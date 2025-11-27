# Vibe-on-the-Go - Quick Start Guide

Complete step-by-step guide to get the entire application running and test the full flow.

## Prerequisites

- Node.js 20+ and npm/yarn installed
- Docker and Docker Compose installed and running
- Claude Code installed on your computer (for CLI testing)
- Git Bash or terminal (for Windows)

## Step 0: Clone All Repositories

First, clone all component repositories:

```bash
git clone https://github.com/SGranquist13/vibe-on-the-go.git
git clone https://github.com/SGranquist13/vibe-cli.git
git clone https://github.com/SGranquist13/vibe-mobile.git
git clone https://github.com/SGranquist13/vibe-server.git
```

## Step 1: Start Infrastructure Services

Open a terminal and start PostgreSQL, Redis, and MinIO:

```bash
cd vibe-on-the-go
docker-compose up -d
```

**Verify it's running:**
```bash
docker ps
```

You should see 3 containers: `vibe-postgres`, `vibe-redis`, and `vibe-minio`

**Expected output:** Services running on:
- PostgreSQL: `localhost:5432`
- Redis: `localhost:6379`
- MinIO: `localhost:9000` (API) and `localhost:9001` (Console)

---

## Step 2: Set Up and Start the Server

### 2.1 Configure Server Environment

```bash
cd vibe-server
cp .env.example .env
```

### 2.2 Generate Master Secret

**Windows (Git Bash):**
```bash
openssl rand -hex 32
```

**Windows (PowerShell):**
```powershell
[Convert]::ToBase64String((1..32 | ForEach-Object { Get-Random -Minimum 0 -Maximum 256 }))
```

**macOS/Linux:**
```bash
openssl rand -hex 32
```

Copy the output and edit `server/.env`, set:
```
VIBE_MASTER_SECRET=your-generated-secret-here
```

### 2.3 Install Dependencies and Migrate Database

```bash
cd vibe-server
yarn install
yarn migrate
```

### 2.4 Start the Server

```bash
yarn dev
```

**Expected output:** Server running at `http://localhost:3005`

**Keep this terminal open!** The server needs to stay running.

---

## Step 3: Set Up and Start the Mobile App

Open a **new terminal** (keep the server running):

### 3.1 Install Dependencies

```bash
cd vibe-mobile
yarn install
```

### 3.2 Start the Mobile App

```bash
yarn start:local-server
```

**Expected output:** Expo dev server starts, shows QR code and options

### 3.3 Open the App

**Option A: Web Browser (Easiest for testing)**
- Press `w` in the terminal
- Browser opens to `http://localhost:8081`

**Option B: iOS Simulator (macOS only)**
- Press `i` in the terminal

**Option C: Android Emulator**
- Press `a` in the terminal

**Option D: Physical Device**
- Scan the QR code with Expo Go app
- Make sure phone and computer are on same Wi-Fi
- If connection fails, find your PC's IP: `ipconfig` (Windows) or `ifconfig` (macOS/Linux)
- Set `EXPO_PUBLIC_VIBE_SERVER_URL=http://YOUR_IP:3005` before starting

### 3.4 Create Account in Mobile App

1. When the app opens, you'll see a welcome screen
2. Click **"Create Account"** (not "Login with Mobile App")
3. Wait for account creation to complete
4. You should now see the main app interface

**Important:** You must be logged in to the mobile app before you can authenticate the CLI. If you see an error about "credentials is null", make sure you've completed account creation.

**Keep this terminal open!** The mobile app dev server needs to stay running.

---

## Step 4: Build and Set Up the CLI

Open a **new terminal** (keep server and mobile running):

### 4.1 Build the CLI

```bash
cd vibe-cli
yarn install
yarn build
```

### 4.2 Install CLI Globally

```bash
npm link
```

This makes the `vibe` command available globally.

**Verify installation:**
```bash
vibe --help
```

You should see the help menu.

---

## Step 5: Authenticate CLI with Mobile App

### 5.1 Start Authentication

In the same terminal:

```bash
vibe auth login
```

**Expected output:** A QR code appears in your terminal

### 5.2 Authenticate with Mobile App

**If using mobile app in web browser (`http://localhost:8081`) - RECOMMENDED FOR WEB:**

The CLI will display a QR code and authentication URLs. Since you're using a web browser, follow these steps:

1. **Look for the web URL in the terminal output:**
   - After the QR code, you'll see a section labeled `📱 For web browser users:`
   - It will show a URL like: `http://localhost:8081/terminal/connect#key=ABC123XYZ...`
   - The URL may be automatically copied to your clipboard (you'll see `✓ URL copied to clipboard`)

2. **Open the URL in your browser:**
   - If the URL was copied to clipboard, paste it into your browser's address bar
   - If not, copy the entire URL from the terminal
   - Make sure you're pasting it into the same browser window where the mobile app is running (`http://localhost:8081`)

3. **Complete authentication:**
   - The mobile app will automatically detect the key in the URL
   - You'll see a connection prompt with details about the terminal
   - Click **"Accept Connection"** or **"Connect"** button
   - The terminal will show "Authentication successful" when complete

**Expected output in terminal:** 
```
Waiting for authentication...
✓ Authentication successful
```

**If the URL doesn't work:**
- Make sure the mobile app is running in your browser at `http://localhost:8081`
- Verify you copied the entire URL including `http://localhost:8081/terminal/connect#key=`
- Try refreshing the mobile app page before pasting the URL

---

**Alternative Methods:**

**Method 2: Use a Physical Device**
1. Install Expo Go app on your phone
2. In the mobile app terminal, scan the Expo QR code to open the app on your phone
3. On your phone, go to **Settings** → **Account** → **"Link New Device"**
4. Scan the CLI QR code from your terminal with your phone's camera
5. The authentication will complete automatically

**Method 3: Use QR Code Scanner Website**
1. Use an online QR code scanner website (like qrcode-monkey.com/reader or webqr.com)
2. Take a screenshot of the terminal QR code
3. Upload the screenshot to decode the URL
4. Extract the key from `vibe://terminal?KEY` (everything after the `?`)
5. Navigate to `http://localhost:8081/terminal/connect#key=KEY` in your browser

**If using physical device or emulator (not web browser):**
1. Go to **Settings** → **Account**
2. Tap **"Link New Device"** or **"Scan QR Code to Authenticate"**
3. Scan the QR code from your terminal
4. Wait for "Device Linked Successfully" message

---

## Step 6: Start a Claude Code Session

### 6.1 Start a Session

**Important:** You must start a session to register your machine with the server. The machine won't appear in the mobile app until you run this command.

In the same terminal:

```bash
vibe claude
```

Or with resume option:

```bash
vibe claude --resume
```

**Expected output:** 
- CLI connects to the server
- Machine is registered with the server (this happens automatically)
- Session starts
- You can interact with Claude Code normally

**Note:** The first time you run `vibe claude`, it will register your machine with the server. This may take a few seconds. After that, your machine will appear in the mobile app.

### 6.2 Verify in Mobile App

1. Go back to the mobile app
2. Wait a few seconds for the machine to sync (you may need to refresh or wait for the app to fetch machines)
3. You should now see:
   - Your machine listed under "Machines" (in Settings) or available when creating a new session
   - Active sessions showing up
   - Real-time updates from Claude Code

**If your machine doesn't appear:**
- Make sure `vibe claude` is still running (the machine goes offline when you exit)
- Check that the server is running: `curl http://localhost:3005/health`
- Try refreshing the mobile app or waiting a few more seconds
- Check the browser console (F12) for any errors

**Success!** The full flow is working! 🎉

---

## Testing the Full Flow

### Test 1: Basic Connection
- ✅ Server running
- ✅ Mobile app connected to server
- ✅ CLI authenticated
- ✅ Machine appears in mobile app

### Test 2: Session Creation
- ✅ Start `vibe claude` session
- ✅ Session appears in mobile app
- ✅ Can see Claude's responses in real-time

### Test 3: Multi-Device (Optional)
- Start another terminal
- Run `vibe claude` again
- Both sessions should appear in mobile app

### Test 4: Remote Control (Optional)
- In mobile app, tap on an active session
- You should be able to see the conversation
- Try sending a message or command from mobile

---

## Troubleshooting

### Server won't start
- Check Docker is running: `docker ps`
- Check port 3005 is free: `netstat -ano | findstr :3005` (Windows)
- Check database connection in server logs

### Mobile app can't connect
- Verify server is running: `curl http://localhost:3005/health`
- Check server URL in mobile app settings
- For physical devices, use PC's IP instead of localhost

### CLI authentication fails
- Make sure mobile app is logged in
- Verify server URL matches: CLI uses `http://localhost:3005` by default
- Try `vibe auth login --force`
- **If using web browser:**
  - Make sure you copied the entire web URL (starts with `http://localhost:8081/terminal/connect#key=`)
  - Verify the mobile app is running at `http://localhost:8081` in your browser
  - Try refreshing the mobile app page before pasting the URL
  - Check that the URL hash (`#key=...`) is present - some browsers strip it when pasting
  - If the URL was copied to clipboard automatically, try pasting it directly into the address bar

### "Failed to connect terminal" error
If you see this error after clicking "Accept Connection":
1. **Check you're logged in:** Make sure you've created an account and are logged in to the mobile app
   - If you see "can't access property 'secret', auth.credentials is null", you need to create an account first
   - Go back to the welcome screen and click "Create Account"
2. **Check server is running:** Make sure the server is running at `http://localhost:3005`
   - Verify with: `curl http://localhost:3005/health`
3. **Timing issue:** The CLI might not have created the auth request yet
   - Wait a few seconds after running `vibe auth login` before clicking the URL
   - Make sure the terminal shows "Waiting for authentication..." before you click
4. **Server connectivity:** Check browser console (F12) for network errors
   - Look for CORS errors or connection refused errors
   - Verify the mobile app can reach `http://localhost:3005`
5. **Try again:** Close the connection prompt and try the URL again
   - The auth request might have expired - run `vibe auth login` again to get a new URL

### Machine doesn't appear in mobile app
- **Most common issue:** You need to run `vibe claude` to register the machine with the server
  - Authentication (`vibe auth login`) only creates a machine ID locally
  - The machine is only registered with the server when you start a session
  - Run `vibe claude` and wait a few seconds for the machine to appear
- Verify CLI is authenticated: `vibe doctor`
- Make sure a session is running: `vibe claude` (the machine goes offline when you exit)
- Check server logs for connection errors
- Try refreshing the mobile app or waiting a few seconds for sync
- Check browser console (F12) for any network errors
- Restart both CLI and mobile app

### CLI can't connect to server
- Verify server is running: `curl http://localhost:3005/health`
- Check `VIBE_SERVER_URL` environment variable
- Default should be `http://localhost:3005`

### "Request failed with status code 500" error
If you see a 500 error when running `vibe claude`:

**Common Error: "Foreign key constraint violated on Machine_accountId_fkey"**
This means the account associated with your authentication token doesn't exist in the database. This can happen if:
- The database was reset or cleared
- The account was deleted
- There's a mismatch between authentication and database state

**Fix:**
1. **Re-authenticate the CLI:**
   ```bash
   vibe auth login --force
   ```
   This will clear old credentials and create a fresh authentication

2. **If that doesn't work, check server logs** for the exact error:
   - Look at the terminal where the server is running (`yarn dev` in the server directory)
   - The logs will show the actual error that caused the 500

3. **Check database connection:**
   - Make sure PostgreSQL is running: `docker ps` (should show `vibe-postgres`)
   - Verify database is accessible

4. **Run database migrations:**
   ```bash
   cd server
   yarn migrate
   ```

5. **Check for missing environment variables:**
   - Make sure `VIBE_MASTER_SECRET` is set in `server/.env`
   - Verify all required environment variables are present

6. **Restart the server:**
   - Stop the server (Ctrl+C)
   - Restart it: `yarn dev`
   - Try `vibe claude` again

---

## Stopping Everything

When done testing:

1. **Stop CLI:** Press `Ctrl+C` in CLI terminal
2. **Stop Mobile App:** Press `Ctrl+C` in mobile terminal, then `y` to stop
3. **Stop Server:** Press `Ctrl+C` in server terminal
4. **Stop Infrastructure:** 
   ```bash
   docker-compose down
   ```

---

## Quick Reference

### Terminal 1: Infrastructure
```bash
docker-compose up -d
```

### Terminal 2: Server
```bash
cd vibe-server
yarn dev
```

### Terminal 3: Mobile App
```bash
cd vibe-mobile
yarn start:local-server
# Press 'w' for web, 'i' for iOS, 'a' for Android
```

### Terminal 4: CLI
```bash
cd vibe-cli
yarn build && npm link
vibe auth login
vibe claude
```

---

## Next Steps

Once everything is working:

1. **Customize branding:** Update logos, colors, and text
2. **Configure production:** Set up proper domain and SSL
3. **Deploy server:** Deploy to your own infrastructure
4. **Build mobile apps:** Create iOS/Android builds
5. **Publish CLI:** Publish `vibe-cli` to npm (optional)

---

## Architecture Overview

```
┌─────────────┐
│   Mobile    │ (React Native - iOS/Android/Web)
│     App     │
└──────┬──────┘
       │
       │ WebSocket + HTTP
       │
┌──────▼──────┐
│   Server    │ (Node.js + Fastify)
│  (Port 3005)│
└──────┬──────┘
       │
       │ WebSocket + HTTP
       │
┌──────▼──────┐
│     CLI     │ (Node.js - Terminal)
│  (vibe cmd) │
└─────────────┘
```

All communication is **end-to-end encrypted**. The server only sees encrypted blobs.

---

## Support

If you encounter issues:

1. Check all services are running
2. Verify ports are not blocked by firewall
3. Check server logs for errors
4. Run `vibe doctor` for CLI diagnostics
5. Check mobile app console for errors (in browser DevTools)

Vibe-on-the-Go coding! 🚀

