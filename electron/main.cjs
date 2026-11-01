/**
 * PC Optimizer Pro — Electron main process
 */
const { app, BrowserWindow, shell, dialog } = require('electron');
const path = require('path');
const http = require('http');

const PORT = Number(process.env.PORT || 3911);
let mainWindow = null;

function appRoot() {
  if (!app.isPackaged) {
    return path.join(__dirname, '..');
  }
  return app.getAppPath();
}

function waitForServer(url, attempts = 50) {
  return new Promise((resolve, reject) => {
    let left = attempts;
    const tryOnce = () => {
      const req = http.get(url, (res) => {
        res.resume();
        resolve();
      });
      req.on('error', () => {
        left -= 1;
        if (left <= 0) reject(new Error('Server tidak siap (timeout)'));
        else setTimeout(tryOnce, 200);
      });
    };
    tryOnce();
  });
}

async function startBackend() {
  process.env.NODE_ENV = 'production';
  process.env.ELECTRON_RUN = '1';
  process.env.PORT = String(PORT);
  process.env.HOST = '127.0.0.1';
  process.env.DIST_PATH = path.join(appRoot(), 'dist');

  try {
    process.chdir(appRoot());
  } catch (_) {}

  const serverPath = path.join(appRoot(), 'dist', 'server.cjs');
  let mod;
  try {
    mod = require(serverPath);
  } catch (err) {
    console.error('Load server failed:', serverPath, err);
    dialog.showErrorBox(
      'PC Optimizer Pro',
      'File server tidak ditemukan.\nJalankan build dulu: npm run build\n\n' + (err && err.message ? err.message : String(err))
    );
    app.quit();
    return;
  }

  if (typeof mod.startServer === 'function') {
    await mod.startServer();
  }

  await waitForServer(`http://127.0.0.1:${PORT}/`);
}

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1280,
    height: 820,
    minWidth: 960,
    minHeight: 640,
    title: 'PC Optimizer Pro',
    backgroundColor: '#020617',
    autoHideMenuBar: true,
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true,
      sandbox: true,
    },
    show: false,
  });

  mainWindow.once('ready-to-show', () => mainWindow.show());
  mainWindow.loadURL(`http://127.0.0.1:${PORT}`);

  mainWindow.webContents.setWindowOpenHandler(({ url }) => {
    shell.openExternal(url);
    return { action: 'deny' };
  });

  mainWindow.on('closed', () => {
    mainWindow = null;
  });
}

const gotLock = app.requestSingleInstanceLock();
if (!gotLock) {
  app.quit();
} else {
  app.on('second-instance', () => {
    if (mainWindow) {
      if (mainWindow.isMinimized()) mainWindow.restore();
      mainWindow.focus();
    }
  });

  app.whenReady().then(async () => {
    try {
      await startBackend();
      createWindow();
    } catch (err) {
      console.error(err);
      dialog.showErrorBox(
        'PC Optimizer Pro',
        'Gagal menjalankan aplikasi:\n' + (err && err.message ? err.message : String(err))
      );
      app.quit();
    }
  });
}

app.on('window-all-closed', () => app.quit());

app.on('before-quit', () => {
  try {
    const s = global.__pcOptimizerServer;
    if (s && typeof s.close === 'function') s.close();
  } catch (_) {}
});
