# Prints the PinkShell banner in hot pink.

function Show-PinkBanner {
    [CmdletBinding()]
    [OutputType([void])]
    param()

    $banner = @'
██████╗ ██╗███╗   ██╗██╗  ██╗███████╗██╗  ██╗███████╗██╗     ██╗
██╔══██╗██║████╗  ██║██║ ██╔╝██╔════╝██║  ██║██╔════╝██║     ██║
██████╔╝██║██╔██╗ ██║█████╔╝ ███████╗███████║█████╗  ██║     ██║
██╔═══╝ ██║██║╚██╗██║██╔═██╗ ╚════██║██╔══██║██╔══╝  ██║     ██║
██║     ██║██║ ╚████║██║  ██╗███████║██║  ██║███████╗███████╗███████╗
╚═╝     ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝
'@

    if ($PSStyle) {
        $pink = $PSStyle.Foreground.FromRgb(255, 105, 180)
        Write-Host "$pink$banner$($PSStyle.Reset)"
    }
    else {
        Write-Host $banner -ForegroundColor Magenta
    }
}
