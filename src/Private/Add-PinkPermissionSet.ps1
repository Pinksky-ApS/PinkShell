# Grants a list of "<Resource>:<Scope>" values (e.g. "Graph:User.Read.All") by resolving
# each resource's service principal and calling Add-PinkRoleAssignment.

function Add-PinkPermissionSet {
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(Mandatory = $true)]
        [AllowNull()]
        [AllowEmptyCollection()]
        [string[]]$Values,

        [Parameter(Mandatory = $true)]
        [guid]$ManagedIdentityObjectId,

        [Parameter(Mandatory = $true)]
        [hashtable]$ServicePrincipalCache,

        [switch]$AsDelegated
    )

    foreach ($value in $Values) {
        $resource, $scope = $value -split ":", 2
        $servicePrincipal = Resolve-PinkServicePrincipal -Resource $resource -Cache $ServicePrincipalCache
        Add-PinkRoleAssignment -ServicePrincipal $servicePrincipal -ManagedIdentityObjectId $ManagedIdentityObjectId -RoleAssignment $scope -Delegated:$AsDelegated
    }
}
