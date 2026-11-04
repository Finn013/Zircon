<p align="center"><img src="assets/icon.png" width="128" alt="Zircon"></p>
<h1 align="center">Zircon</h1>
<p align="center">
  Зашифрованный редактор таблиц и расписаний с уровнями доступа и синхронизацией через GitHub.<br>
  Encrypted table and schedule editor with access levels and GitHub sync.
</p>
<p align="center">
  <a href="https://github.com/Finn013/Zircon/releases/latest">Скачать / Download</a> ·
  <a href="https://finn013.github.io/Zircon/">Открыть онлайн / Open online</a>
</p>

---

## 🇷🇺 О приложении
Один HTML-файл без сервера: таблицы хранятся в зашифрованном JSON в вашем GitHub-репозитории, а каждый видит ровно то, что ему положено по уровню доступа.

### Возможности
- **4 уровня доступа** со своими паролями: уровень 1 — администратор, 2 — редактор, 3–4 — просмотр. Меньше число — больше доступа.
- **Шифрование AES-256-GCM**, ключи защищены паролями через PBKDF2-SHA256. Данные каждого уровня шифруются своим ключом.
- **Таблицы**: вкладки, группы, строки и столбцы, множественный выбор ячеек, копирование и вставка, форматирование, цвета, ссылки, отмена и повтор.
- **Вкладка «Файлы»**: зашифрованные вложения.
- **Синхронизация через GitHub**: разрешение конфликтов, когда данные изменил кто-то другой, и история версий с откатом.
- **Журнал входов** и автовыход при бездействии.
- **Резервная копия** в формате `.hvx` — открывается и в Hypervault.
- Цвет интерфейса зависит от уровня доступа.

### Подключение
Администратор создаёт приватный репозиторий и токен GitHub с правом Contents, затем раздаёт строку вида
`владелец/репозиторий;файл.json;токен` (4-е поле — ветка, необязательно). Её вводят в «⚙️ Настройки подключения». Строка хранится только на устройстве.

> Забытый пароль восстановить нельзя. Прежние версии файла остаются в истории GitHub и доступны тем, кто знал старые пароли.

### Скачать
| Платформа | Файл |
|---|---|
| Любое устройство с браузером | `Zircon.html` |
| Android 7+ | `Zircon.apk` |
| Windows 10/11 | `Zircon-Setup.exe` (установщик) или `Zircon-Portable.exe` (без установки) |
| iPhone, iPad, Mac | [finn013.github.io/Zircon](https://finn013.github.io/Zircon/) |

Windows-сборки не подписаны: если SmartScreen предупредит, нажмите «Подробнее» → «Выполнить в любом случае».

---

## 🇬🇧 About
A single HTML file, no server: tables live in an encrypted JSON file in your GitHub repository, and everyone sees exactly what their access level allows.

### Features
- **4 access levels** with separate passwords: level 1 is admin, 2 is editor, 3–4 are view-only. Lower number, more access.
- **AES-256-GCM encryption**, keys protected by passwords via PBKDF2-SHA256. Each level's data uses its own key.
- **Tables**: tabs, groups, rows and columns, multi-cell selection, copy and paste, formatting, colors, links, undo and redo.
- **Files tab**: encrypted attachments.
- **GitHub sync**: conflict resolution when someone else changed the data, and version history with rollback.
- **Sign-in log** and auto-logout when idle.
- **Backup** in `.hvx` format, which also opens in Hypervault.
- Interface color follows the access level.

### Setup
The admin creates a private repository and a GitHub token with Contents access, then shares a line like
`owner/repo;file.json;token` (optional 4th field: branch). Paste it into “⚙️ Connection settings”. It is stored only on the device.

> A forgotten password cannot be recovered. Older versions of the file stay in GitHub history and remain readable by anyone who knew the old passwords.

### Download
| Platform | File |
|---|---|
| Any device with a browser | `Zircon.html` |
| Android 7+ | `Zircon.apk` |
| Windows 10/11 | `Zircon-Setup.exe` (installer) or `Zircon-Portable.exe` (no install) |
| iPhone, iPad, Mac | [finn013.github.io/Zircon](https://finn013.github.io/Zircon/) |

Windows builds are unsigned: if SmartScreen warns, click “More info” → “Run anyway”.
