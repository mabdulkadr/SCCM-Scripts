<#
.SYNOPSIS
    Repairs the SCCM client agent using the built-in CCMRepair tool.

.DESCRIPTION
    This script launches the `ccmrepair.exe` utility located in the default SCCM client directory
    (C:\Windows\CCM) to perform a repair of the local Configuration Manager client installation.

    It logs the action, checks if the repair tool exists, and ensures elevated execution.

.EXAMPLE
    .\Repair-SCCMClient.ps1

.NOTES
    Author  : Mohammad Abdulkader Omar
    Website : momar.tech
    Date    : 2025-07-01
    Version : 1.0
#>

# Ensure script runs with elevated permissions
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "⚠️ This script must be run as Administrator." -ForegroundColor Red
    exit 1
}

# Define log path
$LogPath = "C:\SCCMClientRepair.log"

Function Write-Log {
    param (
        [string]$Message,
        [ValidateSet("INFO", "SUCCESS", "ERROR", "WARNING")]
        [string]$Level = "INFO"
    )

    $Time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "$Time [$Level] : $Message"
    Add-Content -Path $LogPath -Value $LogEntry

    switch ($Level) {
        "INFO"    { Write-Host $LogEntry -ForegroundColor Cyan }
        "SUCCESS" { Write-Host $LogEntry -ForegroundColor Green }
        "WARNING" { Write-Host $LogEntry -ForegroundColor Yellow }
        "ERROR"   { Write-Host $LogEntry -ForegroundColor Red }
    }
}

# Path to ccmrepair
$CCMRepairPath = "C:\Windows\CCM\ccmrepair.exe"

if (Test-Path $CCMRepairPath) {
    Write-Log "Found ccmrepair.exe at $CCMRepairPath. Initiating repair..." "INFO"
    try {
        Start-Process -FilePath $CCMRepairPath -WindowStyle Hidden -Wait
        Write-Log "SCCM client repair process completed successfully." "SUCCESS"
    } catch {
        Write-Log "Failed to launch ccmrepair.exe. Error: $_" "ERROR"
    }
} else {
    Write-Log "ccmrepair.exe not found. SCCM client may not be installed properly." "ERROR"
}

