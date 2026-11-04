const { app, BrowserWindow, shell, Menu } = require('electron');
const path = require('path');
// Portable: keep data next to the exe
if (process.env.PORTABLE_EXECUTABLE_DIR) {
  app.setPath('userData', path.join(process.env.PORTABLE_EXECUTABLE_DIR, 'ZirconData'));
}
if (!app.requestSingleInstanceLock()) { app.quit(); }
let win;
function create() {
  win = new BrowserWindow({
    width: 1200, height: 860, minWidth: 360, minHeight: 500,
    title: 'Zircon', icon: path.join(__dirname, 'icon.png'),
    autoHideMenuBar: true,
    webPreferences: { contextIsolation: true, nodeIntegration: false, spellcheck: false }
  });
  Menu.setApplicationMenu(null);
  win.loadFile(path.join(__dirname, 'index.html'));
  win.webContents.setWindowOpenHandler(({ url }) => {
    if (/^https?:/.test(url)) shell.openExternal(url);
    return { action: 'deny' };
  });
  win.webContents.on('will-navigate', (e, url) => {
    if (/^https?:/.test(url)) { e.preventDefault(); shell.openExternal(url); }
  });
  win.webContents.session.setPermissionRequestHandler((wc, perm, cb) => cb(['clipboard-read','clipboard-sanitized-write','notifications'].includes(perm)));
}
app.on('second-instance', () => { if (win) { if (win.isMinimized()) win.restore(); win.focus(); } });
app.whenReady().then(create);
app.on('window-all-closed', () => app.quit());
