<#
    .SYNOPSIS
        Pester tests for functions in the "APIKey.ps1" file

    .DESCRIPTION
        Pester tests for functions in the APIKey.ps1 file which
        is apart of the FanartTvAPI module.

    .EXAMPLE
        Invoke-Pester -Path .\Tests\APIKey.Tests.ps1

        Runs a pester test against "APIKey.Tests.ps1" and outputs simple test results.

    .EXAMPLE
        Invoke-Pester -Path .\Tests\APIKey.Tests.ps1 -Output Detailed

        Runs a pester test against "APIKey.Tests.ps1" and outputs detailed test results.

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


Describe "Testing [ *-FanartTvAPIKey ] functions with [ $FullFileName ]" {

    Context "[ Add-FanartTvAPIKey ] testing functions" {

        It "The FanartTv_API_Key variable should initially be empty or null" {
            $FanartTv_API_Key | Should -BeNullOrEmpty
        }

        It "[ Add-FanartTvAPIKey ] should accept a value from the pipeline" {
            "FanartTvAPIKey" | Add-FanartTvAPIKey
            Get-FanartTvAPIKey | Should -Not -BeNullOrEmpty
        }

        It "[ Add-FanartTvAPIKey ] called with parameter -Api_Key should not be empty" {
            Add-FanartTvAPIKey -Api_Key '12345'
            Get-FanartTvAPIKey | Should -Not -BeNullOrEmpty
        }
    }

    Context "[ Get-FanartTvAPIKey ] testing functions" {

        It "[ Get-FanartTvAPIKey ] should return a value" {
            Add-FanartTvAPIKey -Api_Key '12345'
            Get-FanartTvAPIKey | Should -Not -BeNullOrEmpty
        }

        It "[ Get-FanartTvAPIKey ] Api_Key should be a SecureString (With Parameter)" {
            Add-FanartTvAPIKey -Api_Key '12345'
            Get-FanartTvAPIKey | Should -BeOfType SecureString
        }

    }

    Context "[ Remove-FanartTvAPIKey ] testing functions" {

        It "[ Remove-FanartTvAPIKey ] should remove the FanartTv_API_Key variables" {
            Add-FanartTvAPIKey -Api_Key '12345'
            Remove-FanartTvAPIKey
            $FanartTv_API_Key | Should -BeNullOrEmpty
        }
    }

    Context "[ Test-FanartTvAPIKey ] testing functions" {

        It "[ Test-FanartTvAPIKey ] without an API key should fail to authenticate" {
            Add-FanartTvAPIKey -Api_Key '12345'
            Remove-FanartTvAPIKey
            $Value = Test-FanartTvAPIKey
            $Value.Message | Should -BeLike '*"password" is null*'
        }
    }

}