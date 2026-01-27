# Windows Firewall – Minimal Wi-Fi Essentials (Windows 11 25H2)

function Add-RuleIfMissing {
    param (
        [string]$Name,
        [scriptblock]$Rule
    )
    if (-not (Get-NetFirewallRule -DisplayName $Name -ErrorAction SilentlyContinue)) {
        & $Rule
    }
}

# 1) Core Windows services
Add-RuleIfMissing "Allow svchost (core Windows)" {
    New-NetFirewallRule `
        -DisplayName "Allow svchost (core Windows)" `
        -Direction Outbound `
        -Program "C:\Windows\System32\svchost.exe" `
        -Action Allow `
        -Profile Domain,Private,Public
}

# 2) DNS
Add-RuleIfMissing "Allow DNS UDP" {
    New-NetFirewallRule `
        -DisplayName "Allow DNS UDP" `
        -Direction Outbound `
        -Protocol UDP `
        -RemotePort 53 `
        -Action Allow `
        -Profile Domain,Private,Public
}

Add-RuleIfMissing "Allow DNS TCP" {
    New-NetFirewallRule `
        -DisplayName "Allow DNS TCP" `
        -Direction Outbound `
        -Protocol TCP `
        -RemotePort 53 `
        -Action Allow `
        -Profile Domain,Private,Public
}

# 3) DHCP (UDP 68 → 67)
Add-RuleIfMissing "Allow DHCP" {
    New-NetFirewallRule `
        -DisplayName "Allow DHCP" `
        -Direction Outbound `
        -Protocol UDP `
        -LocalPort 68 `
        -RemotePort 67 `
        -Action Allow `
        -Profile Domain,Private,Public
}

# 4) Network connectivity / captive portal detection
Add-RuleIfMissing "Allow Network Connectivity Status" {
    New-NetFirewallRule `
        -DisplayName "Allow Network Connectivity Status" `
        -Direction Outbound `
        -Program "C:\Windows\System32\ncsi.exe" `
        -Action Allow `
        -Profile Domain,Private,Public
}

# 5) Windows Update (Private + Domain only)
Add-RuleIfMissing "Allow Windows Update (UsoClient)" {
    New-NetFirewallRule `
        -DisplayName "Allow Windows Update (UsoClient)" `
        -Direction Outbound `
        -Program "C:\Windows\System32\UsoClient.exe" `
        -Action Allow `
        -Profile Domain,Private
}

Add-RuleIfMissing "Allow Windows Update (MoUsoCoreWorker)" {
    New-NetFirewallRule `
        -DisplayName "Allow Windows Update (MoUsoCoreWorker)" `
        -Direction Outbound `
        -Program "C:\Windows\System32\MoUsoCoreWorker.exe" `
        -Action Allow `
        -Profile Domain,Private
}
