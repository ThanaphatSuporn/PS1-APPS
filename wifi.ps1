# Wi-Fi Password Retriever Script

# Get all saved Wi-Fi profiles
$profiles = netsh wlan show profiles | Select-String "All User Profile" | ForEach-Object {
    ($_ -split ":")[1].Trim()
}

if ($profiles.Count -eq 0) {
    Write-Output "No Wi-Fi profiles found."
    exit
}

foreach ($prof in $profiles) {
    Write-Output "Profile: $prof"
    # Get the key (password) for the profile
    $key = netsh wlan show profile name="$prof" key=clear | Select-String "Key Content" | ForEach-Object {
        ($_ -split ":")[1].Trim()
    }

    Write-Output "------------------------------"
    
    if ($key) {
        Write-Output "Password: $key"
    } else {
        Write-Output "Password: <None or Not Available>"
    }
    Write-Output "------------------------------"
}
