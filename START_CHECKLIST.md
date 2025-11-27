# Vibe-on-the-Go - Startup Checklist

Quick reference checklist for starting the entire application.

## ✅ Pre-Flight Check

- [ ] Docker Desktop is running
- [ ] Node.js 20+ installed
- [ ] Yarn installed
- [ ] Claude Code installed (for CLI testing)

---

## 🚀 Startup Sequence

### Terminal 1: Infrastructure
```bash
cd vibe-on-the-go
docker-compose up -d
```
- [ ] Docker containers started (postgres, redis, minio)
- [ ] Verify: `docker ps` shows 3 containers

### Terminal 2: Server
```bash
cd server
cp .env.example .env
# Edit .env and set VIBE_MASTER_SECRET (generate with: openssl rand -hex 32)
yarn install
yarn migrate
yarn dev
```
- [ ] Server running on `http://localhost:3005`
- [ ] No errors in server logs

### Terminal 3: Mobile App
```bash
cd mobile
yarn install
yarn start:local-server
# Press 'w' for web browser
```
- [ ] Expo dev server started
- [ ] App opens in browser/emulator
- [ ] Account created in mobile app
- [ ] Can see main interface

### Terminal 4: CLI
```bash
cd cli
yarn install
yarn build
npm link
vibe auth login
# Scan QR code with mobile app
vibe claude
```
- [ ] CLI built successfully
- [ ] `vibe` command works (`vibe --help`)
- [ ] Authentication successful (QR code scanned)
- [ ] Claude session started

---

## ✅ Verification Checklist

### Server Health
- [ ] `curl http://localhost:3005/health` returns OK
- [ ] Server logs show no errors

### Mobile App
- [ ] Can log in/create account
- [ ] Settings → Server shows correct URL
- [ ] No connection errors

### CLI
- [ ] `vibe doctor` shows all green
- [ ] Authentication successful
- [ ] Can start Claude session

### Integration
- [ ] Machine appears in mobile app after `vibe claude`
- [ ] Sessions visible in mobile app
- [ ] Real-time updates working

---

## 🔧 Troubleshooting Quick Fixes

| Issue | Quick Fix |
|-------|-----------|
| Server won't start | Check Docker, check port 3005 free |
| Mobile can't connect | Verify server URL, check firewall |
| CLI auth fails | Ensure mobile app logged in, try `--force` |
| Machine not appearing | Verify session running, check server logs |
| Port already in use | Kill process: `npx kill-port 3005` |

---

## 🛑 Shutdown Sequence

1. [ ] Stop CLI: `Ctrl+C` in Terminal 4
2. [ ] Stop Mobile: `Ctrl+C` in Terminal 3, press `y`
3. [ ] Stop Server: `Ctrl+C` in Terminal 2
4. [ ] Stop Infrastructure: `docker-compose down` in Terminal 1

---

## 📚 Full Documentation

- **Complete Guide:** [QUICK_START.md](QUICK_START.md)
- **CLI Setup:** [CLI_SETUP.md](CLI_SETUP.md)
- **Main README:** [README.md](README.md)

---

**Status:** ⬜ Not Started | 🟡 In Progress | ✅ Complete






