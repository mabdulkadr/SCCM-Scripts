
# Configuration Manager (SCCM) Remote Tools client

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![PowerShell](https://img.shields.io/badge/powershell-5.1%2B-blue.svg)
![Version](https://img.shields.io/badge/version-1.0.0-green.svg)

These PowerShell scripts install and remove the Configuration Manager (SCCM) Remote Tools client.

---

## Overview

These scripts install and uninstall the SCCM Remote Tools client in standalone mode. They set up and clean up files, registry entries, and shortcuts.

---

## Scripts

### Install-SCCMRemoteTools.ps1

#### Description
This script installs the SCCM Remote Tools client by:
- Creating necessary directories for installation.
- Copying required files to the target directory.
- Setting registry entries to connect the Remote Tools client to the SCCM Primary Site Server.
- Adding a shortcut to the Start Menu for easy access.

#### Features
- Automatically detects the operating system architecture (32-bit or 64-bit) and updates the registry accordingly.
- Uses idempotent checks, creating directories and registry entries only if they do not exist.

#### Example Usage
```powershell
.\Install-SCCMRemoteTools.ps1
```

---

### Uninstall-SCCMRemoteTools.ps1

#### Description
This script uninstalls the SCCM Remote Tools client by:
- Removing the installation directory and its contents.
- Deleting registry entries related to the Configuration Manager Remote Tools client.
- Removing the Start Menu shortcut for the Remote Control tool.

#### Features
- Detects operating system architecture to target the appropriate registry paths.
- Leaves no residual files or configuration.

#### Example Usage
```powershell
.\Uninstall-SCCMRemoteTools.ps1
```

---

## Usage

### Prerequisites
- Run the scripts with **Administrator** privileges.
- Ensure all required files (e.g., `RdpCoreSccm.dll`, `CmRcViewer.exe`, `CmRcViewerRes.dll`) are located in the same directory as `Install-SCCMRemoteTools.ps1`.

### Running the Scripts
1. Open PowerShell as Administrator.
2. Navigate to the directory containing the script(s).
3. Execute the script:
   - To install the SCCM Remote Tools client:  
     ```powershell
     .\Install-SCCMRemoteTools.ps1
     ```
   - To uninstall the SCCM Remote Tools client:  
     ```powershell
     .\Uninstall-SCCMRemoteTools.ps1
     ```

---

## Requirements

- Operating System: Windows (32-bit or 64-bit)
- PowerShell: Version 5.1 or later
- Permissions: Administrator privileges are required to run the scripts.

---

## License

This project is licensed under the [MIT License](LICENSE).


---

**Disclaimer**: Use these scripts at your own risk. Ensure you understand their impact before running them in a production environment. Always review and test scripts thoroughly.
