# Changelog

All notable changes to this fork of M365Documentation are documented in this file.

## Fork Information

This is a fork of the original [M365Documentation by Thomas Kurth](https://github.com/ThomasKur/M365Documentation).

**Original Repository:** <https://github.com/ThomasKur/M365Documentation>  
**Original Author:** Thomas Kurth (WorkplaceNinjas)  
**Fork Maintainer:** Marc Holländer

---

## [3.5.2] - 2025-10-27

### Fixed

- **Information Protection Labels Endpoint** - Changed endpoint to `/security/dataSecurityAndGovernance/sensitivityLabels` with improved error handling
  - Previous endpoint was returning errors in certain tenant configurations
  - Added try-catch block with informative error messages
  - Returns DocSection with explanatory text when labels cannot be retrieved
  - Better handling for tenants without Information Protection licensing

### Changed

- Bumped module version to 3.5.2
- Improved error messaging for Information Protection label collection

### Commits

- `5142a13` - Fix Information Protection labels endpoint - changed to /security/dataSecurityAndGovernance/sensitivityLabels with error handling, bumped version to 3.5.2

---

## [3.5.1] - 2025-10-27

### Fixed

- **Cloud Print Printer Titles** - Fixed PowerShell execution errors in `Get-CPPrinter.ps1`
  - Titles for "Shares" and "Connectors" were bare words causing PowerShell to attempt command execution
  - Added proper string quotes: `"Shares"` and `"Connectors"`
  - Fixed indentation for proper code structure
- **Information Protection Labels Endpoint (Initial Fix)** - First attempt to fix MIP labels endpoint
  - Changed from `/informationProtection/policy/labels` to `/informationProtection/labels`
  - Added `-Beta` flag for API call
  - This was further improved in v3.5.2

### Added

- **Unit Tests** - Created comprehensive offline unit testing framework

  - New file: `PSModule/M365Documentation/Tests/run-unit-tests.ps1`
  - Mocks `Invoke-DocGraph` to allow offline testing
  - Tests for `Get-CPPrinter` and `Get-MIPLabel` functions
  - Validates returned objects are properly populated
  - Added test documentation: `PSModule/M365Documentation/Tests/CHANGELOG-TESTS-2025-10-27.md`

- **Non-Interactive Build Script** - Added automated build capability
  - New file: `PSModule/build-noninteractive.ps1`
  - Enables CI/CD pipeline integration
  - Supports automated testing and deployment workflows

### Changed

- Bumped module version to 3.5.1

### Technical Details

#### Cloud Print Fix (Get-CPPrinter.ps1)

```diff
-        $DocSecSingleShare.Title = Shares
+        $DocSecSingleShare.Title = "Shares"

-        $DocSecSingleCon.Title = Connectors
+        $DocSecSingleCon.Title = "Connectors"
```

#### Information Protection Fix (Get-MIPLabel.ps1)

- Changed endpoint to use documented Microsoft Graph path
- Added beta API support for label retrieval
- Improved compatibility with app registration authentication

### Commits

- `a843cd5` - Bump module to 3.5.1; fix CP printer titles; fix MIP labels endpoint; add tests and non-interactive build

---

## [3.5.0] - Original Release (Baseline)

This is the baseline version from the original repository by Thomas Kurth.

**Commit:** `b969371` - release of version 3.5.0

### Features from Original v3.5.0

- Full Microsoft Intune documentation support
- Microsoft Entra ID (Azure AD) documentation
- Microsoft Cloud Print documentation
- Microsoft Information Protection documentation
- Windows 365 (CloudPC) documentation
- Multiple output formats: JSON, CSV, Markdown, HTML, Word (DOCX)
- Flexible authentication with MSAL.PS
- Certificate and Secret-based authentication support
- PowerShell 7 requirement

### Supported Components (v3.5.0 Baseline)

- **Intune:** Configuration policies, compliance policies, device enrollment, applications, AutoPilot, scripts, security baselines, and more
- **Azure AD:** Conditional Access, domains, role assignments, PIM roles, authentication policies, administrative units
- **Cloud Print:** Printers, connectors, printer shares
- **Information Protection:** Labels and policies
- **Windows 365:** Device images, provisioning profiles, user settings, on-premises connections

---

## Summary of Changes from Original

### From v3.5.0-Main (b969371) to v3.5.1 (a843cd5)

**Files Changed:** 6 files

- Modified: `PSModule/M365Documentation/Internal/Collector/CloudPrint/Get-CPPrinter.ps1`
- Modified: `PSModule/M365Documentation/Internal/Collector/InformationProtection/Get-MIPLabel.ps1`
- Modified: `PSModule/M365Documentation/M365Documentation.psd1`
- Added: `PSModule/M365Documentation/Tests/CHANGELOG-TESTS-2025-10-27.md`
- Added: `PSModule/M365Documentation/Tests/run-unit-tests.ps1`
- Added: `PSModule/build-noninteractive.ps1`

### From v3.5.1 (a843cd5) to v3.5.2 (5142a13)

**Files Changed:** 2 files

- Modified: `PSModule/M365Documentation/Internal/Collector/InformationProtection/Get-MIPLabel.ps1`
- Modified: `PSModule/M365Documentation/M365Documentation.psd1`

### Total Changes from Original (v3.5.0) to Current (v3.5.2)

**Total Files Changed:** 6 files (3 modified, 3 added)
**Version Progression:** 3.5.0 → 3.5.1 → 3.5.2
**Key Improvements:**

- ✅ Fixed Cloud Print documentation errors
- ✅ Fixed Information Protection label collection
- ✅ Added comprehensive unit testing framework
- ✅ Added non-interactive build support for CI/CD
- ✅ Improved error handling and user feedback
- ✅ Enhanced tenant compatibility

---

## Contributing

This fork maintains compatibility with the original M365Documentation module while adding bug fixes and enhancements.

**Original Project:** <https://github.com/ThomasKur/M365Documentation>

---

## Credits

**Original Module:** M365Documentation by Thomas Kurth (WorkplaceNinjas)  
**Fork Enhancements:** Marc Holländer  
**License:** As per original repository

For the complete list of contributors to the original project, please see the [original repository](https://github.com/ThomasKur/M365Documentation).
