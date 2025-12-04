# Changelog

All notable changes to this project will be documented in this file.

## [1.1.0] - 2024-12-12

### Fixed

- **Software Installation Robustness**

  - Enhanced `Test-WingetInstalled` with 4 fallback detection methods:
    1. Get-Command check (most reliable)
    2. WindowsApps directory search with wildcard
    3. Program Files DesktopAppInstaller search
    4. Direct winget executable test
  - Improved `Get-SoftwareInstallStatus` with better error handling and output parsing
  - Enhanced `Install-Software` with retry logic and comprehensive verification
  - Added 3-second verification delay for slower systems
  - Added fallback success detection based on winget output patterns

- **Main Menu Architecture**

  - Startup menu now displays options to users immediately
  - Software installation accessible from main menu without requiring dotfiles setup
  - Added [M] Main Menu option to return to startup menu from dotfiles selection
  - Improved menu flow with better state management using $startupMenu flag
  - Enhanced winget availability error messages with troubleshooting steps

- **Logging & Debugging**
  - Added Debug level to Write-Log function
  - Better error messages for winget-related issues
  - Comprehensive installation attempt logging for troubleshooting

### Changed

- Menu structure now presents 5 main options at startup: [D]otfiles, [S]oftware, [G]itHub, [O]pen, [Q]uit
- Software installation now independent operation, not tied to dotfiles workflow
- More robust winget detection eliminates edge cases on different Windows versions

### Maintenance

- Script size increased from 32KB to 42KB (new functions and error handling)
- Comprehensive state management to prevent workflow issues
- Better separation of concerns between features

## [1.0.0] - 2024-12-04

### Added

- Initial release of .dotfiles-windows
- Interactive dotfiles configuration management with vim-style navigation
- Support for 7 configuration files/directories (VS Code, PowerShell, Windows Terminal, Neovim, AutoHotkey)
- Software installation via winget with interactive selection
- 20+ pre-configured applications ready to install
- Enhanced PowerShell profile with:
  - Real-time clock display
  - Git branch and status indicators
  - Command execution time tracking
  - Vi keybindings support
  - Quick git aliases (gst, gad, gcm, glog)
- Automatic backup system with versioning
- GitHub integration with auto-generated commit messages
- Comprehensive logging to setup.log
- Admin/user detection for correct path resolution
- Symlink validation and status checking
- Re-apply support for multiple runs

### Features

- 20+ Applications: Git, VS Code, Node.js, Python, Neovim, Arduino IDE, MinGW Compiler, Docker, Chrome, Discord, WhatsApp, Telegram, and more
- Configuration Symlinks: VS Code Settings/Keybindings/Snippets, PowerShell Profile, Windows Terminal, Neovim, AutoHotkey
- Safe Operations: Automatic backups before any file modifications
- Performance: Lightweight functions, minimal overhead, fast startup
- Security: Admin privilege verification, comprehensive error handling
- Logging: Full audit trail with timestamps

### Documentation

- Comprehensive README.md with quick start guide
- Configuration guide for customization
- Troubleshooting section
- PowerShell aliases reference
- Repository structure documentation
- MIT License

### Scripts

- init.ps1 - Main setup and management script (~900 lines)
  - Interactive menu system
  - Configuration management
  - Software installation
  - GitHub integration
  - Comprehensive error handling and logging

### Profiles

- Microsoft.PowerShell_profile.ps1 - Optimized PowerShell profile
  - Performance-tracked prompt
  - Git status integration
  - Time display
  - Execution time tracking

---

## Future Roadmap

### v1.1.0 (Planned)

- [ ] WSL integration support
- [ ] SSH key management
- [ ] Parallel software installation
- [ ] Configuration rollback functionality
- [ ] More customization templates

### v1.2.0 (Planned)

- [ ] Web UI dashboard
- [ ] Cloud sync support
- [ ] Plugin system
- [ ] Custom hook scripts
- [ ] Multi-user profiles

---

## Known Issues

None currently reported.

## Support

For issues, questions, or suggestions:

- GitHub Issues: https://github.com/T4snimul/.dotfiles-windows/issues
- GitHub Discussions: https://github.com/T4snimul/.dotfiles-windows/discussions

---

**Made with ❤️ for Windows developers**
