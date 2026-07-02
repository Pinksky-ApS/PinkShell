# Runs the shared PinkShell startup sequence against an already-resolved module root.

function Initialize-PinkShell {
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ModuleRoot,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ProductName
    )

    try {
        . (Join-Path $ModuleRoot "src/Private/Test-PinkIsPowerShellCore.ps1")
        Test-PinkIsPowerShellCore

        . (Join-Path $ModuleRoot "src/Private/Show-PinkBanner.ps1")
        Show-PinkBanner

        Write-Host "⌛ - Loading $ProductName" -ForegroundColor Magenta

        # Enable-PinkModule installs PinkShell's Microsoft.Graph dependencies, which have to be
        # in place before Import-Module below (RequiredModules would otherwise fail to resolve).
        . (Join-Path $ModuleRoot "src/Private/Enable-PinkModule.ps1")
        $manifest = Import-PowerShellDataFile -Path (Join-Path $ModuleRoot "PinkShell.psd1")
        Write-Host "👷 - Checking prerequisites" -ForegroundColor Magenta
        Enable-PinkModule -ModuleName $manifest.RequiredModules

        $module = Import-Module (Join-Path $ModuleRoot "PinkShell.psd1") -Force -Global -PassThru

        Write-Host "✅ - $ProductName ($($manifest.ModuleVersion)) is loaded`n" -ForegroundColor Magenta
        Write-Host "🚀 - Connecting to Microsoft Graph" -ForegroundColor Magenta
        & $module { Connect-PinkMicrosoftGraph }

        Write-Host "`n🔍 - Caching available permissions" -ForegroundColor Magenta
        & $module { Update-PinkPermissionCache }

        Write-Host "`n✅ - $ProductName ($($manifest.ModuleVersion)) loaded successfully." -ForegroundColor Magenta
        Write-Host "💡 - Try 'Get-Command -Noun Pink*' to see every available cmdlet, or 'Get-Help Add-PinkPermissionsToManagedIdentity -Full' for usage." -ForegroundColor Magenta
    }
    catch {
        Write-Host "❌ - $ProductName failed to load" -ForegroundColor Red
        Write-Host "❌ - Error: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "❌ - Please fix the error and try again" -ForegroundColor Red
    }
}
