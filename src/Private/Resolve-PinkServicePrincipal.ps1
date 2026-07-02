# Resolves the Graph or SharePoint service principal for a permission resource, caching
# the result in the caller-provided -Cache hashtable.

function Resolve-PinkServicePrincipal {
    [CmdletBinding()]
    [OutputType([object])]
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Resource,

        [Parameter(Position = 1, Mandatory = $true)]
        [hashtable]$Cache
    )

    if (-not $Cache.ContainsKey($Resource)) {
        $appId = $PinkResourceServicePrincipalAppIds[$Resource]
        if ($null -eq $appId) {
            throw "Unknown permission resource '$Resource' - expected 'Graph' or 'SharePoint'"
        }
        $Cache[$Resource] = Get-MgServicePrincipal -Filter "AppId eq '$appId'" -Property Id, AppRoles, Oauth2PermissionScopes
    }
    return $Cache[$Resource]
}
