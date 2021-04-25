$script:dscModuleName = 'OpenfireDsc'
$script:dscResourceFriendlyName = 'OpenfireJiveProperty'
$script:dscResourceName = "$($script:dscResourceFriendlyName)"

try
{
    Import-Module -Name DscResource.Test -Force -ErrorAction 'Stop'
}
catch [System.IO.FileNotFoundException]
{
    throw 'DscResource.Test module dependency not found. Please run ".\build.ps1 -Tasks build" first.'
}

$initializationParams = @{
    DSCModuleName = $script:dscModuleName
    DSCResourceName = $script:dscResourceName
    ResourceType = 'Class'
    TestType = 'Integration'
}
$script:testEnvironment = Initialize-TestEnvironment @initializationParams

# Using try/finally to always cleanup.
try
{
    #region Integration Tests
    $configurationFile = Join-Path -Path $PSScriptRoot -ChildPath "$($script:dscResourceName).config.ps1"
    . $configurationFile

    Describe "$($script:dscResourceName)_Integration" {
        BeforeAll {
            $resourceId = "[$($script:dscResourceFriendlyName)]Integration_Test"
        }

        $configurations = @(
            "$($script:dscResourceName)_CreateProperty_Config"
            "$($script:dscResourceName)_ModifyProperty_Config"
            "$($script:dscResourceName)_DeleteProperty_Config"
            "$($script:dscResourceName)_CreateProperty2_Config"
            "$($script:dscResourceName)_CreatePropertyEnc_Config"
            "$($script:dscResourceName)_ModifyPropertyEnc_Config"
            "$($script:dscResourceName)_DeletePropertyEnc_Config"
            "$($script:dscResourceName)_CreateProperty2Enc_Config"
        )

        foreach ($configurationName in $configurations)
        {
            Context ('When using configuration {0}' -f $configurationName) {
                It 'Should compile and apply the MOF without throwing' {
                    {
                        $configurationParameters = @{
                            OutputPath        = $TestDrive
                            ConfigurationData = $ConfigurationData
                        }

                        & $configurationName @configurationParameters

                        $startDscConfigurationParameters = @{
                            Path         = $TestDrive
                            ComputerName = 'localhost'
                            Wait         = $true
                            Verbose      = $true
                            Force        = $true
                            ErrorAction  = 'Stop'
                        }

                        Start-DscConfiguration @startDscConfigurationParameters
                    } | Should -Not -Throw
                }

                It 'Should be able to call Get-DscConfiguration without throwing' {
                    {
                        $script:currentConfiguration = Get-DscConfiguration -Verbose -ErrorAction Stop
                    } | Should -Not -Throw
                }

                It 'Should have set the resource and all the parameters should match' {
                    $resourceCurrentState = $script:currentConfiguration | Where-Object -FilterScript {
                        $_.ConfigurationName -eq $configurationName -and $_.ResourceId -eq $resourceId
                    }
                    $shouldBeData = $ConfigurationData.NonNodeData.$configurationName

                    # Key properties
                    $resourceCurrentState.OpenfireHome | Should -Be $shouldBeData.OpenfireHome
                    $resourceCurrentState.PropertyName | Should -Be $shouldBeData.PropertyName

                    if ($configurationName -match 'Delete')
                    {
                        $resourceCurrentState.Value | Should -Be ([System.String]::Empty)
                        $resourceCurrentState.Ensure | Should -Be 'Absent'
                    }
                    else
                    {
                        $resourceCurrentState.Value | Should -Be $shouldBeData.Value
                        $resourceCurrentState.Ensure | Should -Be 'Present'
                    }

                    # Optional properties
                    $resourceCurrentState.Encrypted | Should -Be $shouldBeData.Encrypted

                    # Defaulted properties
                    $resourceCurrentState.ConfigFileName | Should -Be 'openfire.Jive'
                }

                It 'Should return $true when Test-DscConfiguration is run' {
                    Test-DscConfiguration -Verbose | Should -Be 'True'
                }
            }

            Wait-ForIdleLcm -Clear
        }
    }
    #endregion
}
finally
{
    Restore-TestEnvironment -TestEnvironment $script:testEnvironment
}
