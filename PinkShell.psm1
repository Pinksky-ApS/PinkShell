$ErrorActionPreference = 'Stop'

# Load every Private file, then every Public file - order doesn't matter beyond that.
$privateFiles = Get-ChildItem -Path "$PSScriptRoot/src/Private" -Filter '*.ps1' -File
$publicFiles = Get-ChildItem -Path "$PSScriptRoot/src/Public" -Filter '*.ps1' -File

foreach ($file in ($privateFiles + $publicFiles)) {
    . $file.FullName
}

Export-ModuleMember -Function @(
    'Add-PinkPermissionsToManagedIdentity',
    'Add-PinkSitesSelectedPermissionToSite'
)
