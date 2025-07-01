<#
.SYNOPSIS
    Automates key SCCM client actions and Windows Update compliance reporting.

.DESCRIPTION
    This script performs several administrative tasks to ensure that the SCCM (System Center Configuration Manager) client
    is functioning properly and reporting up-to-date information to the SCCM server. It includes the following actions:

    1. Checks and sets the PowerShell execution policy to 'Unrestricted' if not currently set to 'Restricted'.
    2. Triggers a variety of SCCM client schedule actions such as:
        - Application Deployment Evaluation
        - Machine Policy Evaluation
        - Software Updates Scan and Evaluation
        - Hardware and Software Inventory
        - Compliance and Discovery Data Collection
    3. Executes COM-based methods to refresh the server compliance state.
    4. Initiates Windows Update Agent actions including:
        - Authorization reset and detection
        - Compliance reporting

    All actions are logged to a file located at C:\Windows\Temp with color-coded console output for visibility.

.NOTES
    Author  : Mohammad Abdulkader Omar
    Website : momar.tech
    Date    : 2025-07-01
#>

# Check and set execution policy if necessary
$currentPolicy = Get-ExecutionPolicy
if ($currentPolicy -ne 'Restricted') {
    Write-Host "Current Execution Policy is: $currentPolicy. Changing to Unrestricted..." -ForegroundColor Yellow
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force
    Write-Host "Execution Policy changed to Unrestricted." -ForegroundColor Green
} else {
    Write-Host "Current Execution Policy is Restricted. No changes made." -ForegroundColor Cyan
}

# Define log file path
$logFile = "C:\SCCM_Client_Actions_Log.txt"

# Write-Log function: Logs messages with timestamp and colored output
Function Write-Log {
    param (
        [string]$message,
        [string]$type = "info"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp : $message"
    $logMessage | Out-File -Append -FilePath $logFile

    switch ($type) {
        "success" { Write-Host $logMessage -ForegroundColor Green }
        "error"   { Write-Host $logMessage -ForegroundColor Red }
        "warning" { Write-Host $logMessage -ForegroundColor Yellow }
        default   { Write-Host $logMessage -ForegroundColor White }
    }
}

# Function to trigger SCCM client scheduled actions by Schedule ID
Function Trigger-Schedule {
    param (
        [string]$ScheduleID,
        [string]$Description
    )
    try {
        [void]([wmiclass]'ROOT\ccm:SMS_Client').TriggerSchedule($ScheduleID)
        Write-Log "$Description triggered successfully." "success"
    } catch {
        Write-Log "Failed to trigger $Description. Error: $_" "error"
    }
}

# Define which SCCM actions to run
$TriggerAppDeploymentEvaluation    = $true
$TriggerMachinePolicyEvaluation    = $true
$TriggerSoftwareUpdatesScan        = $true
$TriggerSoftwareUpdatesEvaluation  = $true
$TriggerHardwareInventory          = $true
$TriggerSoftwareInventory          = $true
$TriggerComplianceEvaluation       = $true
$TriggerDiscoveryDataCollection    = $true

Write-Log "=== Starting SCCM Client Actions ===" "info"

# 1. Application Deployment Evaluation
if ($TriggerAppDeploymentEvaluation) {
    Write-Log "Starting Application Deployment Evaluation..." "info"
    Trigger-Schedule -ScheduleID '{00000000-0000-0000-0000-000000000121}' -Description "Application Deployment Evaluation"
}

# 2. Machine Policy Retrieval & Evaluation
if ($TriggerMachinePolicyEvaluation) {
    Write-Log "Starting Machine Policy Evaluation..." "info"
    Trigger-Schedule -ScheduleID '{00000000-0000-0000-0000-000000000021}' -Description "Machine Policy Retrieval & Evaluation Cycle"
}

# 3. Software Updates Scan
if ($TriggerSoftwareUpdatesScan) {
    Write-Log "Starting Software Updates Scan..." "info"
    Trigger-Schedule -ScheduleID '{00000000-0000-0000-0000-000000000113}' -Description "Software Updates Scan Cycle"
}

# 4. Software Updates Deployment Evaluation
if ($TriggerSoftwareUpdatesEvaluation) {
    Write-Log "Starting Software Updates Deployment Evaluation..." "info"
    Trigger-Schedule -ScheduleID '{00000000-0000-0000-0000-000000000108}' -Description "Software Updates Deployment Evaluation Cycle"
}

# 5. Hardware Inventory
if ($TriggerHardwareInventory) {
    Write-Log "Starting Hardware Inventory Collection..." "info"
    Trigger-Schedule -ScheduleID '{00000000-0000-0000-0000-000000000101}' -Description "Hardware Inventory Collection Cycle"
}

# 6. Software Inventory
if ($TriggerSoftwareInventory) {
    Write-Log "Starting Software Inventory Collection..." "info"
    Trigger-Schedule -ScheduleID '{00000000-0000-0000-0000-000000000102}' -Description "Software Inventory Collection Cycle"
}

# 7. Compliance Evaluation
if ($TriggerComplianceEvaluation) {
    Write-Log "Starting Compliance Evaluation Cycle..." "info"
    Trigger-Schedule -ScheduleID '{00000000-0000-0000-0000-000000000131}' -Description "Compliance Evaluation Cycle"
}

# 8. Discovery Data Collection
if ($TriggerDiscoveryDataCollection) {
    Write-Log "Starting Discovery Data Collection..." "info"
    Trigger-Schedule -ScheduleID '{00000000-0000-0000-0000-000000000003}' -Description "Discovery Data Collection Cycle"
}

# Refresh server compliance state via COM object
Write-Log "Initiating full update scan and deployment evaluation..." "info"
try {
    (New-Object -ComObject Microsoft.CCM.UpdatesStore).RefreshServerComplianceState()
    Write-Log "Server compliance state refreshed." "success"
} catch {
    Write-Log "Failed to refresh server compliance state. Error: $_" "error"
}

# Force Windows Update Agent to reset authorization and detect new updates
Write-Log "Forcing Windows Update Agent to reset authorization and detect new updates..." "info"
try {
    Start-Process -FilePath 'wuauclt.exe' -ArgumentList '/ResetAuthorization /DetectNow' -NoNewWindow
    Write-Log "Windows Update Agent - Reset Authorization and Detection triggered." "success"
} catch {
    Write-Log "Failed to reset and detect updates. Error: $_" "error"
}

# Force Windows Update Agent to report compliance
Write-Log "Forcing Windows Update Agent to report compliance..." "info"
try {
    Start-Process -FilePath 'wuauclt.exe' -ArgumentList '/reportnow' -NoNewWindow
    Write-Log "Windows Update Agent - Report Now initiated." "success"
} catch {
    Write-Log "Failed to report compliance. Error: $_" "error"
}

Write-Log "=== SCCM Client Actions Script Completed ===" "success"
