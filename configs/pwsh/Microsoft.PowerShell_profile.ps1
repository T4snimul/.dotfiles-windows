# PowerShell Profile Script

# Menu
Register-EngineEvent PowerShell.OnIdle -Action {
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
} | Out-Null

# Prompt
function Prompt {
    # Helper: shorten long paths, keep last 3 folders max
    function Shorten-Path($path, $maxParts = 1) {
        $parts = $path -split '[\\/]+'
        if ($parts.Length -le $maxParts) { return $path }
        $shortParts = @()
        $skipCount = $parts.Length - $maxParts
        $shortParts += $parts[$skipCount..($parts.Length - 1)]
        return ($shortParts)
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
    $colorIcon = [ConsoleColor]::Red
    $colorPath = [ConsoleColor]::White
    $colorBranch = [ConsoleColor]::Green
    $colorPrompt = [ConsoleColor]::Magenta

    # Write status bar line
    Write-Host (" ") -NoNewline -ForegroundColor $colorIcon -BackgroundColor Black
    Write-Host ($shortPath) -NoNewline -ForegroundColor $colorPath -BackgroundColor Black
    Write-Host ($branch + " ") -NoNewline -ForegroundColor $colorBranch -BackgroundColor Black
    Write-Host ""

    # Write prompt sign
    Write-Host "❯" -NoNewline -ForegroundColor $colorPrompt

    return " "
}


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

