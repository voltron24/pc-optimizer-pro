# PC Optimizer Pro

**Professional Windows 10 / 11 optimization suite** — junk cleaning, startup & process control, services, registry tweaks, power plans, network tools, gaming mode, memory optimization, privacy, security checks, SFC/DISM repair, and System Restore points.

![Platform](https://img.shields.io/badge/platform-Windows%2010%2F11%20x64-blue)
![Version](https://img.shields.io/badge/version-1.1.0-green)
![License](https://img.shields.io/badge/license-MIT-lightgrey)

---

## Features

| Module | Description |
|--------|-------------|
| **Dashboard** | Live CPU / RAM / disk / GPU metrics & health score |
| **One-Click Optimize** | Restore point → clean safe junk → memory → DNS flush |
| **Junk Cleaner** | Real filesystem scan + **safe clean** (strict whitelist) |
| **Startup Manager** | Registry + Startup folder (enable / disable) |
| **Process Manager** | Live process list + terminate (system processes protected) |
| **Service Optimizer** | Configure service startup type (critical services locked) |
| **Windows Tweaks** | Real registry apply / revert |
| **Power Optimizer** | Switch plans via `powercfg` |
| **Network** | Adapter info, flush DNS, renew IP, winsock reset |
| **Gaming Mode** | Ultimate Performance + Game Mode |
| **Memory Optimizer** | Working-set pressure relief |
| **Privacy / Security** | Telemetry tweaks, Defender, Firewall, Secure Boot, UAC |
| **System Repair** | Real `SFC` / `DISM` (admin required) |
| **Restore Points** | Create / list Windows System Restore points |

---

## Download (end users)

If a [**Release**](../../releases) is published, download:

| File | Use case |
|------|----------|
| **PCOptimizerPro-Setup-1.1.0.exe** | Full installer (shortcuts, uninstall) |
| **PCOptimizerPro-Portable.exe** | Single-file portable, no install |

> Right-click → **Run as administrator** for full features (clean, services, repair, restore).

---

## Development setup

### Requirements

- Windows 10 (1809+) or Windows 11, 64-bit  
- [Node.js 18+ LTS](https://nodejs.org)

### Run from source

```bash
git clone https://github.com/voltron24/pc-optimizer-pro.git
cd pc-optimizer-pro
npm install
npm run dev
```

Open **http://localhost:3000**

Or use the batch files:

```text
install.bat        → npm install (once)
start-admin.bat    → run with UAC elevation (recommended)
start.bat          → run without elevation
```

### Build Windows EXE (installer + portable)

On **Windows**:

```bash
npm install
npm run build
set CSC_IDENTITY_AUTO_DISCOVERY=false
npx electron-builder --win portable nsis --x64 --config.win.signAndEditExecutable=false
```

Or double-click **`build-exe.bat`**.

Output in `release/`:

- `PCOptimizerPro-Portable.exe`
- `PCOptimizerPro-Setup-1.1.0.exe`

If packaging stops at `win-unpacked` only, run **`LANJUTKAN-PACK.bat`**.

---

## Safety

- Cleaner only deletes **SAFE** categories (temp, cache, recycle bin, etc.).
- **Never** targets System32, WinSxS, Program Files, Documents, Desktop, Downloads.
- Critical Windows services and system processes cannot be modified/killed.
- Confirmation dialogs for destructive actions; optional restore-point prompt.

Use at your own risk. Create a restore point before bulk changes.

---

## Project structure

```text
├── electron/          Electron main process (desktop shell)
├── server/            Windows ops, scanners, managers
├── src/               React UI
├── installer/         Inno Setup script (optional)
├── server.ts          Express API + static hosting
├── build-exe.bat      Build portable + NSIS installer
├── install.bat        Install Node dependencies
└── start-admin.bat    Launch elevated (dev mode)
```

---

## Scripts

| Command | Description |
|---------|-------------|
| `npm run dev` | Dev server (Express + Vite) |
| `npm run build` | Production frontend + `dist/server.cjs` |
| `npm run dist:win` | Build Windows portable + setup |
| `npm run dist:portable` | Portable `.exe` only |
| `npm run dist:setup` | NSIS installer only |

---

## Tech stack

- **UI:** React 19, Vite, Tailwind CSS, Lucide  
- **Backend:** Express, TypeScript, PowerShell / WMI  
- **Desktop:** Electron + electron-builder (portable + NSIS)

---

## License

[MIT](./LICENSE)

---

## Disclaimer

This software modifies system settings and may delete temporary files. The authors are not responsible for data loss or system issues. Always back up important data and create a System Restore point before major optimizations.
