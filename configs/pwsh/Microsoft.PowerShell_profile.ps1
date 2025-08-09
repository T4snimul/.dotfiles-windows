# PowerShell Profile Script

# Imports
Import-Module PSReadLine -ErrorAction SilentlyContinue

# Prompt
function Prompt {
    # Helper: shorten long paths, keep last 3 folders max
    function Shorten-Path($path, $maxParts = 1) {
        $parts = $path -split '[\\/]+'
        if ($parts.Length -le $maxParts) { return $path }
        $shortParts = @()
        $skipCount = $parts.Length - $maxParts
        $shortParts += '...'
        $shortParts += $parts[$skipCount..($parts.Length - 1)]
        return ($shortParts -join '\')
    }

    # Get current path, shorten if needed
    $path = (Get-Location).Path
    $shortPath = Shorten-Path $path

    # Get Git branch if in git repo
    $branch = ''
    if (Get-Command git -ErrorAction SilentlyContinue) {
        try {
            $branchName = (& git rev-parse --abbrev-ref HEAD 2>$null)
            if ($branchName -and $branchName -ne 'HEAD') {
                $branch = " [$branchName]"
            }
        } catch {}
    }

    # Colors
    $colorPath = [ConsoleColor]::Cyan
    $colorTime = [ConsoleColor]::Yellow
    $colorBranch = [ConsoleColor]::Green
    $colorMode = [ConsoleColor]::Magenta
    $colorPrompt = [ConsoleColor]::White

    # Write status bar line
    Write-Host (" " + $shortPath + $branch + " ") -NoNewline -ForegroundColor $colorPath -BackgroundColor Black
    Write-Host ""

    # Write prompt sign
    Write-Host "❯ " -NoNewline -ForegroundColor $colorPrompt

    return " "
}


# Keybinding for menu autocomplete (Ctrl+J)
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

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

# End of profile

