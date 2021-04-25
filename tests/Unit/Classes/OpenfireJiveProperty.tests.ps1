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

    $mockOpenfireHome = Resolve-Path -Path "$PSScriptRoot\..\..\TestOpenfireHome"

    Describe OpenfireJiveProperty {
        Context 'Constructors' {
            It 'Should not throw an exception when instantiated' {
                { [OpenfireJiveProperty]::new() } | Should -Not -Throw
            }

            It 'Has a default or empty constructor' {
                $instance = [OpenfireJiveProperty]::new()
                $instance | Should -Not -BeNullOrEmpty
                $instance.GetType().Name | Should -Be 'OpenfireJiveProperty'
            }
        }

        Context 'Type creation' {
            It 'Should be type named OpenfireJiveProperty' {
                $instance = [OpenfireJiveProperty]::new()
                $instance.GetType().Name | Should -Be 'OpenfireJiveProperty'
            }
        }
    }

    Describe "OpenfireJiveProperty\CRUD functions" -Tag 'Crud' {
        BeforeEach {
            $script:testInstance = [OpenfireJiveProperty] @{
                OpenfireHome = "$($mockOpenfireHome)"
                PropertyName = 'purple.people'
                Value        = 'eater'
            }
        }

        It 'Adds a new XML property value' {
            $script:testInstance.CreateProperty()
        }

        It 'Should return $false when asking if the value is encrypted' {
            $script:testInstance.getIsEncrypted() | Should -BeFalse
        }

        It 'Gets an XML Property Value' {
            $script:testInstance.ReadProperty() | Should -Be $script:testInstance.Value
        }

        It 'Modifies an existing XML property value' {
            { $script:testInstance.UpdateProperty() } | Should -Not -Throw
            $script:testInstance.ReadProperty() | Should -Be $script:testInstance.Value
        }

        It 'Deletes an existing XML property value' {
            { $script:testInstance.DeleteProperty() } | Should -Not -Throw
            $script:testInstance.ReadProperty() | Should -BeNullOrEmpty
        }
    }

    Describe "OpenfireJiveProperty\Get Method" -Tag 'Get' {
        BeforeAll {
            $script:instanceDesiredState = [OpenfireJiveProperty]  @{
                OpenfireHome = "$($mockOpenfireHome)"
                PropertyName = 'purple.people'
                Value        = 'eater'
                Ensure       = 'Present'
            }

            # Track calls to mocked commands
            $script:instanceDesiredState | Add-Member -MemberType NoteProperty -Name methodInvocations -Value ([System.Collections.ArrayList]::new())

            # What should the value of the mock actually be?
            $script:instanceDesiredState | Add-Member -MemberType NoteProperty -Name mockActualValue -Value ''

            # What should the encryption status of the mock actually be?
            $script:instanceDesiredState | Add-Member -MemberType NoteProperty -Name mockActualEncrypted -Value $false

            # Return the mock value
            $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name ReadProperty -Value {
                Write-Verbose "Mock for ReadProperty() called."
                [void] $this.methodInvocations.Add('ReadProperty')
                return $this.mockActualValue
            } -Force

            # Mock the DeleteProperty() method
            $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name DeleteProperty -Value {
                Write-Verbose "Mock for DeleteProperty() called."
                [void] $this.methodInvocations.Add('DeleteProperty')
                $this.mockActualValue = $null
            } -Force

            # Mock the CreateProperty() method
            $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name CreateProperty -Value {
                Write-Verbose "Mock for CreateProperty() called."
                [void] $this.methodInvocations.Add('CreateProperty')
                $this.mockActualValue = $this.Value
            } -Force

            # Mock the UpdateProperty() method
            $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name UpdateProperty -Value {
                Write-Verbose "Mock for UpdateProperty() called."
                [void] $this.methodInvocations.Add('UpdateProperty')
                $this.mockActualValue = $this.Value
            } -Force

            # Mock the getIsEncrypted() method
            $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name getIsEncrypted -Value {
                Write-Verbose "Mock for getIsEncrypted() called."
                [void] $this.methodInvocations.Add('getIsEncrypted')
                return $this.mockActualEncrypted
            } -Force
        }

        Context "OpenfireJiveProperty\Get\When the configuration is absent" {
            BeforeEach {
                # return an empty value to signify a missing value
                $script:instanceDesiredState.mockActualValue = $null
            }

            It 'Should return the state as absent' {
                $script:instanceDesiredState.Get().Ensure | Should -Be 'Absent'
            }

            It 'Should return the same values as present in properties' {
                $getMethodResourceResult = $script:instanceDesiredState.Get()

                $getMethodResourceResult.OpenfireHome | Should -Be $script:instanceDesiredState.OpenfireHome
                $getMethodResourceResult.ConfigFileName | Should -Be $script:instanceDesiredState.ConfigFileName
                $getMethodResourceResult.PropertyName | Should -Be $script:instanceDesiredState.PropertyName
                $getMethodResourceResult.Value | Should -Be $script:instanceDesiredState.Value
            }
        }

        Context "OpenfireJiveProperty\Get\When the configuration is present" {
            BeforeEach {
                # Return the value requested
                $script:instanceDesiredState.mockActualValue = $script:instanceDesiredState.Value
            }

            It 'Should return the state as present' {
                $script:instanceDesiredState.Get().Ensure | Should -Be 'Present'
            }

            It 'Should return the same values as present in properties' {
                $getMethodResourceResult = $script:instanceDesiredState.Get()

                $getMethodResourceResult.OpenfireHome | Should -Be $script:instanceDesiredState.OpenfireHome
                $getMethodResourceResult.ConfigFileName | Should -Be $script:instanceDesiredState.ConfigFileName
                $getMethodResourceResult.PropertyName | Should -Be $script:instanceDesiredState.PropertyName
                $getMethodResourceResult.Value | Should -Be $script:instanceDesiredState.Value
            }
        }

    }

    Describe "OpenfireJiveProperty\Test Method" -Tag 'Test' {
        BeforeEach {
            $script:instanceDesiredState = [OpenfireJiveProperty]  @{
                OpenfireHome = "$($mockOpenfireHome)"
                PropertyName = 'purple.people'
                Value        = 'eater'
                Ensure = 'Present'
            }

            # Track calls to mocked commands
            $script:instanceDesiredState | Add-Member -MemberType NoteProperty -Name methodInvocations -Value ([System.Collections.ArrayList]::new())

            # What should the value of the mock actually be?
            $script:instanceDesiredState | Add-Member -MemberType NoteProperty -Name mockActualValue -Value ''

            # What should the encryption status of the mock actually be?
            $script:instanceDesiredState | Add-Member -MemberType NoteProperty -Name mockActualEncrypted -Value $false

            # Return the mock value
            $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name ReadProperty -Value {
                Write-Verbose "Mock for ReadProperty() called."
                [void] $this.methodInvocations.Add('ReadProperty')
                return $this.mockActualValue
            } -Force

            # Mock the DeleteProperty() method
            $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name DeleteProperty -Value {
                Write-Verbose "Mock for DeleteProperty() called."
                [void] $this.methodInvocations.Add('DeleteProperty')
                $this.mockActualValue = $null
            } -Force

            # Mock the CreateProperty() method
            $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name CreateProperty -Value {
                Write-Verbose "Mock for CreateProperty() called."
                [void] $this.methodInvocations.Add('CreateProperty')
                $this.mockActualValue = $this.Value
            } -Force

            # Mock the UpdateProperty() method
            $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name UpdateProperty -Value {
                Write-Verbose "Mock for UpdateProperty() called."
                [void] $this.methodInvocations.Add('UpdateProperty')
                $this.mockActualValue = $this.Value
            } -Force

            # Mock the getIsEncrypted() method
            $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name getIsEncrypted -Value {
                Write-Verbose "Mock for getIsEncrypted() called."
                [void] $this.methodInvocations.Add('getIsEncrypted')
                return $this.mockActualEncrypted
            } -Force
        }


        Context 'OpenfireJiveProperty\Test\When the system is in the desired state' {

            Context 'OpenfireJiveProperty\Test\When the configuration is absent' {
                It 'Should return $true' {
                    $script:instanceDesiredState.Ensure = 'Absent'
                    # Return $null
                    $script:instanceDesiredState.mockActualValue = $null
                    $script:instanceDesiredState.Test() | Should -BeTrue
                }
            }

            Context 'OpenfireJiveProperty\Test\When the configuration is present' {
                It 'Should return $true' {
                    $script:instanceDesiredState.Ensure = 'Present'
                    # Return the value requested
                    $script:instanceDesiredState.mockActualValue = $script:instanceDesiredState.Value
                    $script:instanceDesiredState.Test() | Should -BeTrue
                }
            }
        }

        Context 'OpenfireJiveProperty\Test\When the system is not in the desired state' {
            BeforeEach {
                # return an empty value to signify a missing value
                $script:instanceDesiredState.mockActualValue = $null
            }

            Context 'OpenfireJiveProperty\Test\When the configuration should be absent' {
                It 'Should return $false' {
                    $script:instanceDesiredState.Test() | Should -BeFalse
                }
            }

            Context 'When the configuration should be present' {
                It 'Should return $false' {
                    $script:instanceDesiredState.Test() | Should -BeFalse
                }
            }
        }
    }

    Describe "OpenfireJiveProperty\Set Method" -Tag 'Set' {
        BeforeEach {
            $script:instanceDesiredState = [OpenfireJiveProperty]  @{
                OpenfireHome = "$($mockOpenfireHome)"
                PropertyName = 'purple.people'
                Value        = 'eater'
                Ensure = 'Present'
            }

            # Track calls to mocked commands
            $script:instanceDesiredState | Add-Member -MemberType NoteProperty -Name methodInvocations -Value ([System.Collections.ArrayList]::new())

            # What should the value of the mock actually be?
            $script:instanceDesiredState | Add-Member -MemberType NoteProperty -Name mockActualValue -Value ''

            # What should the encryption status of the mock actually be?
            $script:instanceDesiredState | Add-Member -MemberType NoteProperty -Name mockActualEncrypted -Value $false

            # Return the mock value
            $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name ReadProperty -Value {
                Write-Verbose "Mock for ReadProperty() called."
                [void] $this.methodInvocations.Add('ReadProperty')
                return $this.mockActualValue
            } -Force

            # Mock the DeleteProperty() method
            $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name DeleteProperty -Value {
                Write-Verbose "Mock for DeleteProperty() called."
                [void] $this.methodInvocations.Add('DeleteProperty')
                $this.mockActualValue = $null
            } -Force

            # Mock the CreateProperty() method
            $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name CreateProperty -Value {
                Write-Verbose "Mock for CreateProperty() called."
                [void] $this.methodInvocations.Add('CreateProperty')
                $this.mockActualValue = $this.Value
            } -Force

            # Mock the UpdateProperty() method
            $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name UpdateProperty -Value {
                Write-Verbose "Mock for UpdateProperty() called."
                [void] $this.methodInvocations.Add('UpdateProperty')
                $this.mockActualValue = $this.Value
            } -Force

            # Mock the getIsEncrypted() method
            $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name getIsEncrypted -Value {
                Write-Verbose "Mock for getIsEncrypted() called."
                [void] $this.methodInvocations.Add('getIsEncrypted')
                return $this.mockActualEncrypted
            } -Force
        }

        Context 'When the system is not in the desired state' {

            Context 'When the configuration should be absent' {
                It 'Should delete the property' {
                    $script:instanceDesiredState.Ensure = 'Absent'
                    $script:instanceDesiredState.Value = $null
                    $script:instanceDesiredState.mockActualValue = 'value exists'
                    { $script:instanceDesiredState.Set() } | Should -Not -Throw
                    $script:instanceDesiredState.methodInvocations | Should -Contain 'DeleteProperty'
                }
            }

            Context 'When the configuration should be present' {
                It 'Should create the property' {
                    $script:instanceDesiredState.Ensure = 'Present'
                    $script:instanceDesiredState.mockActualValue = $null
                    { $script:instanceDesiredState.Set() } | Should -Not -Throw
                    $script:instanceDesiredState.methodInvocations | Should -Contain 'CreateProperty'
                }
            }

            Context 'When the configuration is present but has the wrong properties' {
                It 'Should update the property' {
                    $script:instanceDesiredState.Ensure = 'Present'
                    # return an dummy value to signify an incorrect value
                    $script:instanceDesiredState.mockActualValue = 'dummy'
                    { $script:instanceDesiredState.Set() } | Should -Not -Throw
                    $script:instanceDesiredState.methodInvocations | Should -Contain 'UpdateProperty'
                }
            }

            Assert-VerifiableMock
        }
    }
}
