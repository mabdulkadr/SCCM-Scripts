<#
.SYNOPSIS
    Safely removes all contents of the MachineKeys folder used by Windows cryptographic services to fix SCCM client certificate issues.

.DESCRIPTION
    - Validates MachineKeys folder existence.
    - Backs up MachineKeys content.
    - Takes ownership of files.
    - Grants full access to Administrators.
    - Deletes files.
    - Restarts SCCM Client service (ccmexec).
    - Waits and instructs for certificate regeneration.

.NOTES
    Author  : Mohammad Abdulkader Omar
    Website : momar.tech
    Date    : 2025-04-08
#>

# === Configuration ===
$machineKeysPath = "C:\ProgramData\Microsoft\Crypto\RSA\MachineKeys"
$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$backupPath = "C:\ProgramData\Microsoft\Crypto\RSA\Backup_MachineKeys_$timestamp"
$ccmService = "ccmexec"

# === Admin Check ===
if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit 1
}

# === Folder Existence Check ===
if (-not (Test-Path $machineKeysPath)) {
    Write-Host "Folder not found: $machineKeysPath" -ForegroundColor Red
    Write-Host "Please ensure this path exists on your system. Exiting script..." -ForegroundColor Yellow
    exit 1
}

# === Backup MachineKeys ===
Write-Host "`nWARNING: This will delete all MachineKeys files after backup and ownership change!" -ForegroundColor Red
Start-Sleep -Seconds 2

Write-Host "Backing up MachineKeys to: $backupPath" -ForegroundColor Yellow
try {
    New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
    Copy-Item -Path $machineKeysPath -Destination $backupPath -Recurse -Force -ErrorAction Stop
    Write-Host "Backup completed successfully." -ForegroundColor Green
} catch {
    Write-Host "Backup failed: $_" -ForegroundColor Red
    exit 1
}

# === Take Ownership and Delete Files ===
Write-Host "`nTaking ownership and deleting files..." -ForegroundColor Cyan
$files = Get-ChildItem -Path $machineKeysPath -Force

foreach ($file in $files) {
    try {
        takeown /F $file.FullName /A /R /D Y | Out-Null
        icacls $file.FullName /grant "Administrators:F" /T /C | Out-Null
        Remove-Item $file.FullName -Force -ErrorAction Stop
        Write-Host "Deleted: $($file.Name)" -ForegroundColor Green
    } catch {
        Write-Host "Failed to delete: $($file.Name) - $_" -ForegroundColor Red
    }
}

# === Restart SCCM Client Service ===
Write-Host "`nRestarting SCCM Client service ($ccmService)..." -ForegroundColor Yellow
try {
    Restart-Service -Name $ccmService -Force -ErrorAction Stop
    Write-Host "ccmexec restarted successfully." -ForegroundColor Green
} catch {
    Write-Host "Failed to restart ccmexec service: $_" -ForegroundColor Red
}

# === Final Instructions ===
Write-Host "`nPlease wait 5–10 minutes for SCCM client to regenerate its self-signed certificate." -ForegroundColor Cyan
Write-Host "`nBackup of MachineKeys is saved at: $backupPath" -ForegroundColor Yellow
Write-Host "Script completed successfully!" -ForegroundColor Green