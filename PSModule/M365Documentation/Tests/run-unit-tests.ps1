<#
Simple tests for the two modified functions: Get-CPPrinter and Get-MIPLabel
This test script mocks Invoke-DocGraph with deterministic returns so the functions can be exercised offline.
#>

# Minimal DocSection class used by the module functions. Defining here for tests so New-Object DocSection works.
class DocSection {
    [string]$Title
    [string]$Text
    [object]$Objects
    [object[]]$SubSections
    [bool]$Transpose
}

# Mock implementation of Invoke-DocGraph for tests
function Invoke-DocGraph {
    param(
        [string]$Path,
        [switch]$Beta,
        $FullUrl
    )

    # Return structures similar to the real Invoke-DocGraph (object with .Value array)
    switch -Regex ($Path) {
        '/print/printers$' {
            return @{ Value = @(
                @{ id = 'printer1'; displayName = 'Test Printer 1' },
                @{ id = 'printer2'; displayName = 'Test Printer 2' }
            ) }
        }
        '/print/printers/.*/shares' {
            return @{ Value = @(@{ id = 'share1'; name='Share1' }) }
        }
        '/print/printers/.*/connectors' {
            return @{ Value = @(@{ id = 'con1'; name='Connector1' }) }
        }
        '/informationProtection/labels' {
            return @{ Value = @(@{ id = 'label1'; name = 'Confidential' }) }
        }
        default {
            return @{ Value = @() }
        }
    }
}

# Dot-source the functions under test
. "$PSScriptRoot\..\Internal\Collector\CloudPrint\Get-CPPrinter.ps1"
. "$PSScriptRoot\..\Internal\Collector\InformationProtection\Get-MIPLabel.ps1"

Write-Output "Running tests..."

$printerDoc = Get-CPPrinter
if ($null -eq $printerDoc) { Write-Error "Get-CPPrinter returned null"; exit 1 }
if (-not $printerDoc.SubSections) { Write-Error "Get-CPPrinter returned a DocSection with no SubSections"; exit 1 }
Write-Output "Get-CPPrinter OK: Found $($printerDoc.SubSections.Count) printers"

$labelDoc = Get-MIPLabel
if ($null -eq $labelDoc) { Write-Error "Get-MIPLabel returned null"; exit 1 }
if (-not $labelDoc.Objects) { Write-Error "Get-MIPLabel returned a DocSection with no Objects"; exit 1 }
Write-Output "Get-MIPLabel OK: Found $($labelDoc.Objects.Count) labels"

Write-Output "All tests passed." 
