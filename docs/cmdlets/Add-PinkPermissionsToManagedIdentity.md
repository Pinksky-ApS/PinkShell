# Add-PinkPermissionsToManagedIdentity

Grants Microsoft Graph and/or SharePoint Online permissions to a managed identity -
either as application (app role) permissions, or as delegated (OAuth2 permission grant)
permissions.

## Why resource-qualified scopes?

Some scope names (e.g. `Sites.Read.All`, `User.Read.All`) exist on both the Microsoft
Graph and SharePoint Online service principals. Prefixing values with `Graph:` or
`SharePoint:` removes the ambiguity.

## Where the scope list comes from

Tab-completion values are pulled dynamically via `Find-MgGraphPermission` (Graph) and your
tenant's SharePoint service principal. Any valid scope still works even if it's not offered
- it's re-validated against the live service principal when granted.

## Syntax

```powershell
Add-PinkPermissionsToManagedIdentity
    -ManagedIdentityObjectId <guid>
    [-Application <string[]>]
    [-Delegated <string[]>]
    [-WhatIf] [-Confirm]
```

| Parameter | Required | Description |
|---|---|---|
| `-ManagedIdentityObjectId` | Yes | The object ID of the managed identity (or app registration's service principal) receiving permissions. |
| `-Application` | No* | One or more resource-qualified app-role permissions to grant, e.g. `"Graph:User.Read.All"`. |
| `-Delegated` | No* | One or more resource-qualified delegated permissions to grant, e.g. `"Graph:Files.Read"`. |

\* At least one of `-Application` / `-Delegated` must be supplied.

Granting is idempotent - re-running the same command is safe. Pass `-WhatIf` to preview
without making a change.

## Examples

Grant a managed identity read access to users via Graph, and `Sites.Selected` on
SharePoint, as application permissions:

```powershell
Add-PinkPermissionsToManagedIdentity -ManagedIdentityObjectId "22222222-2222-2222-2222-222222222222" `
    -Application "Graph:User.Read.All", "SharePoint:Sites.Selected"
```

Grant a mix of application and delegated permissions in one call:

```powershell
Add-PinkPermissionsToManagedIdentity -ManagedIdentityObjectId "22222222-2222-2222-2222-222222222222" `
    -Application "Graph:User.Read.All", "SharePoint:Sites.Selected" `
    -Delegated   "Graph:Files.Read"
```

The cmdlet also returns the same summary as an object
(`ManagedIdentityObjectId`/`Application`/`Delegated`), so you can capture and script
against it:

```powershell
$result = Add-PinkPermissionsToManagedIdentity -ManagedIdentityObjectId "22222222-2222-2222-2222-222222222222" `
    -Application "Graph:User.Read.All"
$result.Application | Format-Table
```
