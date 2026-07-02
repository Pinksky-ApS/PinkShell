if ($MyInvocation.InvocationName -notin @('.', '')) {
    Write-Host "❌ - Don't run this file directly ('./main-dev.ps1' or '& main-dev.ps1') - every cmdlet it loads would disappear the moment the script finishes, because they'd be scoped to the script instead of your session." -ForegroundColor Red
    Write-Host "❌ - Re-run it dot-sourced instead, so its cmdlets land in your current session:" -ForegroundColor Red
    Write-Host "❌ -     . ./main-dev.ps1" -ForegroundColor Red
    return
}

$ErrorActionPreference = "Stop"

. "$PSScriptRoot/src/Initialize-PinkShell.ps1"
Initialize-PinkShell -ModuleRoot $PSScriptRoot -ProductName "PinkShell - DEV"
