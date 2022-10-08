<#
    .SYNOPSIS
        Pester tests for functions in the "BaseURI.ps1" file

    .DESCRIPTION
        Pester tests for functions in the "BaseURI.ps1" file which
        is apart of the FanartTvAPI module.

    .EXAMPLE
        Invoke-Pester -Path .\Tests\BaseURI.Tests.ps1

        Runs a pester test against "BaseURI.Tests.ps1" and outputs simple test results.

    .EXAMPLE
        Invoke-Pester -Path .\Tests\BaseURI.Tests.ps1 -Output Detailed

        Runs a pester test against "BaseURI.Tests.ps1" and outputs detailed test results.

    .NOTES
        Build out more robust, logical, & scalable pester tests.
        Look into BeforeAll as it is not working as expected with this test

    .LINK
        https://github.com/Celerium/FanartTV-PowerShellWrapper
        https://fanarttv.docs.apiary.io
#>

#Requires -Version 5.0
#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }
#Requires -Modules @{ ModuleName='FanartTvAPI'; ModuleVersion='1.0.0' }

# General variables
    $FullFileName = $MyInvocation.MyCommand.Name
    #$ThisFile = $PSCommandPath -replace '\.Tests\.ps1$'
    #$ThisFileName = $ThisFile | Split-Path -Leaf


Describe " Testing [ *-FanartTvBaseURI } functions with [ $FullFileName ]" {

    Context "[ Add-FanartTvBaseURI ] testing functions" {

        It "[ Add-FanartTvBaseURI ] without parameter should return a valid URI" {
            Add-FanartTvBaseURI
            Get-FanartTvBaseURI | Should -Be 'https://webservice.fanart.tv/v3'
        }

        It "[ Add-FanartTvBaseURI ] should accept a value from the pipeline" {
            'https://celerium.org' | Add-FanartTvBaseURI
            Get-FanartTvBaseURI | Should -Be 'https://celerium.org'
        }

        It "[ Add-FanartTvBaseURI ] with parameter -base_uri should return a valid URI" {
            Add-FanartTvBaseURI -base_uri 'https://celerium.org'
            Get-FanartTvBaseURI | Should -Be 'https://celerium.org'
        }

        It "[ Add-FanartTvBaseURI ] a trailing / from a base_uri should be removed" {
            Add-FanartTvBaseURI -base_uri 'https://celerium.org/'
            Get-FanartTvBaseURI | Should -Be 'https://celerium.org'
        }
    }

    Context "[ Get-FanartTvBaseURI ] testing functions" {

        It "[ Get-FanartTvBaseURI ] should return a valid URI" {
            Add-FanartTvBaseURI
            Get-FanartTvBaseURI | Should -Be 'https://webservice.fanart.tv/v3'
        }

        It "[ Get-FanartTvBaseURI ] value should be a string" {
            Add-FanartTvBaseURI
            Get-FanartTvBaseURI | Should -BeOfType string
        }
    }

    Context "[ Remove-FanartTvBaseURI ] testing functions" {

        It "[ Remove-FanartTvBaseURI ] should remove the variable" {
            Add-FanartTvBaseURI
            Remove-FanartTvBaseURI
            $FanartTv_Base_URI | Should -BeNullOrEmpty
        }
    }

}