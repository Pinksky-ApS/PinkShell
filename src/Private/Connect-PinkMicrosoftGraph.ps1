# Connects to Microsoft Graph as the Pinksky Management Shell application, signing out of any
# previous session first so moving between tenants never reuses the wrong one.

$PinkShellClientId = "6d0d3035-7631-4a9d-8475-59dd0b1fb189"

# Never requested at sign-in - only used to verify what the tenant actually consented to.
$PinkRequiredGraphScopes = @(
    "Application.Read.All",
    "AppRoleAssignment.ReadWrite.All",
    "DelegatedPermissionGrant.ReadWrite.All",
    "Sites.FullControl.All"
)

function Connect-PinkMicrosoftGraph {
    [CmdletBinding()]
    [OutputType([void])]
    param()

    # WAM (the Windows broker) silently reuses the signed-in Windows account and hides the
    # sign-in window behind the terminal. It can only be disabled when connecting with our
    # own ClientId, which is why PinkShell signs in as Pinksky Management Shell.
    Set-MgGraphOption -DisableLoginByWAM $true

    if (Test-PinkIsMicrosoftGraphConnected) {
        Write-Host "🔄 - Signing out of the previous Microsoft Graph session" -ForegroundColor Yellow
        try {
            Disconnect-MgGraph -ErrorAction Stop | Out-Null
        }
        catch {
            Write-Verbose "Disconnect-MgGraph failed: $($_.Exception.Message)"
        }
    }

    # No -Scopes: the SDK requests /.default, which sends a tenant that has never consented
    # through the full Pinksky Management Shell consent flow.
    Connect-MgGraph -ClientId $PinkShellClientId -NoWelcome
    $context = Get-MgContext
    Write-Host "✅ - Connected to Microsoft Graph as $($context.Account) ($($context.TenantId))" -ForegroundColor Magenta

    $missingScopes = @($PinkRequiredGraphScopes | Where-Object { $context.Scopes -notcontains $_ })
    if ($missingScopes.Count -eq 0) {
        return
    }

    # /.default stays silent when the tenant already consented to *some* permission, so a
    # partially consented tenant has to be sent through consent explicitly.
    $consentUrl = "https://login.microsoftonline.com/$($context.TenantId)/adminconsent?client_id=$PinkShellClientId"
    Write-Host "⚠️ - This tenant hasn't consented to everything PinkShell needs: $($missingScopes -join ', ')" -ForegroundColor Yellow
    Write-Host "🌐 - Opening the Pinksky Management Shell consent page - approve it as a Global Administrator, then return here" -ForegroundColor Magenta
    Write-Host "     $consentUrl" -ForegroundColor DarkGray
    try {
        Start-Process $consentUrl -ErrorAction Stop
    }
    catch {
        Write-Verbose "Couldn't open a browser automatically: $($_.Exception.Message)"
        Write-Host "     (Couldn't open a browser - open the link above yourself)" -ForegroundColor Yellow
    }
    Read-Host "Press Enter once consent has been granted"

    # The token issued before consent doesn't pick up the new grants, so reconnect.
    try {
        Disconnect-MgGraph -ErrorAction Stop | Out-Null
    }
    catch {
        Write-Verbose "Disconnect-MgGraph failed: $($_.Exception.Message)"
    }

    Connect-MgGraph -ClientId $PinkShellClientId -NoWelcome
    $context = Get-MgContext
    Write-Host "✅ - Reconnected to Microsoft Graph as $($context.Account) ($($context.TenantId))" -ForegroundColor Magenta

    $missingScopes = @($PinkRequiredGraphScopes | Where-Object { $context.Scopes -notcontains $_ })
    if ($missingScopes.Count -gt 0) {
        Write-Warning "Still missing: $($missingScopes -join ', ') - PinkShell cmdlets that need these will fail"
    }
}
