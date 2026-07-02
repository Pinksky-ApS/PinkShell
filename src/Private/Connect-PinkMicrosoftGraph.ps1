# Connects to Microsoft Graph if not already connected, or reconnects if the current
# session is missing a required scope.

$PinkNeededGraphScopes = @(
    "AppRoleAssignment.ReadWrite.All",
    "Application.Read.All",
    "Sites.FullControl.All",
    "DelegatedPermissionGrant.ReadWrite.All"
)

function Connect-PinkMicrosoftGraph {
    [CmdletBinding()]
    [OutputType([void])]
    param()

    if (-not (Test-PinkIsMicrosoftGraphConnected)) {
        Connect-MgGraph -Scopes $PinkNeededGraphScopes -NoWelcome
        Write-Host "✅ - Microsoft Graph has been connected" -ForegroundColor Magenta
        return
    }

    Write-Host "⚠️ - Microsoft Graph is already connected, checking scopes" -ForegroundColor Yellow
    $currentScopes = (Get-MgContext).Scopes
    $missingScopes = @($PinkNeededGraphScopes | Where-Object { $currentScopes -notcontains $_ })
    if ($missingScopes.Count -eq 0) {
        Write-Host "✅ - All required scopes are present" -ForegroundColor Magenta
        return
    }

    Write-Warning "Missing required scope(s): $($missingScopes -join ', ') - reconnecting to Microsoft Graph with all required scopes"
    Connect-MgGraph -Scopes $PinkNeededGraphScopes -NoWelcome
    Write-Host "✅ - Microsoft Graph has been connected" -ForegroundColor Magenta
}
