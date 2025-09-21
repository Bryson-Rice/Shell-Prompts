[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

function Prompt {

    $currentTime = Get-Date -Format "HH:mm"

    # Get the LAN IP address starting with "10.0"
    $localIP = (Get-NetIPAddress -AddressFamily IPv4 |
                Where-Object { 
                    $_.InterfaceAlias -notmatch 'Loopback|Tunnel|VPN' -and 
                    $_.IPAddress -match '^10\.0\.' 
                } |
                Select-Object -ExpandProperty IPAddress -First 1)

    # Fallback if no LAN IP is found
    if (-not $localIP) { $localIP = "No LAN IP" }

    $username = "Artemis"

    $workingDir = Get-Location

    # Determine if the shell is running as admin
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    # Set the colors
    $contentColor = if ($isAdmin) { [ConsoleColor]::Red } else { [ConsoleColor]::Cyan }
    $white = [ConsoleColor]::White

    # Build the prompt line by line
    # Line 1: ┌─{Current Time]-[Local IP]-[Username]-[Working dir]
    
    # This is always weird to get working, you may have to force the file to UTF-8 using these commands
    # $path = $PROFILE
    # $content = Get-Content -Raw -Path $path
    # [System.IO.File]::WriteAllText($path, $content, [System.Text.Encoding]::UTF8)
    
    Write-Host "┌─" -ForegroundColor $white -NoNewline
    Write-Host "[" -ForegroundColor $white -NoNewline
    Write-Host "$currentTime" -ForegroundColor $contentColor -NoNewline
    Write-Host "]" -ForegroundColor $white -NoNewline
    Write-Host "-[" -ForegroundColor $white -NoNewline
    Write-Host "$localIP" -ForegroundColor $contentColor -NoNewline
    Write-Host "]" -ForegroundColor $white -NoNewline
    Write-Host "-[" -ForegroundColor $white -NoNewline
    Write-Host "$username" -ForegroundColor $contentColor -NoNewline
    Write-Host "]" -ForegroundColor $white -NoNewline
    Write-Host "-[" -ForegroundColor $white -NoNewline
    Write-Host "$workingDir" -ForegroundColor $contentColor -NoNewline
    Write-Host "]" -ForegroundColor $white

    # Line 2: └───$ or └───* (red if admin, cyan if normal)
    Write-Host "└───" -ForegroundColor $white -NoNewline
    Write-Host ($(if ($isAdmin) { "★" } else { "$" }) ) -ForegroundColor $contentColor -NoNewline

    return " "
}

Prompt
