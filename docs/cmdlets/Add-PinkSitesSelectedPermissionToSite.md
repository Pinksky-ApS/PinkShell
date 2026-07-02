# Add-PinkSitesSelectedPermissionToSite

Grants an application read, write, owner, or fullcontrol access to a single SharePoint site,
using the `Sites.Selected` permission model - which has no equivalent GUI in the Microsoft 365
admin center or SharePoint admin center.

## Syntax

```powershell
Add-PinkSitesSelectedPermissionToSite
    -ApplicationId <guid>
    -SiteUrl <string>
    -Permission <read|write|owner|fullcontrol>
    [-WhatIf] [-Confirm]
```

| Parameter | Required | Description |
|---|---|---|
| `-ApplicationId` (alias `-ClientId`) | Yes | The application (client) ID receiving access. |
| `-SiteUrl` | Yes | The full URL of the SharePoint site. |
| `-Permission` | Yes | One of `read`, `write`, `owner`, `fullcontrol`. |

### Roles

| Role | Description |
|---|---|
| `read` | Read the metadata and contents of the resource. |
| `write` | Read and modify the metadata and contents of the resource. |
| `owner` | Represents the owner role. |
| `fullcontrol` | Represents full control of the resource. |

## Example

```powershell
Add-PinkSitesSelectedPermissionToSite -ApplicationId "11111111-1111-1111-1111-111111111111" `
    -SiteUrl "https://contoso.sharepoint.com/sites/Marketing" `
    -Permission read
```

Preview the grant without making it:

```powershell
Add-PinkSitesSelectedPermissionToSite -ApplicationId "11111111-1111-1111-1111-111111111111" `
    -SiteUrl "https://contoso.sharepoint.com/sites/Marketing" `
    -Permission read -WhatIf
```

`-SiteUrl` is resolved to an exact site via its hostname and path (not a keyword search).
