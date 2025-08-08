function Get-SystemInfo {
    # OS Info
    $os = Get-CimInstance Win32_OperatingSystem
    $osName = $os.Caption
    $osVersion = $os.Version

    # Computer Name
    $computerName = $env:COMPUTERNAME

    # Uptime
    $uptimeSpan = (Get-Date) - $os.LastBootUpTime
    $uptime = "{0}d {1}h {2}m" -f $uptimeSpan.Days, $uptimeSpan.Hours, $uptimeSpan.Minutes

    # CPU Info
    $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
    $cpuName = $cpu.Name.Trim()

    # RAM Info
    $totalRamGB = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
    $freeRamGB = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
    $usedRamGB = [math]::Round($totalRamGB - $freeRamGB, 2)

    # Disk Usage (C:)
    $disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
    $totalDiskGB = [math]::Round($disk.Size / 1GB, 2)
    $freeDiskGB = [math]::Round($disk.FreeSpace / 1GB, 2)
    $usedDiskGB = [math]::Round($totalDiskGB - $freeDiskGB, 2)

    # Username
    $userName = $env:USERNAME

    # Colorized output helper
    function Write-Color ($Text, $Color = "White") {
        Write-Host $Text -ForegroundColor $Color
    }

    # Windows 11 style ASCII logo using pipes and dashes
    $win11Logo = @"
  ┌───────┬───────┐
  │       │       │
  │       │       │
  ├───────┼───────┤
  │       │       │
  │       │       │
  └───────┴───────┘
"@

    Write-Color $win11Logo Cyan
    Write-Color "User:       $userName" Yellow
    Write-Color "Host:       $computerName" Yellow
    Write-Color "OS:         $osName ($osVersion)" Green
    Write-Color "Uptime:     $uptime" Green
    Write-Color "CPU:        $cpuName" Magenta
    Write-Color "RAM:        $usedRamGB GB / $totalRamGB GB" Cyan
    Write-Color "Disk (C:):  $usedDiskGB GB / $totalDiskGB GB" Cyan
}

Get-SystemInfo
