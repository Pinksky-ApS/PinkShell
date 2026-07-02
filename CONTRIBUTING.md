# Contributing to PinkShell

PinkShell is a small library - one simple cmdlet per otherwise-fiddly M365 admin task.

## Local setup

```powershell
git clone https://github.com/Pinksky-ApS/PinkShell.git
cd PinkShell
. ./main-dev.ps1
```

This loads PinkShell from your local checkout, connects to Microsoft Graph, and caches
the permission catalog, same as the published one-liner.

## Contributing

Open a PR. New files under `src/Public` or `src/Private` load automatically - no
registration needed beyond adding the function to `PinkShell.psd1`'s `FunctionsToExport`
if it's meant to be public.

For bugs, open an issue with the cmdlet call and the error you got.
