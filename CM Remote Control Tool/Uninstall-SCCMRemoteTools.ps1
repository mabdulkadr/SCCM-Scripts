<#
.SYNOPSIS
    Uninstalls the Configuration Manager Remote Tools client standalone installation.

.DESCRIPTION
    This script performs a complete removal of the SCCM Remote Tools client, including:
    - Deleting the installation directory.
    - Removing registry entries related to the Configuration Manager Remote Tools client.
    - Deleting the Start Menu shortcut for the Remote Control tool.

    The script automatically handles both 32-bit and 64-bit operating systems by targeting the appropriate registry paths.

.NOTES
    Author  : Mohammad Abdulkader Omar
    Website : momar.tech
    Date    : 2024-11-04

.EXAMPLE
    .\Uninstall-SCCMRemoteTools.ps1

    This command runs the script to completely uninstall the SCCM Remote Tools client from the system.

#>

# Define the installation directory for SCCM Remote Tools
$Installdir = "$env:ProgramFiles\CMremoteControl"

# Remove the installation directory and all its contents
If (Test-Path $Installdir) {
    Remove-Item -Path $Installdir -Recurse -Force
    Write-Output "Removed installation directory: $Installdir"
}

# Remove related registry entries based on the operating system's architecture
If ([Environment]::Is64BitOperatingSystem) {
    # For 64-bit systems, remove registry entries under Wow6432Node
    If (Test-Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\ConfigMgr10") {
        Remove-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\ConfigMgr10" -Recurse -Force
        Write-Output "Removed 64-bit registry entries for SCCM Remote Tools."
    }
} Else {
    # For 32-bit systems, remove registry entries under the standard path
    If (Test-Path "HKLM:\SOFTWARE\Microsoft\ConfigMgr10") {
        Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\ConfigMgr10" -Recurse -Force
        Write-Output "Removed 32-bit registry entries for SCCM Remote Tools."
    }
}

# Remove the Start Menu shortcut for Remote Control
$ShortcutPath = "$Env:ProgramData\Microsoft\Windows\Start Menu\Remote control.lnk"
If (Test-Path $ShortcutPath) {
    Remove-Item -Path $ShortcutPath -Force
    Write-Output "Removed Start Menu shortcut: $ShortcutPath"
}

# Script completed successfully
Write-Output "SCCM Remote Tools client has been successfully uninstalled."
