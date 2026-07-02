# Installs any of the given modules that aren't already present, for the current user.

function Enable-PinkModule {
    [CmdletBinding()]
    [OutputType([void])]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$ModuleName
    )

    foreach ($name in $ModuleName) {
        $module = Get-Module -ListAvailable -Name $name -ErrorAction SilentlyContinue
        if ($null -eq $module) {
            Write-Host "⚠️ - '$name' PowerShell module not found, installing it now" -ForegroundColor Yellow
            Install-Module -Name $name -Force -AllowClobber -Scope CurrentUser
            Write-Host "✅ - '$name' PowerShell module has been installed" -ForegroundColor Magenta
        }
        else {
            Write-Host "✅ - '$name' PowerShell module is already installed" -ForegroundColor Magenta
        }
    }
}
