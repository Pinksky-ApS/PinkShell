<#
    .SYNOPSIS
        Grants an application read, write, owner, or fullcontrol access to a single SharePoint site via Sites.Selected
    .Description
        Resolves the given SharePoint site URL to its site id, then grants the given application
        read, write, owner, or fullcontrol access scoped to just that one site - the Sites.Selected
        permission model, which has no equivalent GUI in the Microsoft 365 admin center or
        SharePoint admin center.

        Supports -WhatIf.
    .EXAMPLE
        Add-PinkSitesSelectedPermissionToSite -ApplicationId "11111111-1111-1111-1111-111111111111" -SiteUrl "https://contoso.sharepoint.com/sites/Marketing" -Permission read
#>

function Add-PinkSitesSelectedPermissionToSite {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param (
        [Alias("ClientId")]
        [Parameter(Position = 0, Mandatory = $true)]
        [guid]$ApplicationId,

        [Parameter(Position = 1, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$SiteUrl,

        [Parameter(Position = 2, Mandatory = $true)]
        [ValidateSet("read", "write", "owner", "fullcontrol")]
        [string]$Permission
    )

    $siteId = Get-PinkSharePointSiteIdByUrl -SiteUrl $SiteUrl

    $body = @{
        roles               = @($Permission)
        grantedToIdentities = @(
            @{
                application = @{
                    id          = $ApplicationId.ToString()
                    displayName = $ApplicationId.ToString()
                }
            }
        )
    }

    if ($PSCmdlet.ShouldProcess($SiteUrl, "Grant '$Permission' access to application '$ApplicationId'")) {
        New-MgSitePermission -SiteId $siteId -BodyParameter $body | Out-Null
        Write-Host "✅ - Permission '$Permission' granted to '$ApplicationId' on '$SiteUrl'" -ForegroundColor Magenta
    }
}
