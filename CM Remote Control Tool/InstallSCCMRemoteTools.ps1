<#
.SYNOPSIS
    Installs and configures SCCM Remote Tools by copying necessary files, creating required directories, and setting registry entries.

.DESCRIPTION
    This script sets up SCCM Remote Tools by:
    - Creating the required installation directories.
    - Copying necessary files from the script's root directory to the installation location.
    - Configuring registry entries to connect SCCM Remote Tools to the specified SCCM Primary Site Server.
    - Creating a shortcut to the CMRcViewer.exe tool in the Start Menu for user convenience.

.HINT
    Ensure that the required files (RdpCoreSccm.dll, CmRcViewer.exe, and CmRcViewerRes.dll) are available in the same directory as the script.

.RUN AS
    Administrator

.EXAMPLE
    .\InstallSCCMRemoteTools.ps1

    This command runs the script to install and configure SCCM Remote Tools using the provided configuration.

.NOTES
    Author  : Mohammad Abdulkader Omar
    Website : momar.tech
    Date    : 2024-11-04
#>

# Define the Primary Site Server Name for SCCM
$SCCMSiteServer = "SCCM.abc.local"  # Replace with your SCCM site server name

# Define the installation directory for SCCM Remote Tools
$Installdir = "$env:ProgramFiles\CMremoteControl"

# Ensure the installation directory exists; create it if it does not
If (-Not (Test-Path $Installdir)) {
    New-Item -Path $Installdir -ItemType Directory -Force
}

# Ensure the localization subdirectory exists; create it if it does not
If (-Not (Test-Path "$Installdir\00000409")) {
    New-Item -Path "$Installdir\00000409" -ItemType Directory -Force  # Subdirectory for localization
}

# Copy required files to the installation directory
Copy-Item -Path "$PSScriptRoot\RdpCoreSccm.dll" -Destination $Installdir -Force
Copy-Item -Path "$PSScriptRoot\CmRcViewer.exe" -Destination $Installdir -Force
Copy-Item -Path "$PSScriptRoot\00000409\CmRcViewerRes.dll" -Destination "$Installdir\00000409" -Force

# Configure registry entries based on the operating system's architecture
If ([Environment]::Is64BitOperatingSystem) {
    # 64-bit registry updates
    If (-Not (Test-Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\ConfigMgr10")) {
        New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\ConfigMgr10" -Type Directory -Force
    }
    If (-Not (Test-Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\ConfigMgr10\AdminUI")) {
        New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\ConfigMgr10\AdminUI" -Type Directory -Force
    }
    If (-Not (Test-Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\ConfigMgr10\AdminUI\Connection")) {
        New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\ConfigMgr10\AdminUI\Connection" -Type Directory -Force
    }
    New-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\ConfigMgr10\AdminUI\Connection" -Name "Server" -Value $SCCMSiteServer -PropertyType String -Force
} Else {
    # 32-bit registry updates
    If (-Not (Test-Path "HKLM:\SOFTWARE\Microsoft\ConfigMgr10")) {
        New-Item -Path "HKLM:\SOFTWARE\Microsoft\ConfigMgr10" -Type Directory -Force
    }
    If (-Not (Test-Path "HKLM:\SOFTWARE\Microsoft\ConfigMgr10\AdminUI")) {
        New-Item -Path "HKLM:\SOFTWARE\Microsoft\ConfigMgr10\AdminUI" -Type Directory -Force
    }
    If (-Not (Test-Path "HKLM:\SOFTWARE\Microsoft\ConfigMgr10\AdminUI\Connection")) {
        New-Item -Path "HKLM:\SOFTWARE\Microsoft\ConfigMgr10\AdminUI\Connection" -Type Directory -Force
    }
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\ConfigMgr10\AdminUI\Connection" -Name "Server" -Value $SCCMSiteServer -PropertyType String -Force
}

# Create a shortcut to CMrcViewer.exe in the Start Menu
$TargetFile = "$Installdir\cmrcviewer.exe"
$ShortcutFile = "$Env:ProgramData\Microsoft\Windows\Start Menu\Programs\Remote control.lnk"
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
$Shortcut.TargetPath = $TargetFile
$Shortcut.Save()

# Script completed successfully
Write-Output "SCCM Remote Tools have been successfully installed and configured."
