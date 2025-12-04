# Contributing to .dotfiles-windows

Thank you for your interest in contributing! This document provides guidelines and instructions for contributing to the project.

## 📋 Code of Conduct

Be respectful, inclusive, and constructive in all interactions.

## 🚀 Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork:**
   ```powershell
   git clone https://github.com/YOUR-USERNAME/.dotfiles-windows.git
   cd .dotfiles-windows
   ```
3. **Create a feature branch:**
   ```powershell
   git checkout -b feature/your-feature-name
   ```

## 💡 Types of Contributions

### Bug Reports

- Check if the issue already exists
- Provide clear reproduction steps
- Include your Windows version and PowerShell version
- Include relevant error logs from `setup.log`

### Feature Requests

- Describe the feature and its use case
- Explain why it would be useful
- Provide examples if applicable

### Code Contributions

- Follow the existing code style
- Add comments for complex logic
- Test thoroughly before submitting
- Update documentation as needed

### Documentation

- Fix typos or unclear sections
- Add examples
- Improve readability
- Update outdated information

## 🏗️ Development Guidelines

### PowerShell Code Style

```powershell
# Use PascalCase for function names
function Get-SoftwareInstallStatus {
    param(
        [Parameter(Mandatory)]
        [string]$WingetId
    )

    # Implementation here
}

# Use camelCase for variables
$softwareList = @()
$isInstalled = $true

# Add comment documentation
<#
.SYNOPSIS
    Description of what the function does
.PARAMETER ParameterName
    Description of parameter
.EXAMPLE
    Get-SoftwareInstallStatus -WingetId "Git.Git"
#>

# Use Write-Log for all output
Write-Log -Message "Operation completed" -Level Success
```

### File Organization

```
configs/
├── new-app/
│   ├── config-file-1
│   └── config-file-2
```

### Commit Messages

Follow conventional commits:

- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation
- `refactor:` for code refactoring
- `test:` for tests
- `chore:` for maintenance

Examples:

```
feat: add Docker support to software installation
fix: correct git status detection in prompt
docs: update README with new aliases
refactor: optimize winget installation function
```

## ✅ Testing Checklist

Before submitting a pull request:

- [ ] Script runs without errors
- [ ] No syntax errors in PowerShell
- [ ] All new functions are documented
- [ ] Existing functionality still works
- [ ] Tested on Windows 10/11
- [ ] Setup.log shows expected entries
- [ ] Git integration works (if applicable)
- [ ] Backup system functions correctly

### Manual Testing

1. **Test dotfiles sync:**

   ```powershell
   .\init.ps1
   # Navigate menu, apply configs
   # Verify symlinks in user profile
   ```

2. **Test software installation:**

   ```powershell
   .\init.ps1
   # Press [S]
   # Install a test app
   # Verify installation
   ```

3. **Test logging:**

   ```powershell
   Get-Content .\setup.log | Select-Object -Last 20
   ```

4. **Test PowerShell profile:**
   ```powershell
   # Check prompt displays correctly
   # Verify git status shows
   # Test aliases work
   ```

## 📝 Documentation

### README Updates

- Keep it clear and concise
- Use examples
- Update feature lists
- Maintain table of contents

### Code Comments

- Explain "why" not "what"
- Use clear, professional language
- Update when code changes
- Keep them minimal

### Changelog

- Add entry under appropriate section
- Reference issue numbers if applicable
- Follow semantic versioning

## 🔄 Pull Request Process

1. **Ensure your fork is up to date:**

   ```powershell
   git remote add upstream https://github.com/T4snimul/.dotfiles-windows.git
   git fetch upstream
   git rebase upstream/main
   ```

2. **Push to your fork:**

   ```powershell
   git push origin feature/your-feature-name
   ```

3. **Create Pull Request on GitHub:**

   - Clear title: "feat: add new feature" or "fix: resolve issue #123"
   - Description of changes
   - Motivation and context
   - Testing done
   - Screenshots/examples if applicable

4. **Respond to feedback:**

   - Review comments carefully
   - Make requested changes
   - Push updates to same branch
   - Respond to discussions

5. **Wait for approval:**
   - At least one approval required
   - All checks must pass
   - Maintainer will merge

## 🎯 Priority Areas for Contribution

Currently looking for help with:

1. **Additional Configuration Templates**

   - Vim/Neovim full config
   - Git configuration
   - SSH keys setup

2. **More Applications**

   - Additional winget packages
   - Alternative package managers
   - Portable app support

3. **Platform Support**

   - WSL integration
   - Windows Sandbox support
   - Portable Windows support

4. **Documentation**

   - Tutorial videos
   - Quick setup guide
   - Troubleshooting guide

5. **Testing**
   - Windows 10/11 compatibility
   - Different PowerShell versions
   - Various hardware setups

## 📚 Resources

- [PowerShell Documentation](https://learn.microsoft.com/powershell/)
- [Git Documentation](https://git-scm.com/doc)
- [Winget Documentation](https://github.com/microsoft/winget-cli)
- [Conventional Commits](https://www.conventionalcommits.org/)

## ❓ Questions?

- Check existing issues and discussions
- Ask in GitHub Discussions
- Read the README and docs
- Review similar code in the repository

## 🙏 Thank You!

Your contributions make this project better for everyone. Thank you for taking the time to contribute!

---

**Happy coding!** 🚀
