@{
    RootModule        = 'PinkShell.psm1'
    ModuleVersion     = '0.1.0'
    GUID              = 'b15117d1-ccbb-40f0-b6c3-dd9322f53311'
    Author            = 'Dan Toft (Pinksky)'
    CompanyName       = 'Pinksky ApS'
    Copyright         = '(c) Pinksky ApS. All rights reserved.'
    Description       = 'A PowerShell library for admins managing Microsoft 365 tenants - simple cmdlets for permission tasks that have no GUI in the Microsoft 365 or SharePoint admin centers.'
    PowerShellVersion = '7.0'

    # Installed automatically by Enable-PinkModule before PinkShell itself is imported.
    RequiredModules   = @(
        'Microsoft.Graph.Authentication',
        'Microsoft.Graph.Applications',
        'Microsoft.Graph.Identity.SignIns',
        'Microsoft.Graph.Sites'
    )

    FunctionsToExport = @(
        'Add-PinkPermissionsToManagedIdentity',
        'Add-PinkSitesSelectedPermissionToSite'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
