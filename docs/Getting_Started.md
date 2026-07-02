# Getting started

> [!IMPORTANT]
> PinkShell is designed to be run with PowerShell 7.x and above, and **WILL NOT** work
> with Windows PowerShell.
>
> The latest version of PowerShell can be downloaded from [here](https://aka.ms/powershell-release?tag=stable).

PinkShell isn't a "module" in the sense that you install it on your machine. Instead you
run it straight from the repository whenever you need it, and it's only available in
that session.

To use it, run the following in a PowerShell 7 session:

```powershell
irm "https://raw.githubusercontent.com/Pinksky-ApS/PinkShell/refs/heads/main/main.ps1" | iex
```

## What happens next

1. **PowerShell version check** - PinkShell stops with a link to the installer if you're
   not on 7+.
2. **Cmdlets load** into your current session.
3. **Prerequisites are checked** - the four `Microsoft.Graph.*` sub-modules PinkShell
   needs (`Authentication`, `Applications`, `Identity.SignIns`, `Sites`) are installed for
   your user if missing, rather than the full `Microsoft.Graph` meta-module.
4. **Sign-in** with an admin account.
5. **Consent** to the `Microsoft Graph Command Line Tools` application (the standard
   Graph PowerShell SDK app, not something custom to PinkShell).
6. **Ready** - PinkShell prints a success message.

## Using it again in an already-connected session

Re-running the one-liner reuses an existing Graph connection if it already has the scopes
PinkShell needs, and reconnects with the full set if not.

## Next steps

See the [cmdlet reference](cmdlets) for `Add-PinkPermissionsToManagedIdentity` and
`Add-PinkSitesSelectedPermissionToSite`, including examples of the resource-qualified
permission syntax.
