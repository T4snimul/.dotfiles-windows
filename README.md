# 🖥️ Dotfiles for Windows

A comprehensive dotfiles management system for Windows with interactive configuration sync, software installation, and an optimized PowerShell prompt.

![License](https://img.shields.io/badge/License-MIT-blue.svg)
![PowerShell](https://img.shields.io/badge/PowerShell-7+-blue)
![Windows](https://img.shields.io/badge/Windows-10%2B-0078D4)

## ✨ Features

### 📁 Configuration Management

- **Interactive Symlink Setup** - Choose which configs to sync with vim-style navigation
- **Safe Backups** - Automatic versioned backups before creating symlinks
- **Status Display** - See which configs are already linked (✦ indicator)
- **Re-apply Support** - Sync configs multiple times without issues

### 💻 Software Installation

- **20+ Pre-configured Apps** - Install via winget with interactive selection
- **Installation Status Detection** - See which software is already installed
- **Smart Installation** - Skips already-installed packages automatically
- **No Heavy Dependencies** - Uses native Windows App Installer (winget)

### 🚀 PowerShell Profile

- **Real-time Prompt** - Current time + git status + execution time tracking
- **Git Integration** - Shows branch name and dirty status (yellow for changes)
- **Performance Monitoring** - Displays how long commands took to execute
- **Vi Keybindings** - Vim-style editing in terminal
- **Git Shortcuts** - Quick commands like `gst`, `gad`, `gcm`, `glog`

### 🔐 Security & Convenience

- **Admin Detection** - Automatically detects current user (not admin user)
- **Error Handling** - Comprehensive logging to `setup.log`
- **GitHub Integration** - Auto-generated commit messages for easy syncing
- **Portable Paths** - Works from any location using relative paths

## 📋 Supported Applications

| Category          | Applications                                                          |
| ----------------- | --------------------------------------------------------------------- |
| **Development**   | Git, VS Code, Node.js, Python, Neovim, MinGW Compiler, Arduino IDE    |
| **Communication** | Discord, WhatsApp, Telegram                                           |
| **Productivity**  | Notion, Notion Calendar, PowerToys                                    |
| **Media**         | PotPlayer, OBS Studio, VLC Media Player                               |
| **System**        | 7-Zip, Google Chrome, PowerShell 7, zoxide, Avro Keyboard, Git Kraken |

## 🚀 Quick Start

### ⭐ Fork This Repository First! (Recommended)

This repository is designed to be **personal to your system**. You should fork it on GitHub to create your own version that you can customize and maintain:

**Why fork?**

- Keep your personal configurations private and version-controlled
- Make customizations without affecting the original repository
- Easily push your settings to your own repository
- Maintain your own history of configuration changes

**How to fork:**

1. Visit: https://github.com/T4snimul/.dotfiles-windows
2. Click the **Fork** button (top right corner)
3. This creates your own copy: `https://github.com/YOUR_USERNAME/.dotfiles-windows`

Then clone your forked repository:

```powershell
git clone https://github.com/YOUR_USERNAME/.dotfiles-windows.git
cd .dotfiles-windows
.\init.ps1
```

### Prerequisites

- Windows 10 or later
- PowerShell 5.1+ (7+ recommended)
- Admin privileges
- Git installed (can install via script)
- Windows App Installer (available in Microsoft Store)

### Installation (After Forking)

1. **Clone your forked repository:**

   ```powershell
   git clone https://github.com/YOUR_USERNAME/.dotfiles-windows.git
   cd .dotfiles-windows
   ```

2. **Run the setup script:**

   ```powershell
   .\init.ps1
   ```

3. **Interactive Menu:**

   - Use `↑/↓` or `j/k` to navigate
   - Press `SPACE` to toggle selections
   - Press `A` to select all, `N` for none
   - Press `ENTER` to apply dotfiles

4. **Post-setup Options:**
   - `[ENTER]` - Apply dotfiles again
   - `[S]` - Install software packages
   - `[G]` - Push changes to GitHub
   - `[O]` - Open repository folder
   - `[Q]` - Quit

## 📁 Repository Structure

```
.dotfiles-windows/
├── init.ps1                          # Main setup script
├── README.md                         # This file
├── .gitignore                        # Git configuration
├── configs/
│   ├── vscode/
│   │   ├── settings.json            # VS Code settings
│   │   ├── keybindings.json         # VS Code keybindings
│   │   └── snippets/                # VS Code snippets
│   ├── pwsh/
│   │   └── Microsoft.PowerShell_profile.ps1  # PowerShell profile
│   ├── nvim/
│   │   ├── init.lua                 # Neovim configuration
│   │   └── lua/                     # Neovim plugins & settings
│   ├── ahk/
│   │   └── CapsLock.ahk             # AutoHotkey remapping
│   └── wt/
│       └── settings.json            # Windows Terminal settings
├── _backups/                        # Auto-generated backups
└── setup.log                        # Execution log
```

## 🎨 Features in Detail

### Interactive Configuration Selection

```
╔════════════════════════════════════════════════════════════════╗
║         Dotfiles Configuration Selection                       ║
║                                                                ║
║  Legend: [✓] Selected  ✦ Already Linked  [ ] Not Selected     ║
╚════════════════════════════════════════════════════════════════╝

→ [✓] VS Code Settings ✦ (linked)
  [ ] VS Code Keybindings
  [✓] PowerShell Profile
  [ ] Neovim
```

### Enhanced PowerShell Prompt

```
14:23:45 projects ·git: main* [245ms] ❯
```

- **14:23:45** - Current time
- **projects** - Current folder
- **·git: main\*** - Git branch with dirty indicator
- **[245ms]** - Last command execution time

### Software Installation Menu

```
╔════════════════════════════════════════════════════════════════╗
║         Software Installation Selection                        ║
║                                                                ║
║  Legend: [✓] Selected  ✦ Installed  [ ] Not Selected          ║
╚════════════════════════════════════════════════════════════════╝

→ [ ] Git
  [✓] VS Code ✦ (installed)
  [✓] Node.js ✦ (installed)
```

## ⌨️ PowerShell Aliases

| Alias  | Command                         | Description                     |
| ------ | ------------------------------- | ------------------------------- |
| `lt`   | `tree /F`                       | Tree view of directory          |
| `la`   | `Get-ChildItem -Force`          | List all files including hidden |
| `ll`   | `Get-ChildItem -Force -Recurse` | Recursive directory listing     |
| `cd..` | `Set-Location ..`               | Go up one directory             |
| `gst`  | `git status`                    | Git status                      |
| `gad`  | `git add .`                     | Add all changes                 |
| `gcm`  | `git commit -m`                 | Git commit with message         |
| `glog` | `git log --oneline -10`         | Last 10 commits                 |

## 🔧 Customization Guide

### 🍴 After Forking: Setting Up Your Repository

Once you've forked this repository, customize it for your personal use:

1. **Update software list** - Add/remove apps you want to install
2. **Update configurations** - Point to your custom settings files
3. **Edit PowerShell profile** - Customize aliases, colors, and prompt
4. **Commit your changes** - Push to your fork: `git add -A && git commit -m "Personal config" && git push`

### Customize Software List

Edit `init.ps1` and modify the `$softwareMap` hashtable:

```powershell
$softwareMap = @{
  "Your App Name" = @{
    WingetId = "Publisher.AppName"
    Description = "Description of the app"
  }
  # Add more apps...
}
```

Find WingetId by running: `winget search "app-name"`

### Customize Dotfiles

Add new configs to the `$configMap` hashtable in `init.ps1`:

```powershell
$configMap = @{
  "My Config Name" = @{
    Target = "C:\Users\username\path\to\target\file.json"
    Source = "$configDir\myconfig\file.json"
  }
  # Add more configs...
}
```

**Pro Tips:**

- Use `$userProfilePath` for user-relative paths
- Use `$configDir` for configs directory
- Set `CopyOnly = $true` for files that don't support symlinks (like `.ahk`)

### Customize PowerShell Prompt

Edit `configs/pwsh/Microsoft.PowerShell_profile.ps1`:

```powershell
# Change colors
$colorTime = [ConsoleColor]::Cyan        # Time display color
$colorFolder = [ConsoleColor]::White     # Folder name color
$colorGit = [ConsoleColor]::Green        # Git branch color

# Add custom aliases
function mynewcmd { Write-Host "My command" }

# Modify prompt format
Write-Host "Your custom prompt here" -ForegroundColor Green
```

### Customize Prompt Display

The prompt is configured in `Microsoft.PowerShell_profile.ps1`. Edit these sections:

- **Top line (info):** Time, folder, git status, execution time
- **Bottom line (input):** Where you type commands
- **Colors:** Change foreground/background colors
- **Symbols:** Replace `●`, `◆`, `❯` with your preferred Unicode characters

### Push Your Customizations

After making changes:

```powershell
# From the dotfiles directory
.\init.ps1
# Select [G] to push to GitHub automatically
# Or manually:
git add -A
git commit -m "My dotfiles customization"
git push
```

## 📝 Logging

All operations are logged to `setup.log` with timestamps:

```
[2024-12-04 14:23:45] [Success] Linked: Target → Source
[2024-12-04 14:23:46] [Warning] Backup already exists: path
[2024-12-04 14:23:47] [Error] Failed to create symlink: error message
```

## 🔄 GitHub Integration

Automatically push dotfiles changes to GitHub:

1. Run the script and complete dotfiles setup
2. Press `[G]` at the main menu
3. Script will:
   - Check for uncommitted changes
   - Auto-generate commit message with timestamp
   - Stage all changes (`git add -A`)
   - Commit with descriptive message
   - Push to GitHub

## 🐛 Troubleshooting

### Symlink Creation Fails

- Ensure you're running as Administrator
- Check that target directories exist
- Verify file paths are correct

### Winget Not Found

- Install "Windows App Installer" from Microsoft Store
- Or update Windows to latest version

### Script Won't Execute

- Check ExecutionPolicy: `Get-ExecutionPolicy`
- Set it if needed: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

### Git Commands Fail

- Ensure Git is installed: `git --version`
- Configure Git: `git config --global user.name "Your Name"` and `git config --global user.email "your@email.com"`

## 📚 Advanced Usage

### Install Specific Software Only

```powershell
.\init.ps1
# Skip dotfiles (press Q in menu)
# Select [S] for software
# Choose only the apps you want
```

### Re-sync Dotfiles

```powershell
.\init.ps1
# Go through menu again
# [ENTER] to apply multiple times
```

### Manual Log Review

```powershell
Get-Content .\setup.log -Tail 20  # Last 20 lines
```

## 🤝 Contributing

Feel free to fork and customize for your own setup! Common customizations:

- Add your own config files to `configs/`
- Extend `$softwareMap` with more applications
- Create additional PowerShell aliases and functions
- Modify colors and prompt format in the profile

## 📄 License

This project is licensed under the MIT License - see below for details.

```
MIT License

Copyright (c) 2024 T4snimul

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/T4snimul/.dotfiles-windows/issues)
- **Discussions**: [GitHub Discussions](https://github.com/T4snimul/.dotfiles-windows/discussions)

## 🙏 Acknowledgments

- [zoxide](https://github.com/ajeetdsouza/zoxide) - Smart directory navigation
- [PowerShell](https://github.com/PowerShell/PowerShell) - Modern shell
- [winget](https://github.com/microsoft/winget-cli) - Windows package manager

---

**Made with ❤️ for Windows developers and sysadmins**
