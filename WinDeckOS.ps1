# Define variables
# Define the path to the file and the startup shortcut
$FilePath = "C:\Windows\WinDeckOS\explorer.bat"
$EStartupShortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\Explorer.bat.lnk"

# Verify that the target file exists
if (-Not (Test-Path -Path $FilePath)) {
    Write-Error "The file '$FilePath' does not exist. Aborting startup entry creation."
    return
}

# Create the startup shortcut
Write-Host "Creating startup entry for '$FilePath'..."
$Shell = New-Object -ComObject WScript.Shell
$Shortcut = $Shell.CreateShortcut($EStartupShortcutPath)
$Shortcut.TargetPath = $FilePath
$Shortcut.WorkingDirectory = (Split-Path -Path $FilePath)
$Shortcut.Save()

Write-Host "Startup entry created at '$EStartupShortcutPath'."
Start-Process -FilePath $EStartupShortcutPath


$SteamInstallerUrl = "https://cdn.akamai.steamstatic.com/client/installer/SteamSetup.exe"
$InstallerPath = "$env:TEMP\SteamSetup.exe"
$StartupShortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\Steam Big Picture.url"

# Create the startup shortcut
Write-Host "Creating startup shortcut for Steam Big Picture mode..."
$Shortcut = @"
[InternetShortcut]
URL=steam://open/bigpicture
IconFile=$env:ProgramFiles(x86)\Steam\Steam.exe
IconIndex=0
"@

# Download the Steam installer
Write-Host "Downloading Steam installer..."
Invoke-WebRequest -Uri $SteamInstallerUrl -OutFile $InstallerPath -UseBasicParsing

# Run the installer
Write-Host "Running Steam installer..."
Start-Process -FilePath $InstallerPath -Wait



# Save the shortcut to the Startup folder
$Shortcut | Set-Content -Path $StartupShortcutPath -Encoding ASCII

Write-Host "Steam installation and startup configuration complete."

Restart-Computer