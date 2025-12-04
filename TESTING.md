# Testing Guide for .dotfiles-windows

This document provides a comprehensive testing checklist for the dotfiles management system.

## Pre-Testing Requirements

- [ ] Windows 10 or later
- [ ] PowerShell 5.1 or later
- [ ] Admin privileges for running the script
- [ ] Git installed and configured
- [ ] Backup of important configuration files (optional but recommended)

## Testing Scenarios

### 1. Script Startup & Menu

- [ ] **Startup Menu Displays Correctly**

  - Run `.\init.ps1` with admin privileges
  - Verify 5 menu options display: [D]otfiles, [S]oftware, [G]itHub, [O]pen, [Q]uit
  - All text renders without corruption

- [ ] **Menu Navigation**
  - Press [Q] to verify clean exit
  - Run script again and press [D] to continue to dotfiles menu
  - Verify smooth transitions and no screen glitches

### 2. Winget Detection (Critical)

- [ ] **Test-WingetInstalled Function**
  - Run script and immediately press [S] for software installation
  - If winget is installed:
    - Software menu should display with installation status indicators (✦)
    - Already-installed packages should show "(installed)" badge
  - If winget is NOT installed:
    - Clear error message with troubleshooting steps
    - User can return to main menu

### 3. Software Installation Feature

- [ ] **Software Selection Menu**

  - Navigate with arrow keys and vim keys (j/k)
  - Toggle selections with SPACE
  - [A] selects all, [N] deselects all
  - Install status indicators visible for each package

- [ ] **Test Small Installation**

  - Select 1-2 small utilities (e.g., zoxide, 7-Zip)
  - Press ENTER to install
  - Monitor output for:
    - "Installing X..." messages
    - "Successfully installed: X" confirmations
    - Progress indicators
    - Installation completion summary

- [ ] **Installation Verification**

  - After completion, winget list | grep [package name] should show installed
  - Verify packages are actually available on system
  - Check setup.log for installation records

- [ ] **Retry Logic**
  - Intentionally install a package that may fail
  - Verify script retries (3-second waits between attempts)
  - Check that verification happens after installation

### 4. Dotfiles Configuration

- [ ] **Dotfiles Menu Display**

  - Select [D] from main menu
  - Shows 7 configuration options:
    1. VS Code Settings
    2. VS Code Keybindings
    3. VS Code Snippets
    4. PowerShell Profile
    5. Windows Terminal Settings
    6. Neovim Config
    7. AutoHotkey CapsLock

- [ ] **Configuration Selection**

  - Navigate with arrow/vim keys
  - Toggle with SPACE
  - Verify symlink status indicators (✓, ✗, or symbol)
  - [A] and [N] keys work for bulk selection

- [ ] **Symlink Creation**
  - Select 1-2 configurations
  - Press ENTER to apply
  - Verify success messages in green
  - Check that files are actually symlinked:
    - Open PowerShell: `Get-Item "C:\Users\$env:USERNAME\AppData\Roaming\Code\User\settings.json" | Select-Object LinkType`
    - Should show "SymbolicLink" or copy status for incompatible paths

### 5. GitHub Integration

- [ ] **Push to GitHub Function**
  - From any menu, select [G] to push
  - Verify git add/commit/push happens
  - Check for auto-generated commit message: "dotfiles: update configurations (timestamp)"
  - Verify on GitHub that changes appeared

### 6. Backup System

- [ ] **Backup Creation**

  - Before first symlink operation, backup directory should be empty
  - After symlink operations, `_backups/` should contain timestamped backups
  - Verify backup naming: `[timestamp]_[filename_or_dirname]`

- [ ] **Backup on Re-run**
  - Run script again and reapply dotfiles
  - Previous symlink should be backed up before recreation
  - Multiple backups should accumulate

### 7. Logging

- [ ] **setup.log Creation**

  - After any operation, `setup.log` should exist in repo root
  - Each operation should have timestamp
  - Check log format: `[timestamp] [Level] Message`

- [ ] **Log Entries for Different Operations**
  - Successful symlinks: marked with timestamp
  - Failed operations: marked as Error or Warning
  - Software installations: detailed with package names

### 8. Main Menu Return Feature

- [ ] **[M] Main Menu Option**
  - After dotfiles selection/application, [M] should appear in menu
  - Pressing [M] returns to startup menu
  - Can then select different option (e.g., [S] for software)

### 9. PowerShell Profile

- [ ] **Profile Customizations Active**

  - Open new PowerShell prompt
  - Verify:
    - Time displays in prompt: `HH:mm:ss` format
    - Git status shows (if in git repo)
    - Green prompt if git clean, Yellow if dirty
    - Execution time shows: `[X ms]` or `[X.XX s]`

- [ ] **Aliases Available**
  - In PowerShell, test aliases:
    - `gst` → git status
    - `gad` → git add .
    - `cd..` → parent directory
    - `la` → list all files
    - `ll` → recursive listing
    - `lt` → tree view

### 10. VS Code Integration

- [ ] **Settings Applied**

  - After symlink, open VS Code
  - Check Settings: Vim keybindings should be enabled
  - Color scheme should be "Ardent"
  - Editor settings (tab size, etc.) should match config file

- [ ] **Keybindings Active**
  - Verify custom keybindings work in editor
  - Check specific vim mappings are functional

### 11. Edge Cases & Error Handling

- [ ] **No Configurations Selected**

  - Select [D] then press ENTER without selecting any options
  - Should show warning and return to menu

- [ ] **Already Installed Software**

  - Run software install for already-installed package
  - Should show "✦ (installed)" badge
  - Should skip installation with "(skipping)" message

- [ ] **Non-Admin Execution**

  - Try running script without admin
  - Should display error about admin requirement
  - Should not damage system

- [ ] **Missing winget**
  - If winget not installed, [S] should show helpful error
  - Should guide user to Microsoft Store

### 12. Performance

- [ ] **Startup Time**

  - Script should show menu within < 3 seconds
  - No unnecessary delays on startup

- [ ] **Menu Responsiveness**

  - Menu should respond instantly to key presses
  - No lag during navigation or selection

- [ ] **Installation Speed**
  - Software installation should proceed without hanging
  - Logs should show progress

## Known Issues & Workarounds

| Issue                          | Workaround                            |
| ------------------------------ | ------------------------------------- |
| AutoHotkey symlinks don't work | Uses CopyOnly flag instead of symlink |
| Slow git status in large repos | Can disable git check in profile      |
| winget install hangs           | Set timeout via MaxRetries parameter  |

## Quick Test Checklist

Run through these quickly for a smoke test:

```
[ ] Run .\init.ps1 and see startup menu
[ ] Select [Q] and verify clean exit
[ ] Run again, select [S], verify software menu
[ ] Select 1 small package and install
[ ] Verify installation with winget list
[ ] Return to main menu via [M]
[ ] Select [D] for dotfiles
[ ] Select VS Code Settings and apply
[ ] Verify symlink created: Get-Item "C:\Users\$env:USERNAME\AppData\Roaming\Code\User\settings.json"
[ ] Check setup.log for entries
[ ] Open new PowerShell and test git alias: gst
```

## Reporting Bugs

If you encounter issues:

1. Check `setup.log` for detailed error messages
2. Run with admin privileges
3. Verify winget is installed: `winget --version`
4. Check Windows version (10 or later required)
5. Run in PowerShell (not PowerShell ISE)
6. Report with:
   - OS version: `[System.Environment]::OSVersion`
   - PowerShell version: `$PSVersionTable.PSVersion`
   - Error message from setup.log
   - Steps to reproduce

## Success Criteria

All tests should pass for production release:

- [ ] 12+ test scenarios pass
- [ ] No unhandled errors in setup.log
- [ ] All menus display correctly
- [ ] Software installation successful for 5+ packages
- [ ] Dotfiles symlinks created properly
- [ ] GitHub push works
- [ ] Backup system functional
- [ ] Logging complete and accurate
- [ ] Help documentation clear and helpful
