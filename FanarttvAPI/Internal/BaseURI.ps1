function Add-FanartTvBaseURI {
<#
    .SYNOPSIS
        Sets the base URI for the FanartTv API connection.

    .DESCRIPTION
        The Add-FanartTvBaseURI cmdlet sets the base URI which is later used to construct the full URI for all API calls.

    .PARAMETER base_uri
        Define the base URI for the FanartTv API connection using FanartTv's URI or a custom URI.

    .EXAMPLE
        Add-FanartTvBaseURI

        The base URI will use https://webservice.fanart.tv/v3 which is FanartTv's default URI.

    .EXAMPLE
        Add-FanartTvBaseURI -base_uri http://myapi.gateway.example.com

        A custom API gateway of http://myapi.gateway.example.com will be used for all API calls to FanartTv's reporting API.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/FanartTV-PowerShellWrapper
        https://fanarttv.docs.apiary.io
#>

    [cmdletbinding()]
    Param (
        [parameter(ValueFromPipeline)]
        [string]$base_uri = 'https://webservice.fanart.tv/v3'
    )

    # Trim superfluous forward slash from address (if applicable)
    if ($base_uri[$base_uri.Length-1] -eq "/") {
        $base_uri = $base_uri.Substring(0,$base_uri.Length-1)
    }

    Set-Variable -Name "FanartTv_Base_URI" -Value $base_uri -Option ReadOnly -Scope global -Force
}

function Get-FanartTvBaseURI {
<#
    .SYNOPSIS
        Shows the FanartTv base URI global variable.

    .DESCRIPTION
        The Get-FanartTvBaseURI cmdlet shows the FanartTv base URI global variable value.

    .EXAMPLE
        Get-FanartTvBaseURI

        Shows the FanartTv base URI global variable value.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/FanartTV-PowerShellWrapper
        https://fanarttv.docs.apiary.io
#>

    [cmdletbinding()]
    Param ()

    if ($FanartTv_Base_URI){
        $FanartTv_Base_URI
    }
    Else{
        Write-Host "The FanartTv base URI is not set. Run Add-FanartTvBaseURI to set the base URI." -ForegroundColor Yellow
    }
}

function Remove-FanartTvBaseURI {
<#
    .SYNOPSIS
        Removes the FanartTv base URI global variable.

    .DESCRIPTION
        The Remove-FanartTvBaseURI cmdlet removes the FanartTv base URI global variable.

    .EXAMPLE
        Remove-FanartTvBaseURI

        Removes the FanartTv base URI global variable.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/FanartTV-PowerShellWrapper
        https://fanarttv.docs.apiary.io
#>

    [cmdletbinding()]
    Param ()

    if ($FanartTv_Base_URI) {
        Remove-Variable -Name "FanartTv_Base_URI" -Scope global -Force
    }
    Else{
        Write-Warning "The FanartTv base URI variable is not set. Nothing to remove"
    }
}

New-Alias -Name Set-FanartTvBaseURI -Value Add-FanartTvBaseURI