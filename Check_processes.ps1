# CheckProcesses.ps1

function Show-Processes {
    param(
        [string]$Filter = ""
    )
    if ($Filter -eq "") {
        Get-Process | Sort-Object CPU -Descending | Format-Table -AutoSize -Property Id, ProcessName, CPU, WS
    } else {
        Get-Process | Where-Object { $_.ProcessName -like "*$Filter*" } | Sort-Object CPU -Descending | Format-Table -AutoSize -Property Id, ProcessName, CPU, WS
    }
}

Write-Host "PowerShell Process Viewer" -ForegroundColor Cyan
Write-Host "---------------------------`n"

do {
    $filter = Read-Host "Enter process name filter (or press Enter to list all, type 'exit' to quit)"
    if ($filter -ne "exit") {
        Show-Processes -Filter $filter
        Write-Host "`n"
    }
} while ($filter -ne "exit")

Write-Host "Exiting Process Viewer. Goodbye!" -ForegroundColor Green
