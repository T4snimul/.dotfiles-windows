# Check if 'lsd' is installed
if (Get-Command lsd -ErrorAction SilentlyContinue) {
    # General alias: acts like basic 'ls'
    Set-Alias ls lsd

    # Long listing, human-readable sizes, show all files, group dirs
    function ll {
        lsd -l --all --group-dirs first --color=always
    }

    # Tree view, depth 2, hidden files, grouped dirs
    function lt {
        lsd --tree --depth 2 --all --group-dirs first --color=always
    }

    # Show current dir with icons but no details
    function l {
        lsd --group-dirs first --color=always
    }

    # Git-aware listing (optional bonus with starship prompt or custom logic)
    function lg {
        if (Test-Path .git) {
            Write-Host "[GIT REPO]" -ForegroundColor Green
        }
        lsd -l --all --group-dirs first
    }

    # Show only directories
    function lsd-dirs {
        lsd -l --all --group-dirs first -d */
    }
}
else {
    Write-Host "⚠️ LSD not found. Please install it to use the custom aliases." -ForegroundColor Yellow
}

