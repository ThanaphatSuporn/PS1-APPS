# Kill process by name
param (
    [string]$name
)

if (-not $name) {
    Write-Host "Please provide a process name. Usage: .\script.ps1 -name processname"
    exit
}

Get-Process -Name $name -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Host "Stopping process: $($_.ProcessName) (ID: $($_.Id))"
    Stop-Process -Id $_.Id -Force
}

Write-Host "Done."
