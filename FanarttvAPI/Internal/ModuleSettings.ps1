function Export-FanartTvModuleSettings {
<#
    .SYNOPSIS
        Exports the FanartTv BaseURI, API, & JSON configuration information to file.

    .DESCRIPTION
        The Export-FanartTvModuleSettings cmdlet exports the FanartTv BaseURI, API, & JSON configuration information to file.

        Making use of PowerShell's System.Security.SecureString type, exporting module settings encrypts your API key in a format
        that can only be unencrypted with the your Windows account as this encryption is tied to your user principal.
        This means that you cannot copy your configuration file to another computer or user account and expect it to work.

    .PARAMETER FanartTvAPIConfPath
        Define the location to store the FanartTv configuration file.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\FanartTvAPI

    .PARAMETER FanartTvAPIConfFile
        Define the name of the FanartTv configuration file.

        By default the configuration file is named:
            config.psd1

    .EXAMPLE
        Export-FanartTvModuleSettings

        Validates that the BaseURI, API, and JSON depth are set then exports their values
        to the current user's FanartTv configuration file located at:
            $env:USERPROFILE\FanartTvAPI\config.psd1

    .EXAMPLE
        Export-FanartTvModuleSettings -FanartTvAPIConfPath C:\FanartTvAPI -FanartTvAPIConfFile MyConfig.psd1

        Validates that the BaseURI, API, and JSON depth are set then exports their values
        to the current user's FanartTv configuration file located at:
            C:\FanartTvAPI\MyConfig.psd1

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/FanartTV-PowerShellWrapper
        https://fanarttv.docs.apiary.io

#>

    [CmdletBinding(DefaultParameterSetName = 'set')]
    Param (
        [Parameter(ParameterSetName = 'set')]
        [string]$FanartTvAPIConfPath = "$($env:USERPROFILE)\FanartTvAPI",

        [Parameter(ParameterSetName = 'set')]
        [string]$FanartTvAPIConfFile = 'config.psd1'
    )

    # Confirm variables exist and are not null before exporting
    if ($FanartTv_Base_URI -and $FanartTv_API_Key -and $FanartTv_JSON_Conversion_Depth) {
        $secureString = $FanartTv_API_KEY | ConvertFrom-SecureString
        New-Item -ItemType Directory -Force -Path $FanartTvAPIConfPath | ForEach-Object {$_.Attributes = 'hidden'}
@"
    @{
        FanartTv_Base_URI = '$FanartTv_Base_URI'
        FanartTv_API_Key = '$secureString'
        FanartTv_JSON_Conversion_Depth = '$FanartTv_JSON_Conversion_Depth'
    }
"@ | Out-File -FilePath ($FanartTvAPIConfPath+"\"+$FanartTvAPIConfFile) -Force
    }
    else {
        Write-Host "Failed export FanartTv Module settings to [ $FanartTvAPIConfPath\$FanartTvAPIConfFile ]" -ForegroundColor Red
    }
}

function Import-FanartTvModuleSettings {
<#
    .SYNOPSIS
        Imports the FanartTv BaseURI, API, & JSON configuration information to the current session.

    .DESCRIPTION
        The Import-FanartTvModuleSettings cmdlet imports the FanartTv BaseURI, API, & JSON configuration
        information stored in the FanartTv configuration file to the users current session.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\FanartTvAPI

    .PARAMETER FanartTvAPIConfPath
        Define the location to store the FanartTv configuration file.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\FanartTvAPI

    .PARAMETER FanartTvAPIConfFile
        Define the name of the FanartTv configuration file.

        By default the configuration file is named:
            config.psd1

    .EXAMPLE
        Import-FanartTvModuleSettings

        Validates that the configuration file created with the Export-FanartTvModuleSettings cmdlet exists
        then imports the stored data into the current users session.

        The default location of the FanartTv configuration file is:
            $env:USERPROFILE\FanartTvAPI\config.psd1

    .EXAMPLE
        Import-FanartTvModuleSettings -FanartTvAPIConfPath C:\FanartTvAPI -FanartTvAPIConfFile MyConfig.psd1

        Validates that the configuration file created with the Export-FanartTvModuleSettings cmdlet exists
        then imports the stored data into the current users session.

        The location of the FanartTv configuration file in this example is:
            C:\FanartTvAPI\MyConfig.psd1

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/FanartTV-PowerShellWrapper
        https://fanarttv.docs.apiary.io

#>

    [CmdletBinding(DefaultParameterSetName = 'set')]
    Param (
        [Parameter(ParameterSetName = 'set')]
        [string]$FanartTvAPIConfPath = "$($env:USERPROFILE)\FanartTvAPI",

        [Parameter(ParameterSetName = 'set')]
        [string]$FanartTvAPIConfFile = 'config.psd1'
    )

    if( test-path ($FanartTvAPIConfPath+"\"+$FanartTvAPIConfFile) ) {
        $tmp_config = Import-LocalizedData -BaseDirectory $FanartTvAPIConfPath -FileName $FanartTvAPIConfFile

            # Send to function to strip potentially superfluous slash (/)
            Add-FanartTvBaseURI $tmp_config.FanartTv_Base_URI

            $tmp_config.FanartTv_API_key = ConvertTo-SecureString $tmp_config.FanartTv_API_key

            Set-Variable -Name "FanartTv_API_Key"  -Value $tmp_config.FanartTv_API_key `
                        -Option ReadOnly -Scope global -Force

            Set-Variable -Name "FanartTv_JSON_Conversion_Depth" -Value $tmp_config.FanartTv_JSON_Conversion_Depth `
                        -Scope global -Force

        Write-Host "FanartTvAPI Module configuration loaded successfully from [ $FanartTvAPIConfPath\$FanartTvAPIConfFile ]" -ForegroundColor Green

        # Clean things up
        Remove-Variable "tmp_config"
    }
    else {
        Write-Verbose "No configuration file found at [ $FanartTvAPIConfPath\$FanartTvAPIConfFile ]"
        Write-Verbose "Please run Add-FanartTvAPIKey to get started."

            Set-Variable -Name "FanartTv_Base_URI" -Value "https://webservice.fanart.tv/v3" -Option ReadOnly -Scope global -Force
            Set-Variable -Name "FanartTv_JSON_Conversion_Depth" -Value 100 -Scope global -Force
    }
}

function Remove-FanartTvModuleSettings {
<#
    .SYNOPSIS
        Removes the stored FanartTv configuration folder.

    .DESCRIPTION
        The Remove-FanartTvModuleSettings cmdlet removes the FanartTv folder and its files.
        This cmdlet also has the option to remove sensitive FanartTv variables as well.

        By default configuration files are stored in the following location and will be removed:
            $env:USERPROFILE\FanartTvAPI

    .PARAMETER FanartTvAPIConfPath
        Define the location of the FanartTv configuration folder.

        By default the configuration folder is located at:
            $env:USERPROFILE\FanartTvAPI

    .PARAMETER AndVariables
        Define if sensitive FanartTv variables should be removed as well.

        By default the variables are not removed.

    .EXAMPLE
        Remove-FanartTvModuleSettings

        Checks to see if the default configuration folder exists and removes it if it does.

        The default location of the FanartTv configuration folder is:
            $env:USERPROFILE\FanartTvAPI

    .EXAMPLE
        Remove-FanartTvModuleSettings -FanartTvAPIConfPath C:\FanartTvAPI -AndVariables

        Checks to see if the defined configuration folder exists and removes it if it does.
        If sensitive FanartTv variables exist then they are removed as well.

        The location of the FanartTv configuration folder in this example is:
            C:\FanartTvAPI

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/FanartTV-PowerShellWrapper
        https://fanarttv.docs.apiary.io

#>

    [CmdletBinding(DefaultParameterSetName = 'set')]
    Param (
        [Parameter(ParameterSetName = 'set')]
        [string]$FanartTvAPIConfPath = "$($env:USERPROFILE)\FanartTvAPI",

        [Parameter(ParameterSetName = 'set')]
        [switch]$AndVariables
    )

    if(Test-Path $FanartTvAPIConfPath)  {

        Remove-Item -Path $FanartTvAPIConfPath -Recurse -Force

        If ($AndVariables) {
            if ($FanartTv_API_Key) {
                Remove-Variable -Name "FanartTv_API_Key" -Scope global -Force
            }
            if ($FanartTv_Base_URI) {
                Remove-Variable -Name "FanartTv_Base_URI" -Scope global -Force
            }
        }

            if (!(Test-Path $FanartTvAPIConfPath)) {
                Write-Host "The FanartTvAPI configuration folder has been removed successfully from [ $FanartTvAPIConfPath ]" -ForegroundColor Green
            }
            else {
                Write-Host "The FanartTvAPI configuration folder could not be removed from [ $FanartTvAPIConfPath ]" -ForegroundColor Red
            }

    }
    else {
        Write-Host "No configuration folder found at [ $FanartTvAPIConfPath ]" -ForegroundColor Yellow
    }
}