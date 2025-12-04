# 🚀 Quick Reference Card

## Installation

```powershell
git clone https://github.com/T4snimul/.dotfiles-windows.git
cd .dotfiles-windows
.\init.ps1
```

## Main Menu (Startup)

Run `.\init.ps1` to see:

```
[D] Configure Dotfiles (symlink settings)
[S] Install Software (via winget)
[G] Push to GitHub
[O] Open Repository Folder
[Q] Quit
```

## Features at a Glance

| Feature             | Access | Purpose                            |
| ------------------- | ------ | ---------------------------------- |
| Configure Dotfiles  | `[D]`  | Sync VS Code, PowerShell, Terminal |
| Install Software    | `[S]`  | Install 20+ apps via winget        |
| Push to GitHub      | `[G]`  | Auto-commit changes to repo        |
| Open Repository     | `[O]`  | Open dotfiles folder in explorer   |
| Return to Main Menu | `[M]`  | After dotfiles, press M to go back |
| Quit                | `[Q]`  | Exit the script                    |

## PowerShell Aliases

```powershell
gst     # git status
gad     # git add .
gcm     # git commit -m "message"
glog    # git log --oneline -10
cd..    # parent directory
la      # list all files
ll      # recursive listing
lt      # tree view
```

## Software Available (20+ apps)

**Development:** Git • VS Code • Node.js • Python • Neovim • MinGW • Arduino IDE

**Communication:** Discord • WhatsApp • Telegram

**Productivity:** Notion • Notion Calendar • PowerToys

**Media:** PotPlayer • OBS Studio • VLC

**System:** 7-Zip • Chrome • PowerShell 7 • zoxide • Avro Keyboard • Git Kraken

## Keyboard Shortcuts

### Configuration Selection

| Key     | Action                                    |
| ------- | ----------------------------------------- |
| `↑/↓`   | Navigate                                  |
| `j/k`   | Navigate (vim)                            |
| `SPACE` | Toggle selection                          |
| `A`     | Select all                                |
| `N`     | Select none                               |
| `G`     | Apply & push to GitHub (config menu only) |
| `O`     | Open repo (config menu only)              |
| `ENTER` | Confirm/Apply                             |
| `B`     | Back/Cancel                               |

### Software Selection

| Key     | Action           |
| ------- | ---------------- |
| `↑/↓`   | Navigate         |
| `j/k`   | Navigate (vim)   |
| `SPACE` | Toggle selection |
| `A`     | Select all       |
| `N`     | Select none      |
| `ENTER` | Install selected |
| `B`     | Back/Cancel      |

## Customization

**Add Software:**
Edit `init.ps1` → Find `$softwareMap` → Add new entry with WingetId

**Add Config:**
Edit `init.ps1` → Find `$configMap` → Add target + source

**Customize Prompt:**
Edit `configs/pwsh/Microsoft.PowerShell_profile.ps1` → Modify colors/format

## Troubleshooting

| Issue                  | Solution                                              |
| ---------------------- | ----------------------------------------------------- |
| Script won't run       | Run as Administrator + Set execution policy if needed |
| Winget not found       | Install "Windows App Installer" from Microsoft Store  |
| Symlinks fail          | Run script as Administrator                           |
| Git commands fail      | Install Git: `winget install Git.Git`                 |
| Slow git status        | Normal on large repos; can disable in profile         |
| Software install fails | Check setup.log for details; may need manual install  |

## Files & Directories

```
init.ps1                     Main setup script (42KB)
README.md                    Full documentation
LICENSE                      MIT License
CHANGELOG.md                 Version history
CONTRIBUTING.md              Contributor guide
QUICKREF.md                  This file
PUBLISH_CHECKLIST.md         Pre-publication checks
setup.log                    Operation logs (created at runtime)
.gitignore                   Git excludes

configs/
  ├── vscode/               VS Code settings/keybindings/snippets
  ├── pwsh/                 PowerShell profile with aliases & prompt
  ├── nvim/                 Neovim configuration
  ├── ahk/                  AutoHotkey CapsLock remapping
  └── wt/                   Windows Terminal settings

_backups/                    Auto-backups (versioned by timestamp)
```

## Pro Tips

- **Auto-reapply configs:** Run `.\init.ps1` and press ENTER to quickly reapply after changes
- **Selective software:** Don't select all apps; choose only what you need
- **Check logs:** `Get-Content .\setup.log | tail -50` shows last 50 operations
- **Git workflow:** After making config changes, press `[G]` to auto-commit and push
- **Main menu access:** From anywhere in the script, press `[Q]` to quit or use `[M]` when available

## Links

```

- **Repository:** https://github.com/T4snimul/.dotfiles-windows
- **Issues:** https://github.com/T4snimul/.dotfiles-windows/issues
- **Discussions:** https://github.com/T4snimul/.dotfiles-windows/discussions

## Support

1. Check README.md for detailed help
2. Review CONTRIBUTING.md for development
3. Check setup.log for error details
4. Search existing GitHub issues
5. Create new issue if needed

---

**Made with ❤️ for Windows developers | MIT License**
```
