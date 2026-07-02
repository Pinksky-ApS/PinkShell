# Refreshes the -Application/-Delegated tab-completion catalog from live Graph + SharePoint
# data. Called once at startup, right after Connect-PinkMicrosoftGraph. The catalog starts
# empty; each half fails independently, leaving that resource's completion list empty for
# the session if it can't refresh.
function Update-PinkPermissionCache {
    [CmdletBinding()]
    [OutputType([void])]
    param()

    try {
        $graphApplication = Find-MgGraphPermission -PermissionType Application -All -ErrorAction Stop
        $graphDelegated = Find-MgGraphPermission -PermissionType Delegated -All -ErrorAction Stop
        [PinkApplicationPermission]::GraphScopes = @($graphApplication | Select-Object -ExpandProperty Name)
        [PinkDelegatedPermission]::GraphScopes = @($graphDelegated | Select-Object -ExpandProperty Name)
        Write-Host "✅ - Cached $($graphApplication.Count) application + $($graphDelegated.Count) delegated Microsoft Graph permissions" -ForegroundColor Magenta
    }
    catch {
        Write-Warning "Could not refresh Microsoft Graph permissions - tab-completion/validation for Graph permissions will be unavailable this session ($($_.Exception.Message))"
    }

    try {
        $sharePointAppId = $PinkResourceServicePrincipalAppIds["SharePoint"]
        $sharePointServicePrincipal = Get-MgServicePrincipal -Filter "AppId eq '$sharePointAppId'" -Property AppRoles, Oauth2PermissionScopes -ErrorAction Stop
        [PinkApplicationPermission]::SharePointScopes = @($sharePointServicePrincipal.AppRoles | Select-Object -ExpandProperty Value)
        [PinkDelegatedPermission]::SharePointScopes = @($sharePointServicePrincipal.Oauth2PermissionScopes | Select-Object -ExpandProperty Value)
        Write-Host "✅ - Cached $($sharePointServicePrincipal.AppRoles.Count) application + $($sharePointServicePrincipal.Oauth2PermissionScopes.Count) delegated SharePoint permissions" -ForegroundColor Magenta
    }
    catch {
        Write-Warning "Could not refresh SharePoint permissions - tab-completion/validation for SharePoint permissions will be unavailable this session ($($_.Exception.Message))"
    }
}
