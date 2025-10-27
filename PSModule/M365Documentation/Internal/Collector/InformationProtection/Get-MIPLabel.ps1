Function Get-MIPLabel(){
    <#
    .SYNOPSIS
    This function is used to get the Microsoft Information Protection Labels from the Beta Graph API REST interface
    .DESCRIPTION
    The function connects to the Graph API Interface and gets the MIP Labels
    .EXAMPLE
    Get-MIPLabel
    Returns the MIP Labels.
    .NOTES
    NAME: Get-MIPLabel
    #>
    [OutputType('DocSection')]
    [cmdletbinding()]
    param()

    $DocSec = New-Object DocSection

    $DocSec.Title = "Labels"
    $DocSec.Text = "Lists all labels that have been configured in Microsoft Information Protection."
    Write-Warning -Message "InformationProtection only documents all labels when executed with an app registration and not when running interactive."
    
    # Try to get Information Protection labels with error handling
    try {
        # Use the /informationProtection/labels endpoint which is the documented path for labels
        $DocSec.Objects = (Invoke-DocGraph -Path "/security/dataSecurityAndGovernance/sensitivityLabels" -Beta).Value
    } catch {
        Write-Verbose "Information Protection labels are not available in this tenant. Error: $($_.Exception.Message)"
        $DocSec.Objects = $null
        $DocSec.Text += " Note: Information Protection labels could not be retrieved - this feature may not be available in this tenant or may require additional licensing/permissions."
    }
    
    $DocSec.Transpose = $false
    if($null -eq $DocSec.Objects -or $DocSec.Objects.Count -eq 0){
        # Return the section anyway with explanatory text instead of null
        return $DocSec
    } else {
        return $DocSec
    }
    
}