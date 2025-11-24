# Automatic Microsoft 365 Documentation

> **⭐ ORIGINAL PROJECT:** This is a fork of [M365Documentation by Thomas Kurth](https://github.com/ThomasKur/M365Documentation)  
> **🙏 Please visit and support the original project:** <https://github.com/ThomasKur/M365Documentation>  
> **Original Author:** Thomas Kurth ([WorkplaceNinjas](https://workplaceninja.cloud/))

---

<img align="right" src="https://github.com/ThomasKur/M365Documentation/raw/main/Logo/M365DocumentationLogo.png" width="300px" alt="Automatic M365 Documentation Logo">

Automatic Microsoft 365 Documentation to simplify the life of admins and consultants. You can automatically document systems like:

- Microsoft Intune
- Microsoft Entra ID (Azure AD)
- Microsoft Cloud Print
- Microsoft Information protection
- Windows 365 (CloudPC)

_This list will expand in the near future._

This is the successor to the IntuneDocumentation module and has much more options like:

- Output to Json
  - Backup your configuration and create documentation later
  - Compare your configuration over time for example with <http://www.jsondiff.com/>
- Output to CSV
- Output to Markdown/MD
- Output to HTML
- Flexible Authentication with MSAL.PS
  - Support for Certificate and Secret based Authentication

Through the new architecture much other features will follow in the near future.

## About This Fork

This fork includes bug fixes and enhancements while maintaining full compatibility with the original module:

- ✅ Fixed Information Protection labels endpoint issues
- ✅ Fixed Cloud Print printer documentation errors
- ✅ Added comprehensive unit testing framework
- ✅ Added non-interactive build script for CI/CD
- ✅ Improved error handling and tenant compatibility

**See [CHANGELOG.md](CHANGELOG.md) for detailed information about changes.**

**Fork Maintainer:** Marc Holländer  
**Version:** 3.5.2

---

## Usage

### Installation

The required modules are fully available in the PowerShell Gallery and therefore simple to install.

```powershell

Install-Module MSAL.PS
Install-Module PSWriteOffice
Install-Module M365Documentation

```

_PowerShell 7_ is required.

### Basic Usage to create docx

This section covers basic functionality for interactive usage. Advanced use cases like creating your own app registration is covered in the [advanced usage](https://github.com/ThomasKur/M365Documentation/blob/master/AdvancedUsage.md) section.

```powershell

# Connect to your tenant
Connect-M365Doc

# Collect information
$Selection = Get-M365DocValidSection | Out-GridView -OutputMode Multiple
$Sections = $Selection | Select-Object -ExpandProperty SectionName
$Components = $Selection | Select-Object -ExpandProperty Component -Unique
$doc = Get-M365Doc -Components $Components -IncludeSections $Sections

# Output the documentation to a Word file
$doc | Write-M365DocWord -FullDocumentationPath "c:\temp\$($doc.CreationDate.ToString("yyyyMMddHHmm"))-WPNinjas-Doc.docx"


```

## Sections which you can choose from

You can now use the _Get-M365DocValidSection -Components Intune_ command to list the complete list of valid sections.

_Component: AzureAD_
AADAdministrativeUnit
AADAuthMethod
AADBranding
AADConditionalAccess
AADConditionalAccessSplit
AADDirectoryPimRole
AADDirectoryRole
AADDomain
AADIdentityProvider
AADOrganization
AADPolicy
AADSubscription

_Component: CloudPrint_
CPConnector
CPPrinter

_InformationProtection_
MIPLabel

_Intune_
MdmAdmxConfigurationProfile
MdmAppleConfiguration
MdmAutopilotProfile
MdmCompliancePolicy
MdmConfigurationPolicy
MdmConfigurationProfile
MdmDeviceAssignmentFilter
MdmDeviceCategory
MdmEnrollmentConfiguration
MdmExchangeConnector
MdmPartner
MdmPowerShellScript
MdmRole
MdmShellScript
MdmSecurityBaseline
MdmTermsAndCondition
MdmWindowsUpdate
MobileApp
MobileAppConfiguration
MobileAppDetailed
MobileAppManagement
... Use the Get-M365DocValidSection command to get a complete list.

_Windows365_
W365Image
W365OnPremConnection
W365ProvisionProfile
W365UserSetting

## Supported Components

### Microsoft Endpoint Manager / Intune

The following entities are documented:

- Configuration Policies
- Compliance Policies
- Device Enrollment Restrictions
- Terms and Conditions
- Applications (Only Assigned)
- Application Protection Policies
- AutoPilot Configuration
- Enrollment Page Configuration
- Apple Push Certificate
- Apple VPP
- Device Categories
- Exchange Connector
- Application Configuration
- PowerShell Scripts
- ADMX backed Configuration Profiles
- Security Baseline
- Custom Roles

### Azure AD

The following entities are documented:

- Azure AD Conditional Access Policies
- Translate referenced IDs to real object names (users, groups, roles and applications)
- Domains
- Feature Rollout Policy
- Authentication policies
- Role Assignments & PIM Roles
- Mobile Device Management Policies
- Subscriptions / SKU
- Organizational Settings
- Administrative Units

### Cloud Print

The following entities are documented:

- Printers
- Connectors
- Printer Shares

### Microsoft Information Protection

The following entities are documented:

- Labels

### Windows 365 (CloudPC)

- Device Images
- Provisioning Profiles
- User Settings
- On-premises Connections

## Issues / Feedback

For issues specific to this fork, please register for GitHub and post your inquiry to this project's issue tracker.

For issues with the original module, please visit the [original project's issue tracker](https://github.com/ThomasKur/M365Documentation/issues).

---

## Thanks & Contributors

### Original Project Creator

**🌟 [Thomas Kurth](https://github.com/ThomasKur) (WorkplaceNinjas)** - Creator and maintainer of M365Documentation

- Original repository: <https://github.com/ThomasKur/M365Documentation>
- Website: <https://workplaceninja.cloud/>
- Company: ![baseVISION](https://www.basevision.ch/wp-content/uploads/2015/12/baseVISION-Logo_RGB.png)

### Original Project Contributors

Special thanks to all contributors to the original M365Documentation project:

- **@NicoSchmidtbauer** - Contributions around HTML output and other fixes and improvements
- **@MEM_MVP** - Continuous feedback and 10,000+ translations
- **@ylepine** - Contribution to support Intune Settings catalog
- **@johofer** - Contribution to remove base64 encoded images from the documentation

### Dependencies & Acknowledgments

- **@Microsoftgraph** - PowerShell Examples: <https://github.com/microsoftgraph/powershell-intune-samples>
- **@PrzemyslawKlys** - PSWriteWord Module for Word file creation: <https://github.com/EvotecIT/PSWriteOffice>
- **@MScholtes** - Transpose-Object example: <https://github.com/MScholtes/TechNet-Gallery>

### Fork Maintainer

**Marc Holländer** - Bug fixes, testing framework, and enhancements (this fork)

---

## License

This project maintains the same license as the original M365Documentation project.

**Original Project:** Copyright (c) 2025 Thomas Kurth. All rights reserved.
