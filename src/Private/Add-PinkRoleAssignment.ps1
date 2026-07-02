# Grants (or updates) a single application or delegated permission on a managed identity.
# Idempotent - re-granting an existing permission is a no-op.

function Add-PinkRoleAssignment {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        # From Resolve-PinkServicePrincipal, with -Property AppRoles, Oauth2PermissionScopes.
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateNotNull()]
        $ServicePrincipal,

        [Parameter(Position = 1, Mandatory = $true)]
        [guid]$ManagedIdentityObjectId,

        [Parameter(Position = 2, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$RoleAssignment,

        [Parameter(Position = 3)]
        [switch]$Delegated
    )

    if (-not $Delegated) {
        $appRole = $ServicePrincipal.AppRoles | Where-Object Value -eq $RoleAssignment
        if ($null -eq $appRole) {
            throw "'$RoleAssignment' is not a valid application permission on this resource - check the exact scope name and that you used the right resource prefix (Graph: vs SharePoint:)"
        }

        $existing = Get-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $ManagedIdentityObjectId | Where-Object AppRoleId -eq $appRole.Id
        if ($null -ne $existing) {
            Write-Host "✅ - Application assignment '$RoleAssignment' already exists, skipping" -ForegroundColor Magenta
            return
        }

        if ($PSCmdlet.ShouldProcess($ManagedIdentityObjectId, "Add application permission '$RoleAssignment'")) {
            Write-Host "🆕 - Adding application assignment: '$RoleAssignment'" -ForegroundColor Magenta
            New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $ManagedIdentityObjectId -PrincipalId $ManagedIdentityObjectId -ResourceId $ServicePrincipal.Id -AppRoleId $appRole.Id | Out-Null
        }
        return
    }

    $delegatedScope = $ServicePrincipal.Oauth2PermissionScopes | Where-Object Value -eq $RoleAssignment
    if ($null -eq $delegatedScope) {
        throw "'$RoleAssignment' is not a valid delegated permission on this resource - check the exact scope name and that you used the right resource prefix (Graph: vs SharePoint:)"
    }

    $existing = Get-MgOauth2PermissionGrant -Filter "clientId eq '$ManagedIdentityObjectId' and consentType eq 'AllPrincipals'" | Where-Object ResourceId -eq $ServicePrincipal.Id
    if ($null -eq $existing) {
        if ($PSCmdlet.ShouldProcess($ManagedIdentityObjectId, "Add delegated permission '$RoleAssignment'")) {
            Write-Host "🆕 - Adding delegated assignment: '$RoleAssignment'" -ForegroundColor Magenta
            New-MgOauth2PermissionGrant -ClientId $ManagedIdentityObjectId -Scope $RoleAssignment -ConsentType "AllPrincipals" -ResourceId $ServicePrincipal.Id | Out-Null
        }
        return
    }

    $scope = $existing.Scope.Split(" ")
    if ($scope -contains $RoleAssignment) {
        Write-Host "✅ - Delegated scope '$RoleAssignment' already exists in the grant, skipping" -ForegroundColor Magenta
        return
    }

    if ($PSCmdlet.ShouldProcess($ManagedIdentityObjectId, "Add delegated scope '$RoleAssignment' to existing grant")) {
        Write-Host "✅ - Delegated grant already exists, adding scope '$RoleAssignment' to it" -ForegroundColor Magenta
        $scope += $RoleAssignment
        Update-MgOauth2PermissionGrant -OAuth2PermissionGrantId $existing.Id -Scope ($scope -join " ") | Out-Null
    }
}
