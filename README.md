<div align="center">

# 🏭 SCCM Scripts

**Small, focused scripts for Configuration Manager client and remote-control operations**

Four self-contained modules covering remote control tooling, client certificate repair, client repair, and client action triggers.

[![Tools](https://img.shields.io/badge/Tools-4%20Modules-10B981?style=for-the-badge)](#-scripts-included)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-5391FE?style=for-the-badge&logo=powershell&logoColor=white)](https://learn.microsoft.com/en-us/powershell/)
[![Platform](https://img.shields.io/badge/Platform-Windows%2010%2F11-0F172A?style=for-the-badge)](#%EF%B8%8F-requirements)
[![SCCM](https://img.shields.io/badge/SCCM-MECM%20Client-F59E0B?style=for-the-badge)](#-overview)
[![License](https://img.shields.io/badge/License-MIT-F59E0B?style=for-the-badge)](#-license)
[![Version](https://img.shields.io/badge/Version-1.0.0-334155?style=for-the-badge)](#-overview)

[Overview](#-overview) • [Features](#-core-features) • [Structure](#-project-structure) • [Scripts](#-scripts-included) • [Requirements](#%EF%B8%8F-requirements) • [License](#-license)

</div>

---

# 📖 Overview

**SCCM Scripts** is a compact collection of Configuration Manager (MECM) client utilities. Each module lives in its own folder with its script and, where available, its own README, so a helpdesk engineer can grab only the tool they need.

The modules cover installing/removing the SCCM remote-control viewer, repairing a broken client certificate, repairing a client installation, and triggering the standard client evaluation cycles.

---

# ✨ Core Features

### 🔹 Focused Modules
* One task per folder; no cross-module dependencies.
* Console-driven PowerShell with minimal prerequisites.

### 🔹 Remote Control Tooling
* `CmRcViewer.exe` and its resource DLLs are bundled with install/uninstall scripts for the SCCM remote-control viewer.

### 🔹 Client Remediation
* Certificate repair, full client repair, and standard action triggers (inventory, policy, compliance).

---

# 📂 Project Structure

```text
SCCM-Scripts/
│
├── CM Remote Control Tool/
│   ├── Install-SCCMRemoteTools.ps1
│   ├── Uninstall-SCCMRemoteTools.ps1
│   ├── CmRcViewer.exe
│   ├── RdpCoreSccm.dll
│   ├── 00000409\CmRcViewerRes.dll
│   └── README.md
├── Fix-SCCMClientCert/
│   ├── Fix-SCCMClientCert.ps1
│   └── README.md
├── Repair-SCCMClient/
│   └── Repair-SCCMClient.ps1
├── Trigger-SCCMClientActions/
│   └── Trigger-SCCMClientActions.ps1
└── README.md
```

---

# 🚀 Scripts Included

| Module | Purpose |
|--------|---------|
| `CM Remote Control Tool\Install-SCCMRemoteTools.ps1` | Installs the SCCM remote-control viewer components |
| `CM Remote Control Tool\Uninstall-SCCMRemoteTools.ps1` | Removes the remote-control viewer components |
| `Fix-SCCMClientCert\Fix-SCCMClientCert.ps1` | Repairs a broken client certificate |
| `Repair-SCCMClient\Repair-SCCMClient.ps1` | Repairs a broken Configuration Manager client |
| `Trigger-SCCMClientActions\Trigger-SCCMClientActions.ps1` | Triggers standard client evaluation cycles |

---

# ⚙️ Requirements

### Operating System
* Windows 10 / 11 or Windows Server with the SCCM client installed.

### PowerShell
* PowerShell **5.1 or later**.

### Permissions
* Local Administrator on the target machine; access to the SCCM management point for repair and action scripts.

---

# 🛡 Operational Notes

* The `CmRcViewer.exe` binary and resource DLLs are shipped in the remote-control module; verify their provenance before distribution.
* Run repairs on a pilot device first; client reinstall can briefly interrupt policy processing.
* Scripts are action tools: console output only, no HTML reports.

---

## 👤 Author

**Mohammad Abdelkader Omar**  
GitHub: [@mabdulkadr](https://github.com/mabdulkadr)  
Website: [momar.tech](https://momar.tech)

---

## 📜 License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).

---

## ⚠ Disclaimer

This skill and every script it generates are provided as-is with no warranty of any kind. Test generated tools in a staging environment before deploying to production. The authors assume no liability for any damage or data loss resulting from their use.

---
<div align="center">

⭐ **If this skill saves you time, star the repo — it helps others find it.**

[Report an Issue](../../issues) · [momar.tech](https://momar.tech)

[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://www.buymeacoffee.com/mabdulkadrx)

Built with [**PowerShell Enterprise Admin**](https://github.com/mabdulkadr/powershell-enterprise-admin)

</div>
