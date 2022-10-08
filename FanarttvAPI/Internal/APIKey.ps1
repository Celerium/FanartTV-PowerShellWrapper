function Add-FanartTvAPIKey {
<#
    .SYNOPSIS
        Sets your API key used to authenticate all API calls.

    .DESCRIPTION
        The Add-FanartTvAPIKey cmdlet sets your API key which is used to authenticate all API calls made to FanartTv.
        Once the API key is defined by Add-FanartTvAPIKey, it is encrypted using SecureString.

        The FanartTv API keys are generated via https://fanart.tv/get-an-api-key/

    .PARAMETER Api_Key
        Define your API key that was generated from FanartTv.

    .EXAMPLE
        Add-FanartTvAPIKey

        Prompts to enter in the API Key

    .EXAMPLE
        Add-FanartTvAPIKey -Api_key 'your_api_key'

        The FanartTv API will use the string entered into the [ -Api_Key ] parameter.

    .EXAMPLE
        '123==' | Add-FanartTvAPIKey

        The Add-FanartTvAPIKey function will use the string passed into it as its API key.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/FanartTV-PowerShellWrapper
        https://fanarttv.docs.apiary.io

#>

    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [AllowEmptyString()]
        [Alias('ApiKey')]
        [string]$Api_Key
    )

    if ($Api_Key) {
        $x_api_key = ConvertTo-SecureString $Api_Key -AsPlainText -Force

        Set-Variable -Name "FanartTv_API_Key" -Value $x_api_key -Option ReadOnly -Scope global -Force
    }
    else {
        Write-Host "Please enter your API key:"
        $x_api_key = Read-Host -AsSecureString

        Set-Variable -Name "FanartTv_API_Key" -Value $x_api_key -Option ReadOnly -Scope global -Force
    }
}

function Get-FanartTvAPIKey {
<#
    .SYNOPSIS
        Gets the FanartTv API key global variable.

    .DESCRIPTION
        The Get-FanartTvAPIKey cmdlet gets the FanartTv API key global variable and
        returns it as a SecureString.

    .EXAMPLE
        Get-FanartTvAPIKey

        Gets the FanartTv API key global variable and returns it as a SecureString.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/FanartTV-PowerShellWrapper
        https://fanarttv.docs.apiary.io
#>

    [cmdletbinding()]
    Param ()

    if ($FanartTv_API_Key){
        $FanartTv_API_Key
    }
    Else{
        Write-Warning "The FanartTv API key is not set. Run Add-FanartTvAPIKey to set the API key."
    }
}

function Remove-FanartTvAPIKey {
<#
    .SYNOPSIS
        Removes the FanartTv API key global variable.

    .DESCRIPTION
        The Remove-FanartTvAPIKey cmdlet removes the FanartTv API key global variable.

    .EXAMPLE
        Remove-FanartTvAPIKey

        Removes the FanartTv API key global variable.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/FanartTV-PowerShellWrapper
        https://fanarttv.docs.apiary.io
#>

    [cmdletbinding()]
    Param ()

    if ($FanartTv_API_Key) {
        Remove-Variable -Name "FanartTv_API_Key" -Scope global -Force
    }
    Else{
        Write-Warning "The FanartTv API key variable is not set. Nothing to remove"
    }
}

function Test-FanartTvAPIKey {
<#
    .SYNOPSIS
        Test the FanartTv API key.

    .DESCRIPTION
        The Test-FanartTvAPIKey cmdlet tests the base URI & API key that was defined in the
        Add-FanartTvBaseURI & Add-FanartTvAPIKey cmdlets.

    .PARAMETER base_uri
        Define the base URI for the FanartTv API connection using FanartTv's URI or a custom URI.

        The default base URI is https://webservice.fanart.tv/v3

    .EXAMPLE
        Test-FanartTvBaseURI

        Tests the base URI & API key that was defined in the
        Add-FanartTvBaseURI & Add-FanartTvAPIKey cmdlets.

        The default full base uri test path is:
            https://webservice.fanart.tv/v3/movies

    .EXAMPLE
        Test-FanartTvBaseURI -base_uri http://myapi.gateway.example.com

        Tests the base URI & API key that was defined in the
        -base_uri parameter & Add-FanartTvAPIKey cmdlet.

        The full base uri test path in this example is:
            http://myapi.gateway.example.com/movies

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/FanartTV-PowerShellWrapper
        https://fanarttv.docs.apiary.io
#>

    [cmdletbinding()]
    Param (
        [parameter(ValueFromPipeline)]
        [string]$base_uri = $FanartTv_Base_URI
    )

    if (! $base_uri){
        Write-Error 'The FanartTv base URI is not set. Run Add-FanartTvBaseURI to set the base URI.'
        exit 1
    }

    try {
        $client_key = (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList 'N/A', $FanartTv_API_Key).GetNetworkCredential().Password

        $resource_uri = "/movies/latest?api_key=$client_key"
        $rest_output = Invoke-WebRequest -method 'GET' -uri ($base_uri + $resource_uri) -headers $FanartTv_Headers -ErrorAction Stop
    }
    catch {

        [PSCustomObject]@{
            Method = $_.Exception.Response.Method
            StatusCode = $_.Exception.Response.StatusCode.value__
            StatusDescription = $_.Exception.Response.StatusDescription
            Message = $_.Exception.Message
            URI = $($FanartTv_Base_URI + $resource_uri)
        }

    } finally {
            #Future use
            #[void] ($FanartTv_Headers.Remove('api_key'))
            #[void] ($FanartTv_Headers.Remove('client_key'))
    }

    if ($rest_output){
        $data = @{}
        $data = $rest_output

        [PSCustomObject]@{
            StatusCode = $data.StatusCode
            StatusDescription = $data.StatusDescription
            URI = $($FanartTv_Base_URI + $resource_uri.split('=')[0] + '=*****')
        }
    }
}


New-Alias -Name Set-FanartTvAPIKey -Value Add-FanartTvAPIKey -Force
