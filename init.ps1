# Creating Directories
$backupDir = "$env:USERPROFILE\.dotfiles\_backups"
$configDir = "$env:USERPROFILE\.dotfiles\configs"

foreach ($dir in @($backupDir, $configDir)) {
  if (-not (Test-Path $dir)) {
    New-Item -ItemType Directory -Path $dir | Out-Null
    Write-Host "Created directory: $dir"
  }
}

# Config Definition: "Target" = "LinkLocation"
$configMap = @{
  "$env:USERPROFILE\.config\yasb\config.yaml"                              = "$configDir\yasb\config.yaml"
  "$env:USERPROFILE\.config\yasb\styles.css"                               = "$configDir\yasb\styles.css"
  "$env:APPDATA\Code\User\settings.json"                                   = "$configDir\vscode\settings.json"
  "$env:APPDATA\Code\User\keybindings.json"                                = "$configDir\vscode\keybindings.json"
  "$env:APPDATA\Code\User\snippets\"                                       = "$configDir\vscode\snippets\"
  "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" = "$configDir\pwsh\Microsoft.PowerShell_profile.ps1"
  "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\Settings.json" = "$configDir\wt\settings.json"
}

foreach ($target in $configMap.Keys) {
  $source = $configMap[$target]
  $fileName = Split-Path $target -Leaf
  $backupPath = Join-Path $backupDir $fileName

  $item = Get-Item $target -ErrorAction SilentlyContinue

  if ($item -and $item.Attributes -notmatch 'ReparsePoint') {
    if (-not (Test-Path $backupPath)) {
      if ((Test-Path $backupPath) -and ((Get-Item $path).PSIsContainer)) {
        Move-Item $target $backupPath -Recurse -Force
      } else {
        Move-Item $target $backupPath -Force
      }
      Write-Host "Moved backup: $target → $backupPath"
    }
    else {
      Write-Host "Backup already exists at $backupPath. Skipping."
      continue
    }
  }

  New-Item -ItemType SymbolicLink -Path $target -Target $source -Force
  Write-Host "Linked: $target -> $source"

}
