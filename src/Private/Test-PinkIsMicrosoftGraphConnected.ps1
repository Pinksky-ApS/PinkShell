# Checks if the current PowerShell session is connected to Microsoft Graph.

function Test-PinkIsMicrosoftGraphConnected {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    return $null -ne (Get-MgContext)
}
