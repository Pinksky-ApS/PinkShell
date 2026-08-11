# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## 0.2.0 - 2026-Aug-11

### Changed

- Sign-in now uses the [Pinksky Management Shell](https://pinksky.dk/management-shell)
  application instead of `Microsoft Graph Command Line Tools`. This is what allows the
  Web Account Manager (WAM) broker to be disabled - WAM can't be turned off when using the
  SDK's default application - so sign-in opens a browser tab with a normal account picker
  rather than silently reusing the signed-in Windows account.
- Permissions are no longer requested at sign-in. PinkShell connects with `/.default`, so a
  tenant that hasn't consented is taken through the full consent flow for the application
  rather than being granted a partial subset.
- Every run signs out of any existing Microsoft Graph session and signs in fresh, so moving
  between tenants no longer silently reuses the previous one. The success message now shows
  the account and tenant you connected to.

### Added

- If a tenant has consented to only part of the application, PinkShell reports which
  permissions are missing, opens the admin consent page, and reconnects afterwards.

## 0.1.0 - 2026-Jul-01

Initial release.

### `Add-PinkPermissionsToManagedIdentity`

Grants Microsoft Graph and/or SharePoint Online permissions to a managed identity, as
application or delegated permissions.

- `-ManagedIdentityObjectId <guid>` - the managed identity to grant permissions to.
- `-Application` / `-Delegated <string[]>` - resource-qualified permission values
  (`"Graph:User.Read.All"`, `"SharePoint:Sites.Selected"`), disambiguating scope names
  that exist on both resources. Tab-completion is fetched from the live Graph +
  SharePoint catalog; any valid scope works even if it's not offered.
- Idempotent - re-granting an existing permission is a no-op.
- Supports `-WhatIf` / `-Confirm`.
- Returns a summary of the managed identity's current permissions.

### `Add-PinkSitesSelectedPermissionToSite`

Grants an application read, write, owner, or fullcontrol access to a single SharePoint
site via the `Sites.Selected` permission model.

- `-ApplicationId <guid>` (alias `-ClientId`), `-SiteUrl <string>`,
  `-Permission <read|write|owner|fullcontrol>`.
- `-SiteUrl` resolves to the exact site via its hostname and path.
- Supports `-WhatIf` / `-Confirm`.

### Setup

- Nothing to install - run the one-liner in a PowerShell 7+ session to load PinkShell
  into that session, connect to Microsoft Graph, and cache the permission catalog.
- Ships as a PowerShell module (`PinkShell.psd1`/`PinkShell.psm1`), installing only the
  four `Microsoft.Graph.*` sub-modules it needs (`Authentication`, `Applications`,
  `Identity.SignIns`, `Sites`).
- MIT license.
