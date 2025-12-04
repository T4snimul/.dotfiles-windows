# PowerShell Profile Script - Optimized and Fast

# Initialize stopwatch for performance tracking
$global:__stopwatch = $null
$global:__lastExecutionTime = 0

# Fast PSReadLine setup
Set-PSReadLineOption -EditMode Vi
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -MaximumHistoryCount 4096
Set-PSReadLineOption -ContinuationPrompt "❯"
Register-EngineEvent PowerShell.OnIdle -Action {
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
} | Out-Null

# ===== Utility Functions =====

# Get git status efficiently
function Get-GitStatus {
    $repoPath = Get-Location
    $gitDir = Join-Path $repoPath ".git"

    if (-not (Test-Path $gitDir)) {
        return $null
    }

    try {
        $branch = git rev-parse --abbrev-ref HEAD 2>$null
        $status = git status --porcelain 2>$null

        if ([string]::IsNullOrWhiteSpace($status)) {
            return @{ branch = $branch; dirty = $false }
        }
        else {
            return @{ branch = $branch; dirty = $true }
        }
    }
    catch {
        return $null
    }
}

# Format git status for display
function Format-GitStatus {
    param([hashtable]$GitStatus)

    if (-not $GitStatus) { return "" }

    $branch = $GitStatus.branch
    $isDirty = $GitStatus.dirty

    if ($isDirty) {
        return " ·git: $branch*"
    }
    else {
        return " ·git: $branch"
    }
}

# Format execution time nicely
function Format-ExecutionTime {
    param([int]$Milliseconds)

    if ($Milliseconds -lt 1000) {
        return "${Milliseconds}ms"
    }
    else {
        $seconds = [math]::Round($Milliseconds / 1000, 2)
        return "${seconds}s"
    }
}

# ===== Prompt Function =====
function Prompt {
    # Start timing for next command
    if ($global:__stopwatch) {
        $global:__lastExecutionTime = $global:__stopwatch.ElapsedMilliseconds
        $global:__stopwatch.Stop()
    }

    $global:__stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

    # Get current time, folder, and git status
    $time = Get-Date -Format "HH:mm:ss"
    $folder = Split-Path -Leaf (Get-Location)
    $folder = if ([string]::IsNullOrEmpty($folder)) { "~" } else { $folder }
    $gitStatus = Get-GitStatus

    # Build info line (top)
    Write-Host "┌─ " -NoNewline -ForegroundColor DarkGray
    Write-Host "$time" -NoNewline -ForegroundColor Cyan
    Write-Host " • " -NoNewline -ForegroundColor DarkGray
    Write-Host $folder -NoNewline -ForegroundColor White

    # Add git info if available
    if ($gitStatus) {
        $branch = $gitStatus.branch
        $isDirty = $gitStatus.dirty
        $gitColor = if ($isDirty) { [ConsoleColor]::Yellow } else { [ConsoleColor]::Green }
        $gitSymbol = if ($isDirty) { "◆" } else { "●" }
        Write-Host " $gitSymbol " -NoNewline -ForegroundColor $gitColor
        Write-Host $branch -NoNewline -ForegroundColor $gitColor
    }

    # Add execution time if available
    if ($global:__lastExecutionTime -gt 0) {
        Write-Host " • " -NoNewline -ForegroundColor DarkGray
        Write-Host "$(Format-ExecutionTime -Milliseconds $global:__lastExecutionTime)" -NoNewline -ForegroundColor Magenta
    }

    Write-Host ""

    # Build prompt line (bottom) with input cursor
    Write-Host "└─ " -NoNewline -ForegroundColor DarkGray
    Write-Host "❯ " -NoNewline -ForegroundColor Cyan

    return ""
}

# ===== Aliases for Convenience =====
function lt { cmd /c tree /F }
function la { Get-ChildItem -Force }

# Quick navigation
function ll { Get-ChildItem -Force -Recurse }
function cd.. { Set-Location .. }

# Git shortcuts
function gst { git status }
function gad { git add . }
function gcm { param([string]$msg); git commit -m $msg }
function glog { git log --oneline -10 }

# ===== Zoxide Integration =====
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# End of profile
