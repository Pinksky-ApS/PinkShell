if ($MyInvocation.InvocationName -notin @('.', '')) {
    Write-Host "❌ - Don't save and run this file directly - every cmdlet it loads would disappear the moment the script finishes, because they'd be scoped to the script instead of your session." -ForegroundColor Red
    Write-Host "❌ - Use the one-liner instead, which doesn't have this problem:" -ForegroundColor Red
    Write-Host '❌ -     irm "https://raw.githubusercontent.com/Pinksky-ApS/PinkShell/refs/heads/main/main.ps1" | iex' -ForegroundColor Red
    return
}

$ErrorActionPreference = "Stop"
$ProductName = "PinkShell"
$gitRef = "main"
$archiveUrl = "https://github.com/Pinksky-ApS/PinkShell/archive/refs/heads/$gitRef.zip"

$downloadRoot = Join-Path ([System.IO.Path]::GetTempPath()) "PinkShell-$([guid]::NewGuid())"

try {

    # GitHub serves a zip of any branch/tag for free - one request for the whole repo,
    # and main.ps1 never needs its own list of which files PinkShell ships.
    Write-Host "⌛ - Downloading $ProductName ($gitRef)" -ForegroundColor Magenta
    New-Item -ItemType Directory -Path $downloadRoot -Force | Out-Null
    $archivePath = Join-Path $downloadRoot "$ProductName.zip"
    Invoke-WebRequest -Uri $archiveUrl -OutFile $archivePath
    Expand-Archive -Path $archivePath -DestinationPath $downloadRoot -Force

    # The zip wraps everything in a single "{repo}-{ref}" folder.
    $moduleRoot = (Get-ChildItem -Path $downloadRoot -Directory | Select-Object -First 1).FullName

    . (Join-Path $moduleRoot "src/Initialize-PinkShell.ps1")
    Initialize-PinkShell -ModuleRoot $moduleRoot -ProductName $ProductName

}
catch {
    Write-Host "❌ - $ProductName failed to download" -ForegroundColor Red
    Write-Host "❌ - Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "❌ - Please fix the error and try again" -ForegroundColor Red
}
finally {
    Remove-Item -Path $downloadRoot -Recurse -Force -ErrorAction SilentlyContinue
}
