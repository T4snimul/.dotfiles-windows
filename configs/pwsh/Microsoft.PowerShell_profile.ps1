# PowerShell Profile Script

# Menu
Register-EngineEvent PowerShell.OnIdle -Action {
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
} | Out-Null

# Prompt
function Prompt {

    # Get current folder name only
    $folder = Split-Path -Leaf (Get-Location)

    # Color settings
    $colorFolder = [ConsoleColor]::White
    $colorPrompt = [ConsoleColor]::Red
    $colorIcon = [ConsoleColor]::Red
    $background = [ConsoleColor]::Black

    # Powerline icon
    Write-Host (" ") -NoNewline -ForegroundColor $colorIcon -BackgroundColor $background

    # Folder name
    Write-Host ($folder + " ") -ForegroundColor $colorFolder -BackgroundColor $background

    # Prompt symbol
    Write-Host "❯" -NoNewline -ForegroundColor $colorPrompt

    return " "
}

Set-PSReadLineOption -ContinuationPrompt "❯" 

# Aliases for convenience
function lt {
    cmd /c tree /F
}

function la {
    Get-ChildItem -Force
}

# PSReadLine options for better experience
Set-PSReadLineOption -EditMode Vi
Set-PSReadLineOption -PredictionSource History

# Optional: Increase history size
Set-PSReadLineOption -MaximumHistoryCount 4096

# Zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })


# End of profile

