```
██████╗ ██╗███╗   ██╗██╗  ██╗███████╗██╗  ██╗███████╗██╗     ██╗
██╔══██╗██║████╗  ██║██║ ██╔╝██╔════╝██║  ██║██╔════╝██║     ██║
██████╔╝██║██╔██╗ ██║█████╔╝ ███████╗███████║█████╗  ██║     ██║
██╔═══╝ ██║██║╚██╗██║██╔═██╗ ╚════██║██╔══██║██╔══╝  ██║     ██║
██║     ██║██║ ╚████║██║  ██╗███████║██║  ██║███████╗███████╗███████╗
╚═╝     ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝
```

# PinkShell

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A PowerShell library, by Pinksky, for admins managing Microsoft 365 tenants.

Microsoft's admin portals don't expose a GUI for some permission tasks - granting a
managed identity a Graph or SharePoint permission, or scoping an app to a single
SharePoint site via `Sites.Selected`. PinkShell gives you a simple cmdlet for each of
those, instead of hand-rolling Graph PowerShell calls every time.

> [!IMPORTANT]
> This is in preview, and is subject to change.
>
> PinkShell isn't meant to be used for automation - it's a simple interface to a couple
> of otherwise-complex tasks. If you're scripting something that runs unattended, use the
> underlying `Microsoft.Graph` cmdlets directly instead.

## Getting started

Nothing to install. Run this in a PowerShell 7+ session whenever you need it - it loads
into that session only, checks your environment, and connects to Microsoft Graph:

```powershell
irm "https://raw.githubusercontent.com/Pinksky-ApS/PinkShell/refs/heads/main/main.ps1" | iex
```

This **will not** run on Windows PowerShell 5.1. See
[`docs/Getting_Started.md`](docs/Getting_Started.md) for the full walkthrough.

## Cmdlets

See [`docs/cmdlets`](docs/cmdlets) for the full list and reference.

## Changelog

See [`CHANGELOG.md`](CHANGELOG.md).

## Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md) for local setup.

## License

[MIT](LICENSE)
