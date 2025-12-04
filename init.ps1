#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Dotfiles Configuration Manager for Windows
.DESCRIPTION
    Interactive setup tool for Windows dotfiles with software installation,
    symbolic links, and GitHub integration.
#>

$ErrorActionPreference = 'Continue'

# Get script directory (where init.ps1 is located) - this is the dotfiles repo root
$dotfilesRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$backupDir = "$dotfilesRoot\_backups"
$configDir = "$dotfilesRoot\configs"
$logFile = "$dotfilesRoot\setup.log"

# Get the actual current user (not the admin user if running as admin)
$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$currentUserName = $currentUser -split '\\' | Select-Object -Last 1
$userProfilePath = "C:\Users\$currentUserName"

# Initialize log file
"[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Script execution started" | Out-File -FilePath $logFile -Append

function Write-Log {
  <#
  .SYNOPSIS
      Write log messages to both console and log file
  #>
  param(
    [Parameter(Mandatory)]
    [string]$Message,
    [Parameter()]
    [ValidateSet('Info', 'Success', 'Warning', 'Error', 'Debug')]
    [string]$Level = 'Info'
  )

  $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
  $logMessage = "[$timestamp] [$Level] $Message"

  # Write to file
  $logMessage | Out-File -FilePath $logFile -Append

  # Write to console with color
  switch ($Level) {
    'Success' { Write-Host "✓ $Message" -ForegroundColor Green }
    'Warning' { Write-Host "⚠ $Message" -ForegroundColor Yellow }
    'Error' { Write-Host "✗ $Message" -ForegroundColor Red }
    'Debug' {
      if ($VerbosePreference -eq 'Continue') {
        Write-Host "⟳ $Message" -ForegroundColor DarkGray
      }
    }
    default { Write-Host "ℹ $Message" -ForegroundColor Cyan }
  }
}

# Config Definition
$configMap = @{
  "VS Code Settings" = @{
    Target = "$userProfilePath\AppData\Roaming\Code\User\settings.json"
    Source = "$configDir\vscode\settings.json"
  }
  "VS Code Keybindings" = @{
    Target = "$userProfilePath\AppData\Roaming\Code\User\keybindings.json"
    Source = "$configDir\vscode\keybindings.json"
  }
  "VS Code Snippets" = @{
    Target = "$userProfilePath\AppData\Roaming\Code\User\snippets\"
    Source = "$configDir\vscode\snippets\"
  }
  "PowerShell Profile" = @{
    Target = "$userProfilePath\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    Source = "$configDir\pwsh\Microsoft.PowerShell_profile.ps1"
  }
  "Windows Terminal" = @{
    Target = "$userProfilePath\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\Settings.json"
    Source = "$configDir\wt\settings.json"
  }
  "Neovim" = @{
    Target = "$userProfilePath\AppData\Local\nvim\"
    Source = "$configDir\nvim\"
  }
  "AutoHotkey CapsLock" = @{
    Target = "$userProfilePath\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\CapsLock.ahk"
    Source = "$configDir\ahk\CapsLock.ahk"
    CopyOnly = $true
  }
}

# Software Definition for winget installation
$softwareMap = @{
  "Git" = @{ WingetId = "Git.Git"; Description = "Version control system" }
  "Google Chrome" = @{ WingetId = "Google.Chrome"; Description = "Web browser" }
  "7-Zip" = @{ WingetId = "7zip.7zip"; Description = "File archiver" }
  "Avro Keyboard" = @{ WingetId = "Omicronlab.AvroKeyboard"; Description = "Bangla typing" }
  "Discord" = @{ WingetId = "Discord.Discord"; Description = "Communication" }
  "VS Code" = @{ WingetId = "Microsoft.VisualStudioCode"; Description = "Code editor" }
  "Notion" = @{ WingetId = "Notion.Notion"; Description = "Workspace" }
  "PotPlayer" = @{ WingetId = "Daum.PotPlayer"; Description = "Media player" }
  "PowerShell 7" = @{ WingetId = "Microsoft.PowerShell"; Description = "Modern PowerShell" }
  "PowerToys" = @{ WingetId = "Microsoft.PowerToys"; Description = "System utilities" }
  "zoxide" = @{ WingetId = "ajeetdsouza.zoxide"; Description = "Directory jumper" }
  "MinGW" = @{ WingetId = "mingw-w64.mingw-w64"; Description = "GCC compiler" }
  "Node.js" = @{ WingetId = "OpenJS.NodeJS"; Description = "JavaScript runtime" }
  "Arduino IDE" = @{ WingetId = "Arduino.IDE"; Description = "Arduino platform" }
  "WhatsApp" = @{ WingetId = "Meta.WhatsApp"; Description = "Messaging app" }
  "Telegram" = @{ WingetId = "Telegram.TelegramDesktop"; Description = "Messaging app" }
  "Git Kraken" = @{ WingetId = "Axosoft.GitKraken"; Description = "Git GUI client" }
  "OBS Studio" = @{ WingetId = "OBSProject.OBSStudio"; Description = "Screen recording" }
  "VLC" = @{ WingetId = "VideoLAN.VLC"; Description = "Media player" }
  "Neovim" = @{ WingetId = "Neovim.Neovim"; Description = "Text editor" }
  "Python" = @{ WingetId = "Python.Python.3.12"; Description = "Python language" }
}

function Initialize-Directory {
  param([Parameter(Mandatory)][string]$Path)
  if (-not (Test-Path -Path $Path)) {
    try {
      $null = New-Item -ItemType Directory -Path $Path -Force -ErrorAction Stop
      Write-Log -Message "Created directory: $Path" -Level Success
      return $true
    } catch {
      Write-Log -Message "Failed to create directory: $_" -Level Error
      return $false
    }
  }
  return $true
}

function Backup-ExistingItem {
  param(
    [Parameter(Mandatory)][string]$ItemPath,
    [Parameter(Mandatory)][string]$BackupPath
  )
  if (Test-Path -Path $BackupPath) {
    Write-Log -Message "Backup already exists (skipping)" -Level Warning
    return $true
  }
  try {
    Move-Item -Path $ItemPath -Destination $BackupPath -Force -ErrorAction Stop
    Write-Log -Message "Backed up: $ItemPath" -Level Success
    return $true
  } catch {
    Write-Log -Message "Failed to backup: $_" -Level Error
    return $false
  }
}

function New-SymbolicLink {
  param(
    [Parameter(Mandatory)][string]$Target,
    [Parameter(Mandatory)][string]$Source,
    [Parameter(Mandatory)][string]$BackupDirectory,
    [Parameter()][bool]$CopyOnly = $false
  )

  if (-not (Test-Path -Path $Source)) {
    Write-Log -Message "Source does not exist: $Source" -Level Error
    return $false
  }

  $targetParent = Split-Path -Parent $Target
  if (-not (Test-Path -Path $targetParent)) {
    if (-not (Initialize-Directory -Path $targetParent)) {
      return $false
    }
  }

  $existingItem = Get-Item -Path $Target -ErrorAction SilentlyContinue
  if ($existingItem -and $existingItem.LinkType -ne 'SymbolicLink') {
    $backupName = Split-Path -Leaf $Target
    $backupPath = Join-Path -Path $BackupDirectory -ChildPath $backupName
    if (-not (Backup-ExistingItem -ItemPath $Target -BackupPath $backupPath)) {
      return $false
    }
  }

  if ($CopyOnly) {
    try {
      Copy-Item -Path $Source -Destination $Target -Force -ErrorAction Stop
      Write-Log -Message "Copied: $Source → $Target" -Level Success
      return $true
    } catch {
      Write-Log -Message "Failed to copy: $_" -Level Error
      return $false
    }
  }

  try {
    $null = New-Item -ItemType SymbolicLink -Path $Target -Target $Source -Force -ErrorAction Stop
    Write-Log -Message "Linked: $Target → $Source" -Level Success
    return $true
  } catch {
    Write-Log -Message "Failed to create symlink: $_" -Level Error
    return $false
  }
}

function Get-SymlinkStatus {
  param([Parameter(Mandatory)][string]$Target)
  $item = Get-Item -Path $Target -ErrorAction SilentlyContinue
  return ($item -and $item.LinkType -eq 'SymbolicLink')
}

function Show-ConfigSelection {
  param([Parameter(Mandatory)][hashtable]$ConfigMap)

  $configs = $ConfigMap.Keys | Sort-Object
  $selectedIndices = @(0..($configs.Count - 1))
  $currentIndex = 0
  $done = $false

  while (-not $done) {
    Clear-Host
    Write-Host "`n╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║       Dotfiles Configuration Selection                      ║" -ForegroundColor Cyan
    Write-Host "║                                                              ║" -ForegroundColor Cyan
    Write-Host "║  Legend: [✓] Selected  ✦ Linked  [ ] Not Selected           ║" -ForegroundColor Cyan
    Write-Host "╚══════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

    foreach ($i in 0..($configs.Count - 1)) {
      $isSelected = $i -in $selectedIndices
      $isCurrent = $i -eq $currentIndex
      $config = $ConfigMap[$configs[$i]]
      $isLinked = Get-SymlinkStatus -Target $config.Target

      $checkbox = if ($isSelected) { "[✓]" } else { "[ ]" }
      $linkedBadge = if ($isLinked) { " ✦" } else { "" }
      $marker = if ($isCurrent) { "→ " } else { "  " }
      $color = if ($isCurrent) { "Yellow" } else { "White" }

      Write-Host "$marker$checkbox $($configs[$i])$linkedBadge" -ForegroundColor $color
    }

    Write-Host "`n┌──────────────────────────────────────────────────────────────┐" -ForegroundColor DarkGray
    Write-Host "│ Navigation: [↑/↓] or [j/k]  Toggle: [SPACE]                 │" -ForegroundColor DarkGray
    Write-Host "│ Apply: [ENTER]  Select All: [A]  None: [N]  Quit: [Q]      │" -ForegroundColor DarkGray
    Write-Host "└──────────────────────────────────────────────────────────────┘`n" -ForegroundColor DarkGray

    $key = [System.Console]::ReadKey($true)

    switch ($key.KeyChar.ToString().ToUpper()) {
      'J' { $currentIndex = if ($currentIndex -lt $configs.Count - 1) { $currentIndex + 1 } else { 0 }; continue }
      'K' { $currentIndex = if ($currentIndex -gt 0) { $currentIndex - 1 } else { $configs.Count - 1 }; continue }
      'A' { $selectedIndices = @(0..($configs.Count - 1)); continue }
      'N' { $selectedIndices = @(); continue }
      'Q' { Write-Host "`n⚠ Exiting.`n" -ForegroundColor Yellow; exit 0 }
      ' ' {
        if ($currentIndex -in $selectedIndices) {
          $selectedIndices = @($selectedIndices | Where-Object { $_ -ne $currentIndex })
        } else {
          $selectedIndices += $currentIndex
        }
        continue
      }
    }

    switch ($key.Key) {
      'UpArrow' { $currentIndex = if ($currentIndex -gt 0) { $currentIndex - 1 } else { $configs.Count - 1 } }
      'DownArrow' { $currentIndex = if ($currentIndex -lt $configs.Count - 1) { $currentIndex + 1 } else { 0 } }
      'Enter' { $done = $true }
    }
  }

  return @($configs[$selectedIndices] | Sort-Object)
}

function Test-WingetInstalled {
  try {
    $wingetPath = Get-Command winget -ErrorAction SilentlyContinue
    if ($wingetPath) {
      Write-Log -Message "winget found" -Level Debug
      return $true
    }
  } catch { }

  try {
    $windowsAppsPath = "$env:LOCALAPPDATA\Microsoft\WindowsApps"
    if (Test-Path $windowsAppsPath) {
      $wingetExe = Get-ChildItem -Path $windowsAppsPath -Filter "winget.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
      if ($wingetExe) { return $true }
    }
  } catch { }

  return $false
}

function Get-SoftwareInstallStatus {
  param([Parameter(Mandatory)][string]$WingetId)
  try {
    if (-not (Test-WingetInstalled)) { return $false }
    $output = & winget list --id $WingetId --exact 2>&1
    return -not ($output -match "No installed packages found" -or $output -match "0 package found")
  } catch {
    return $false
  }
}

function Show-SoftwareSelection {
  param([Parameter(Mandatory)][hashtable]$SoftwareMap)

  $software = $SoftwareMap.Keys | Sort-Object
  $selectedIndices = @()
  $currentIndex = 0
  $done = $false

  $installStatus = @{}
  foreach ($app in $software) {
    $installStatus[$app] = Get-SoftwareInstallStatus -WingetId $SoftwareMap[$app].WingetId
  }

  while (-not $done) {
    Clear-Host
    Write-Host "`n╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║       Software Installation Selection                       ║" -ForegroundColor Cyan
    Write-Host "║                                                              ║" -ForegroundColor Cyan
    Write-Host "║  Legend: [✓] Selected  ✦ Installed  [ ] Not Selected        ║" -ForegroundColor Cyan
    Write-Host "╚══════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

    foreach ($i in 0..($software.Count - 1)) {
      $isSelected = $i -in $selectedIndices
      $isCurrent = $i -eq $currentIndex
      $app = $software[$i]
      $isInstalled = $installStatus[$app]

      $checkbox = if ($isSelected) { "[✓]" } else { "[ ]" }
      $installedBadge = if ($isInstalled) { " ✦" } else { "" }
      $marker = if ($isCurrent) { "→ " } else { "  " }
      $color = if ($isCurrent) { "Yellow" } else { "White" }

      Write-Host "$marker$checkbox $app$installedBadge" -ForegroundColor $color
    }

    Write-Host "`n┌──────────────────────────────────────────────────────────────┐" -ForegroundColor DarkGray
    Write-Host "│ Navigation: [↑/↓] or [j/k]  Toggle: [SPACE]                 │" -ForegroundColor DarkGray
    Write-Host "│ Install: [ENTER]  Select All: [A]  None: [N]  Back: [B]    │" -ForegroundColor DarkGray
    Write-Host "└──────────────────────────────────────────────────────────────┘`n" -ForegroundColor DarkGray

    $key = [System.Console]::ReadKey($true)

    switch ($key.KeyChar.ToString().ToUpper()) {
      'J' { $currentIndex = if ($currentIndex -lt $software.Count - 1) { $currentIndex + 1 } else { 0 }; continue }
      'K' { $currentIndex = if ($currentIndex -gt 0) { $currentIndex - 1 } else { $software.Count - 1 }; continue }
      'A' { $selectedIndices = @(0..($software.Count - 1)); continue }
      'N' { $selectedIndices = @(); continue }
      'B' { return $null }
      ' ' {
        if ($currentIndex -in $selectedIndices) {
          $selectedIndices = @($selectedIndices | Where-Object { $_ -ne $currentIndex })
        } else {
          $selectedIndices += $currentIndex
        }
        continue
      }
    }

    switch ($key.Key) {
      'UpArrow' { $currentIndex = if ($currentIndex -gt 0) { $currentIndex - 1 } else { $software.Count - 1 } }
      'DownArrow' { $currentIndex = if ($currentIndex -lt $software.Count - 1) { $currentIndex + 1 } else { 0 } }
      'Enter' { $done = $true }
    }
  }

  return @($software[$selectedIndices] | Sort-Object)
}

function Install-Software {
  param(
    [Parameter(Mandatory)][string]$SoftwareName,
    [Parameter(Mandatory)][string]$WingetId
  )

  if (Get-SoftwareInstallStatus -WingetId $WingetId) {
    Write-Log -Message "$SoftwareName already installed (skipping)" -Level Warning
    return $true
  }

  try {
    Write-Log -Message "Installing $SoftwareName..." -Level Info
    $output = & winget install --id $WingetId --exact --silent --accept-package-agreements --accept-source-agreements 2>&1
    Start-Sleep -Seconds 3

    if (Get-SoftwareInstallStatus -WingetId $WingetId) {
      Write-Log -Message "✓ Installed: $SoftwareName" -Level Success
      return $true
    }
    Write-Log -Message "Installation inconclusive: $SoftwareName" -Level Warning
    return $false
  } catch {
    Write-Log -Message "Failed to install $SoftwareName : $_" -Level Error
    return $false
  }
}

function Push-ToGitHub {
  param([Parameter(Mandatory)][string]$RepositoryPath)

  Write-Host "`n──────────────────────────────────────────────────────────────" -ForegroundColor Cyan
  Write-Log -Message "Pushing to GitHub..." -Level Info

  if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Log -Message "Git not installed" -Level Error
    Write-Host "──────────────────────────────────────────────────────────────`n" -ForegroundColor Cyan
    return $false
  }

  try {
    Push-Location $RepositoryPath
    $status = git status --porcelain

    if ([string]::IsNullOrWhiteSpace($status)) {
      Write-Host "ℹ No changes to commit" -ForegroundColor Cyan
      Pop-Location
      return $true
    }

    git add -A | Out-Null
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    git commit -m "dotfiles: update configurations ($timestamp)" | Out-Null
    git push 2>&1 | ForEach-Object { Write-Host "  $_" -ForegroundColor DarkGray }

    Write-Log -Message "✓ Pushed to GitHub" -Level Success
    Pop-Location
    return $true
  } catch {
    Write-Log -Message "Git push failed: $_" -Level Error
    Pop-Location
    return $false
  }
}

# Initialize
Initialize-Directory -Path $backupDir | Out-Null
Clear-Host

Write-Host "`n╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║    Dotfiles Configuration Manager for Windows              ║" -ForegroundColor Cyan
Write-Host "║                                                              ║" -ForegroundColor Cyan
Write-Host "║  Repository: $dotfilesRoot" -ForegroundColor Cyan
Write-Host "║  User: $currentUserName" -ForegroundColor Cyan
Write-Host "║                                                              ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Start-Sleep -Milliseconds 1500

# Main loop
$continueLoop = $true
$startupMenu = $true

while ($continueLoop) {
  if ($startupMenu) {
    $startupMenu = $false

    Clear-Host
    Write-Host "`n╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                Dotfiles Manager Menu                       ║" -ForegroundColor Cyan
    Write-Host "╚══════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

    Write-Host "What would you like to do?`n" -ForegroundColor White
    Write-Host "  [D] Configure Dotfiles (symlink settings)" -ForegroundColor Green
    Write-Host "  [S] Install Software (via winget)" -ForegroundColor Green
    Write-Host "  [G] Push to GitHub" -ForegroundColor Green
    Write-Host "  [O] Open Repository Folder" -ForegroundColor Green
    Write-Host "  [Q] Quit`n" -ForegroundColor Green

    Write-Host "Repository: $dotfilesRoot" -ForegroundColor DarkGray
    Write-Host "User: $currentUserName`n" -ForegroundColor DarkGray

    $key = [System.Console]::ReadKey($true)
    $keyChar = $key.KeyChar.ToString().ToUpper()

    switch ($keyChar) {
      'D' { }
      'S' {
        if (-not (Test-WingetInstalled)) {
          Write-Host "`n✗ winget not found. Install from Microsoft Store.`n" -ForegroundColor Red
          Read-Host "Press ENTER to continue"
          $startupMenu = $true
        } else {
          $selected = Show-SoftwareSelection -SoftwareMap $softwareMap
          if ($selected -and $selected.Count -gt 0) {
            Write-Host "`n──────────────────────────────────────────────────────────────" -ForegroundColor Cyan
            Write-Host "Installing $($selected.Count) package(s)...`n" -ForegroundColor Cyan
            $success = 0
            $failed = 0
            foreach ($app in $selected) {
              Write-Host "  ⟳ $app" -ForegroundColor Yellow
              if (Install-Software -SoftwareName $app -WingetId $softwareMap[$app].WingetId) {
                $success++
              } else {
                $failed++
              }
            }
            Write-Host "`n──────────────────────────────────────────────────────────────" -ForegroundColor Cyan
            Write-Host "✓ Installation complete! Success: $success | Failed: $failed" -ForegroundColor Green
            Write-Host "──────────────────────────────────────────────────────────────`n" -ForegroundColor Cyan
          }
          Read-Host "Press ENTER to continue"
          $startupMenu = $true
        }
        continue
      }
      'G' {
        Push-ToGitHub -RepositoryPath $dotfilesRoot | Out-Null
        Read-Host "Press ENTER to continue"
        $startupMenu = $true
        continue
      }
      'O' {
        Invoke-Item $dotfilesRoot
        Read-Host "Press ENTER to continue"
        $startupMenu = $true
        continue
      }
      'Q' {
        Write-Host "`nExiting.`n" -ForegroundColor Cyan
        exit 0
      }
    }
  }

  # Dotfiles menu
  Write-Host "Checking dotfiles configuration...`n"
  $selectedConfigs = Show-ConfigSelection -ConfigMap $configMap

  if ($selectedConfigs.Count -eq 0) {
    Write-Host "`n⚠ No configurations selected.`n" -ForegroundColor Yellow
    Read-Host "Press ENTER to continue"
    $startupMenu = $true
    continue
  }

  Write-Host "`n──────────────────────────────────────────────────────────────" -ForegroundColor Cyan
  Write-Host "Processing $($selectedConfigs.Count) configuration(s)...`n" -ForegroundColor Cyan

  $successCount = 0
  $errorCount = 0

  foreach ($configName in $selectedConfigs) {
    $config = $configMap[$configName]
    $copyOnly = if ($config.CopyOnly) { $config.CopyOnly } else { $false }
    Write-Host "  ⟳ $configName" -ForegroundColor Yellow
    if (New-SymbolicLink -Target $config.Target -Source $config.Source -BackupDirectory $backupDir -CopyOnly $copyOnly) {
      $successCount++
    } else {
      $errorCount++
    }
  }

  Write-Host "`n──────────────────────────────────────────────────────────────" -ForegroundColor Cyan
  Write-Host "✓ Dotfiles complete! Success: $successCount | Failed: $errorCount" -ForegroundColor Green
  Write-Host "──────────────────────────────────────────────────────────────`n" -ForegroundColor Cyan

  Write-Host "┌──────────────────────────────────────────────────────────────┐" -ForegroundColor DarkGray
  Write-Host "│ [ENTER] Apply  [S] Software  [G] GitHub  [O] Open  [M] Menu │" -ForegroundColor DarkGray
  Write-Host "│ [Q] Quit                                                     │" -ForegroundColor DarkGray
  Write-Host "└──────────────────────────────────────────────────────────────┘" -ForegroundColor DarkGray
  Write-Host ""

  $key = [System.Console]::ReadKey($true)
  $keyChar = $key.KeyChar.ToString().ToUpper()

  switch ($keyChar) {
    'Q' {
      Write-Host "`nExiting.`n" -ForegroundColor Cyan
      $continueLoop = $false
    }
    'M' { $startupMenu = $true }
    'S' {
      if (-not (Test-WingetInstalled)) {
        Write-Host "`n✗ winget not found`n" -ForegroundColor Red
        Read-Host "Press ENTER"
      } else {
        $selected = Show-SoftwareSelection -SoftwareMap $softwareMap
        if ($selected -and $selected.Count -gt 0) {
          Write-Host "`n──────────────────────────────────────────────────────────────" -ForegroundColor Cyan
          Write-Host "Installing $($selected.Count) package(s)...`n" -ForegroundColor Cyan
          $success = 0; $failed = 0
          foreach ($app in $selected) {
            Write-Host "  ⟳ $app" -ForegroundColor Yellow
            if (Install-Software -SoftwareName $app -WingetId $softwareMap[$app].WingetId) { $success++ } else { $failed++ }
          }
          Write-Host "`n──────────────────────────────────────────────────────────────" -ForegroundColor Cyan
          Write-Host "✓ Complete! Success: $success | Failed: $failed" -ForegroundColor Green
          Write-Host "──────────────────────────────────────────────────────────────`n" -ForegroundColor Cyan
        }
        Read-Host "Press ENTER"
      }
    }
    'G' {
      Push-ToGitHub -RepositoryPath $dotfilesRoot | Out-Null
      Read-Host "Press ENTER"
    }
    'O' {
      Invoke-Item $dotfilesRoot
      Read-Host "Press ENTER"
    }
  }
}
