# Throws unless running PowerShell 7 or higher.

function Test-PinkIsPowerShellCore {
    [CmdletBinding()]
    [OutputType([void])]
    param()

    if ($PSVersionTable.PSVersion.Major -lt 7) {
        throw "PinkShell requires PowerShell 7 or higher to run, please upgrade your PowerShell version and try again - https://aka.ms/powershell-release?tag=stable"
    }

    Write-Host "✅ - PowerShell 7 or higher detected" -ForegroundColor Magenta
}
