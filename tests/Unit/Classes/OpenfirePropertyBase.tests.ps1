$ProjectPath = "$PSScriptRoot\..\..\.." | Convert-Path
$ProjectName = (Get-ChildItem $ProjectPath\*\*.psd1 | Where-Object {
        ($_.Directory.Name -match 'source|src' -or $_.Directory.Name -eq $_.BaseName) -and
        $(try
            {
                Test-ModuleManifest $_.FullName -ErrorAction Stop
            }
            catch
            {
                $false
            }) }
).BaseName

Import-Module $ProjectName

InModuleScope $ProjectName {
    Describe OpenfirePropertyBase {
        Context 'OpenfirePropertyBase\Constructors' {
            It 'Should not throw an exception when instantiated' {
                { [OpenfirePropertyBase]::new() } | Should -Not -Throw
            }

            It 'Has a default or empty constructor' {
                $instance = [OpenfirePropertyBase]::new()
                $instance | Should -Not -BeNullOrEmpty
            }
        }

        Context 'OpenfirePropertyBase\Type creation' {
            BeforeEach {
                $script:instanceDesiredState = [OpenfirePropertyBase] @{
                    OpenfireHome = 'C:\Program Files\Openfire'
                    PropertyName = 'purple.people'
                    Value        = 'eater'
                    Ensure       = 'Present'
                }
            }

            It 'Should be type named OpenfirePropertyBase' {
                $script:instanceDesiredState.GetType().Name | Should -Be 'OpenfirePropertyBase'
            }

            It 'Should throw calling CreateProperty()' {
                { $script:instanceDesiredState.CreateProperty() } | Should -Throw -ExpectedMessage "'CreateProperty()' is not implemented. (OB0001)"
            }

            It 'Should throw calling ReadProperty()' {
                { $script:instanceDesiredState.ReadProperty() } | Should -Throw -ExpectedMessage "'ReadProperty()' is not implemented. (OB0001)"
            }

            It 'Should throw calling UpdateProperty()' {
                { $script:instanceDesiredState.UpdateProperty() } | Should -Throw -ExpectedMessage "'UpdateProperty()' is not implemented. (OB0001)"
            }

            It 'Should throw calling DeleteProperty()' {
                { $script:instanceDesiredState.DeleteProperty() } | Should -Throw -ExpectedMessage "'DeleteProperty()' is not implemented. (OB0001)"
            }
        }
    }

    Describe 'OpenfirePropertyBase\Testing Get Method' -Tag 'Get' {
        BeforeEach {
            $script:instanceDesiredState = [OpenfirePropertyBase] @{
                OpenfireHome = 'C:\Program Files\Openfire'
                PropertyName = 'purple.people'
                Value        = 'eater'
                Ensure       = 'Present'
            }
        }

        It 'Should throw' {
            { $script:instanceDesiredState.Get() } | Should -Throw -ExpectedMessage ("'{0}' is not implemented. (OB0001)" -f "ReadProperty()")
        }

    }

    Describe "OpenfirePropertyBase\Testing Test Method" -Tag 'Test' {
        BeforeEach {
            $script:instanceDesiredState = [OpenfirePropertyBase] @{
                OpenfireHome   = 'C:\Program Files\Openfire'
                ConfigFileName = 'openfire.xml'
                PropertyName   = 'purple.people'
                Value          = 'eater'
                Ensure         = 'Present'
            }

            # Return the value requested
            $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name ReadProperty -Value {
                Write-Verbose "Mock value '$($script:instanceDesiredState.Value)' for ReadProperty() called."
                $script:instanceDesiredState.Value
            } -Force

            $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name UpdateProperty -Value {
                Write-Verbose "Mock value for CreateProperty() called."
            } -Force

            $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name CreateProperty -Value {
                Write-Verbose "Mock value for CreateProperty() called."
            } -Force

            $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name DeleteProperty -Value {
                Write-Verbose "Mock value for DeleteProperty() called."
            } -Force
        }

        It 'Should throw' {
            { $script:instanceDesiredState.Test() } | Should -Not -Throw
        }
    }

    Describe "OpenfirePropertyBase\Testing Set Method" -Tag 'Set' {

        BeforeEach {
            $script:instanceDesiredState = [OpenfirePropertyBase] @{
                OpenfireHome = 'C:\Program Files\Openfire'
                PropertyName = 'purple.people'
                Value        = 'eater'
                Ensure       = 'Present'
            }

            # Return the value requested
            $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name ReadProperty -Value {
                Write-Verbose "Mock value '$($script:instanceDesiredState.Value)' for ReadProperty() called."
                $script:instanceDesiredState.Value
            } -Force

            $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name UpdateProperty -Value {
                Write-Verbose "Mock value for CreateProperty() called."
            } -Force

            $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name CreateProperty -Value {
                Write-Verbose "Mock value for CreateProperty() called."
            } -Force

            $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name DeleteProperty -Value {
                Write-Verbose "Mock value for DeleteProperty() called."
            } -Force
        }

        It 'Should throw' {
            { $script:instanceDesiredState.Set() } | Should -Not -Throw
        }
    }
}
