# Universal PATH Adder
# Works regardless of "Path" or "PATH" casing
# Run as Administrator for system scope changes

param (
    [string]$NewPath,
    [switch]$User,    # Add to user PATH
    [switch]$System   # Add to system PATH
)

if (-not $NewPath) {
    $NewPath = Read-Host "Enter the full folder path to add to PATH"
}

if (-not (Test-Path $NewPath)) {
    Write-Host "❌ The path does not exist: $NewPath" -ForegroundColor Red
    exit
}

function Add-ToPath {
    param ($Scope, $PathToAdd)

    $currentPath = [Environment]::GetEnvironmentVariable("Path", $Scope)

    # Normalize separators
    $normalizedPath = $PathToAdd.TrimEnd('\')

    if ($currentPath -match [Regex]::Escape($normalizedPath)) {
        Write-Host "⚠️ '$normalizedPath' is already in $Scope PATH." -ForegroundColor Yellow
    } else {
        $newValue = "$currentPath;$normalizedPath"
        [Environment]::SetEnvironmentVariable("Path", $newValue, $Scope)
        Write-Host "✅ Added '$normalizedPath' to $Scope PATH." -ForegroundColor Green
    }
}

if (-not $User -and -not $System) {
    # Default: add to both
    Add-ToPath "User" $NewPath
    Add-ToPath "Machine" $NewPath
} else {
    if ($User) { Add-ToPath "User" $NewPath }
    if ($System) { Add-ToPath "Machine" $NewPath }
}

Write-Host "`nUpdated User PATH:" -ForegroundColor Cyan
[Environment]::GetEnvironmentVariable("Path", "User")

Write-Host "`nUpdated System PATH:" -ForegroundColor Cyan
[Environment]::GetEnvironmentVariable("Path", "Machine")
