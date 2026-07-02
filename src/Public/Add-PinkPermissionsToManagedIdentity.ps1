# Backing classes for -Application/-Delegated's tab-completion and validation. They have to
# live in this file - [ValidateSet] resolves its class at parse time and only looks in the
# same file. Arrays start empty; Update-PinkPermissionCache fills them at startup, since
# GetValidValues() can't safely call Graph itself from inside a completer. Values get a
# "Graph:"/"SharePoint:" prefix to tell apart scope names that exist on both resources.
class PinkApplicationPermission : System.Management.Automation.IValidateSetValuesGenerator {
    static [string[]] $GraphScopes = @()

    static [string[]] $SharePointScopes = @()

    [System.String[]] GetValidValues() {
        $values = [System.Collections.Generic.List[string]]::new()
        [PinkApplicationPermission]::GraphScopes | ForEach-Object { $values.Add("Graph:$_") }
        [PinkApplicationPermission]::SharePointScopes | ForEach-Object { $values.Add("SharePoint:$_") }
        return $values.ToArray()
    }
}

class PinkDelegatedPermission : System.Management.Automation.IValidateSetValuesGenerator {
    static [string[]] $GraphScopes = @()

    # SharePoint names its delegated scopes differently than its application ones
    # (e.g. AllSites.Read vs Sites.Read.All).
    static [string[]] $SharePointScopes = @()

    [System.String[]] GetValidValues() {
        $values = [System.Collections.Generic.List[string]]::new()
        [PinkDelegatedPermission]::GraphScopes | ForEach-Object { $values.Add("Graph:$_") }
        [PinkDelegatedPermission]::SharePointScopes | ForEach-Object { $values.Add("SharePoint:$_") }
        return $values.ToArray()
    }
}

<#
    .SYNOPSIS
        Grants Microsoft Graph and/or SharePoint Online permissions to a Managed Identity
    .Description
        Grants application and/or delegated permissions, using resource-qualified values
        ("Graph:<scope>" / "SharePoint:<scope>") to disambiguate scope names that exist on
        both resources. Idempotent - re-granting an existing permission is a no-op. Supports
        -WhatIf. Returns a summary of the managed identity's current permissions.
    .EXAMPLE
        Add-PinkPermissionsToManagedIdentity -ManagedIdentityObjectId "22222222-2222-2222-2222-222222222222" `
            -Application "Graph:User.Read.All", "SharePoint:Sites.Selected" `
            -Delegated "Graph:Files.Read"
#>

function Add-PinkPermissionsToManagedIdentity {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [guid]$ManagedIdentityObjectId,

        [Parameter()]
        [ValidateSet([PinkApplicationPermission], ErrorMessage = "'{0}' is not a valid application permission - check the exact name and resource prefix ('Graph:' / 'SharePoint:'), or press Tab on this parameter to browse valid values.")]
        [string[]]$Application,

        [Parameter()]
        [ValidateSet([PinkDelegatedPermission], ErrorMessage = "'{0}' is not a valid delegated permission - check the exact name and resource prefix ('Graph:' / 'SharePoint:'), or press Tab on this parameter to browse valid values.")]
        [string[]]$Delegated
    )

    Write-Host "Adding permissions to Managed Identity '$ManagedIdentityObjectId'" -ForegroundColor Magenta

    if (-not $Application -and -not $Delegated) {
        throw "No permissions provided - pass at least one value to -Application and/or -Delegated, e.g. -Application 'Graph:User.Read.All'"
    }

    # Shared cache: resolve each resource's service principal only once.
    $servicePrincipalCache = @{}
    Add-PinkPermissionSet -Values $Application -ManagedIdentityObjectId $ManagedIdentityObjectId -ServicePrincipalCache $servicePrincipalCache
    Add-PinkPermissionSet -Values $Delegated -ManagedIdentityObjectId $ManagedIdentityObjectId -ServicePrincipalCache $servicePrincipalCache -AsDelegated

    Write-Host "`nCurrent permissions for '$ManagedIdentityObjectId':`n" -ForegroundColor Magenta

    $resourcePrincipalCache = @{}

    $applicationPermissions = [System.Collections.Generic.List[pscustomobject]]::new()
    Write-Host "Application" -ForegroundColor Magenta
    $allAssignmentsApp = Get-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $ManagedIdentityObjectId | Group-Object -Property ResourceDisplayName
    foreach ($group in $allAssignmentsApp) {
        Write-Host "> $($group.Name)"
        foreach ($assignment in $group.Group) {
            if (-not $resourcePrincipalCache.ContainsKey($assignment.ResourceId)) {
                $resourcePrincipalCache[$assignment.ResourceId] = Get-MgServicePrincipal -ServicePrincipalId $assignment.ResourceId
            }
            $appRole = $resourcePrincipalCache[$assignment.ResourceId].AppRoles | Where-Object Id -eq $assignment.AppRoleId
            Write-Host "`t> $($appRole.Value)"
            $applicationPermissions.Add([pscustomobject]@{
                    Resource   = $group.Name
                    Permission = $appRole.Value
                })
        }
    }

    $delegatedPermissions = [System.Collections.Generic.List[pscustomobject]]::new()
    Write-Host "`nDelegated" -ForegroundColor Magenta
    $allDelegatedAssignments = Get-MgOauth2PermissionGrant -Filter "clientId eq '$ManagedIdentityObjectId' and consentType eq 'AllPrincipals'"
    foreach ($grant in $allDelegatedAssignments) {
        if (-not $resourcePrincipalCache.ContainsKey($grant.ResourceId)) {
            $resourcePrincipalCache[$grant.ResourceId] = Get-MgServicePrincipal -ServicePrincipalId $grant.ResourceId
        }
        $principal = $resourcePrincipalCache[$grant.ResourceId]
        Write-Host "> $($principal.DisplayName)"
        foreach ($scope in $grant.Scope -split " ") {
            Write-Host "`t> $scope"
            $delegatedPermissions.Add([pscustomobject]@{
                    Resource   = $principal.DisplayName
                    Permission = $scope
                })
        }
    }

    Write-Host "`n✅ - Finished adding permissions to Managed Identity '$ManagedIdentityObjectId'" -ForegroundColor Magenta

    [pscustomobject]@{
        ManagedIdentityObjectId = $ManagedIdentityObjectId
        Application             = $applicationPermissions.ToArray()
        Delegated               = $delegatedPermissions.ToArray()
    }
}
