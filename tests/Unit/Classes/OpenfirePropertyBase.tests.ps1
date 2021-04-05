$ProjectPath = "$PSScriptRoot\..\..\.." | Convert-Path
$ProjectName = (Get-ChildItem $ProjectPath\*\*.psd1 | Where-Object {
        ($_.Directory.Name -match 'source|src' -or $_.Directory.Name -eq $_.BaseName) -and
        $(try { Test-ModuleManifest $_.FullName -ErrorAction Stop }catch{$false}) }
    ).BaseName

Import-Module $ProjectName

InModuleScope $ProjectName {
    Describe OpenfirePropertyBase {
        Context 'OpenfirePropertyBase\Constructors' {
            It 'Should not throw an exception when instantiated' {
                {[OpenfirePropertyBase]::new()} | Should -Not -Throw
            }

            It 'Has a default or empty constructor' {
                $instance = [OpenfirePropertyBase]::new()
                $instance | Should -Not -BeNullOrEmpty
            }
        }

        Context 'OpenfirePropertyBase\Type creation' {
            It 'Should be type named OpenfirePropertyBase' {
                $instance = [OpenfirePropertyBase]::new()
                $instance.GetType().Name | Should -Be 'OpenfirePropertyBase'
            }
        }
    }

    Describe 'OpenfirePropertyBase\Testing Get Method' -Tag 'Get' {
        BeforeAll {
            $script:mockOpenfireHome = 'C:\Program Files\Openfire'
            $script:mockConfigFileName = 'openfire.xml'
        }

        BeforeEach {
            $script:instanceDesiredState = [OpenfirePropertyBase]::New()
            $script:instanceDesiredState.OpenfireHome = $script:mockOpenfireHome
            $script:instanceDesiredState.ConfigFileName = $script:mockConfigFileName
        }

        It 'Should return the same values passed' {
            { $script:instanceDesiredState.Get() } | Should -Throw -Message "GetCurrentValue() not implemented."
        }

    }

    Describe "OpenfirePropertyBase\Testing Test Method" -Tag 'Test' {
        BeforeAll {
            $script:mockOpenfireHome = 'C:\Program Files\Openfire'
            $script:mockConfigFileName = 'openfire.xml'
        }

        BeforeEach {
            $script:instanceDesiredState = [OpenfirePropertyBase]::New()
            $script:instanceDesiredState.OpenfireHome = $script:mockOpenfireHome
            $script:instanceDesiredState.ConfigFileName = $script:mockConfigFileName
        }

        It 'Should always return $true' {
            { $script:instanceDesiredState.Test() } | Should -Throw -Message "GetCurrentValue() not implemented."
        }
    }

    Describe "OpenfirePropertyBase\Testing Set Method" -Tag 'Set' {
        BeforeAll {
            $script:mockOpenfireHome = 'C:\Program Files\Openfire'
            $script:mockConfigFileName = 'openfire.xml'
        }

        BeforeEach {
            $script:instanceDesiredState = [OpenfirePropertyBase]::New()
            $script:instanceDesiredState.OpenfireHome = $script:mockOpenfireHome
            $script:instanceDesiredState.ConfigFileName = $script:mockConfigFileName
        }

        It 'Should throw' {
            { $script:instanceDesiredState.Set() } | Should -Throw
        }
    }

}
