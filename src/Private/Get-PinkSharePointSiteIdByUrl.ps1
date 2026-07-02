# Resolves a SharePoint site URL to its Microsoft Graph site id, via exact
# "{hostname}:{server-relative-path}" addressing (not -Search, which is a fuzzy match).

function Get-PinkSharePointSiteIdByUrl {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$SiteUrl
    )

    $uri = $SiteUrl -as [uri]
    if ($null -eq $uri -or -not $uri.IsAbsoluteUri) {
        throw "'$SiteUrl' is not a valid absolute URL - expected something like 'https://contoso.sharepoint.com/sites/Marketing'"
    }

    $serverRelativePath = $uri.AbsolutePath.TrimEnd('/')
    $siteId = "$($uri.Host):$serverRelativePath"

    $site = Get-MgSite -SiteId $siteId -Property "id,name,webUrl" -ErrorAction SilentlyContinue
    if ($null -eq $site) {
        throw "Site '$SiteUrl' not found - make sure the URL is correct, and no trailing slashes are present"
    }

    Write-Host "✅ - Site '$($site.Name)' found at '$($site.WebUrl)'" -ForegroundColor Magenta
    return $site.Id
}
