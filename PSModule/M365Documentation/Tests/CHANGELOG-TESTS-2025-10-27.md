Changelog: fixes applied and test results (2025-10-27)

Files changed:
- Internal/Collector/CloudPrint/Get-CPPrinter.ps1
  - Fixed: Titles were bare words causing PowerShell to attempt to execute them as commands. Quoted the titles: "Shares" and "Connectors".

- Internal/Collector/InformationProtection/Get-MIPLabel.ps1
  - Fixed: Corrected Graph endpoint path for labels from "/informationProtection/policy/labels" to "/informationProtection/labels" and requested beta (`-Beta`) since labels are generally available in beta.

Tests:
- Added Tests/run-unit-tests.ps1
  - Purpose: simple offline unit-style test that mocks `Invoke-DocGraph`, defines a minimal `DocSection` class for the test, runs `Get-CPPrinter` and `Get-MIPLabel`, and asserts the returned objects are populated.
  - Result: All tests passed locally.

Notes and next steps:
- The tests are offline and do not call real Graph endpoints. To fully validate API responses in your environment, run the normal module functions against Graph with appropriate authentication and permissions.
- If you want I can open a PR with the changes and the test file, or add CI to run the test script as part of validation.
