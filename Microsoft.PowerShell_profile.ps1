
# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

function Prompt {
    # Get the current time
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

    # Get the username (or custom identifier)
    $username = "Senpai"

    # Get the current directory
    $workingDir = Get-Location

    # Determine if the shell is running as admin
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    # Set the colors
    $contentColor = if ($isAdmin) { [ConsoleColor]::Red } else { [ConsoleColor]::Cyan }
    $white = [ConsoleColor]::White

    # Build the prompt line by line
    # Line 1: ┌─[Current Time]-[Local IP]-[Username]-[Working dir]
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
    Write-Host ($(if ($isAdmin) { "*" } else { "$" }) ) -ForegroundColor $contentColor -NoNewline

    return " "
}

