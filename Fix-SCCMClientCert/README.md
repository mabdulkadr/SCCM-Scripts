
# Fix SCCM Client Certificate Script

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![PowerShell](https://img.shields.io/badge/powershell-5.1%2B-blue.svg)
![Version](https://img.shields.io/badge/version-1.0-green.svg)

## Overview

This script remediates SCCM (Microsoft Endpoint Configuration Manager) client communication issues caused by corrupt or missing client certificates.

It safely removes the cryptographic keys from the `MachineKeys` folder after taking ownership, allowing the SCCM client to regenerate a new self-signed certificate and resume communication with the Management Point (MP).

---

## Scripts Included

1. **Fix-SCCMClientCert.ps1**
   - Backs up the MachineKeys folder.
   - Takes ownership and deletes all cryptographic keys.
   - Restarts the SCCM client service (`ccmexec`).
   - Prompts the system to regenerate a self-signed client certificate.

---

## Scripts Details

### 1. Fix-SCCMClientCert.ps1

#### Purpose

To force the regeneration of SCCM client certificates by:
- Taking ownership of MachineKeys
- Granting administrative access
- Deleting keys blocking SCCM communication
- Restarting the `ccmexec` service

#### How to Run

Run this script **as Administrator** in PowerShell:

```powershell
.\Fix-SCCMClientCert.ps1
```

#### Outputs

- Backup Folder: `C:\Backup_MachineKeys_<timestamp>`
- Status Logs: displayed in PowerShell during execution
- Certificate Status: can be checked using:

```powershell
Get-WmiObject -Namespace "ROOT\ccm" -Class SMS_Client | Select ClientCertificate
```

---

## Notes

- Use with **extreme caution** in production environments.
- Only run if you're confident that the client certificate is broken and cannot be recovered by repair or reinstallation.
- Test on lab or pilot machines before wide deployment.

---

## License 

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).

---

**Disclaimer**: This script is provided as-is. Always test in a safe environment before using in production. The author is not responsible for any unintended consequences.
