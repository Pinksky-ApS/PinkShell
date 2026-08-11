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
irm "https://raw.githubusercontent.com/Pinksky-ApS/PinkShell/refs/heads/master/main.ps1" | iex
```

## What happens next

1. **PowerShell version check** - PinkShell stops with a link to the installer if you're
   not on 7+.
2. **Cmdlets load** into your current session.
3. **Prerequisites are checked** - the four `Microsoft.Graph.*` sub-modules PinkShell
   needs (`Authentication`, `Applications`, `Identity.SignIns`, `Sites`) are installed for
   your user if missing, rather than the full `Microsoft.Graph` meta-module.
4. **Sign-in** with an admin account. A browser tab opens and asks which account to use.
5. **Consent** to [Pinksky Management Shell](https://pinksky.dk/management-shell) -
   Pinksky's shared management application, also used by our PnP PowerShell tooling.
   Nothing needs arranging in advance: the first time anyone signs in from a tenant, a
   Global Administrator is shown the consent screen and can approve it for the whole
   organization. If the tenant has already consented to part of the application, PinkShell
   notices what's missing and opens the consent page for you.
6. **Ready** - PinkShell prints a success message with the account and tenant you landed in.

## Using it again in an already-connected session

Every run signs out of the previous Microsoft Graph session and signs in fresh, so
switching between tenants is just a matter of re-running the one-liner and picking a
different account.

## A note on the sign-in window

On Windows, the Graph PowerShell SDK signs in through the Web Account Manager (WAM) broker
by default, which reuses whichever account Windows already knows and can open its window
behind your terminal. PinkShell turns that off with
`Set-MgGraphOption -DisableLoginByWAM $true` so you get a normal browser tab and a proper
account picker.

That setting is global to the Graph PowerShell SDK and persists for your user, not just for
the PinkShell session. It only takes effect when connecting with a custom application, so
anything still using the stock `Microsoft Graph Command Line Tools` app is unaffected.

## Next steps

See the [cmdlet reference](cmdlets) for `Add-PinkPermissionsToManagedIdentity` and
`Add-PinkSitesSelectedPermissionToSite`, including examples of the resource-qualified
permission syntax.
