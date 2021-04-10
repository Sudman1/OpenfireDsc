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
    Describe OpenfireXmlProperty {
        Context 'Constructors' {
            It 'Should not throw an exception when instantiated' {
                { [OpenfireXmlProperty]::new() } | Should -Not -Throw
            }

            It 'Has a default or empty constructor' {
                $instance = [OpenfireXmlProperty]::new()
                $instance | Should -Not -BeNullOrEmpty
                $instance.GetType().Name | Should -Be 'OpenfireXmlProperty'
            }
        }

        Context 'Type creation' {
            It 'Should be type named OpenfireXmlProperty' {
                $instance = [OpenfireXmlProperty]::new()
                $instance.GetType().Name | Should -Be 'OpenfireXmlProperty'
            }
        }
    }

    Describe "OpenfireXmlProperty\CRUD functions" -Tag 'Crud' {
        $contexts = @{
            "Unencrypted Values" = $false
            "Encrypted Values"   = $true
        }

        foreach ($context in $contexts.keys)
        {
            Context $context {
                BeforeEach {
                    $script:instanceDesiredState = [OpenfireXmlProperty] @{
                        OpenfireHome = "$($pwd.Path)\tests\Unit\TestOpenfireHome"
                        PropertyName = 'purple.people'
                        Value        = 'eater'
                        Encrypted    = $contexts[$context]
                        Ensure       = 'Present'
                    }
                }

                It 'Adds a new XML property value' {
                    $script:testInstance.CreateProperty()
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
        }
    }

    Describe "OpenfireXmlProperty\Get Method" -Tag 'Get' {
        $contexts = @{
            "Unencrypted Values" = $false
            "Encrypted Values"   = $true
        }

        foreach ($context in $contexts.keys)
        {
            Context $context {
                BeforeEach {
                    $script:instanceDesiredState = [OpenfireXmlProperty] @{
                        OpenfireHome = 'C:\Program Files\Openfire'
                        PropertyName = 'purple.people'
                        Value        = 'eater'
                        Encrypted    = $contexts[$context]
                        Ensure       = 'Present'
                    }

                    $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name CreateProperty -Value {
                        Write-Verbose "Mock value for CreateProperty() called."
                    } -Force

                    $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name DeleteProperty -Value {
                        Write-Verbose "Mock value for DeleteProperty() called."
                    } -Force
                }

                Context "OpenfireXmlProperty\Get\When the configuration is absent" {
                    BeforeEach {
                        # return an empty value to signify a missing value
                        $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name ReadProperty -Value {
                            Write-Verbose "Mock value '' for ReadProperty() called."
                            ""
                        } -Force
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

                Context "OpenfireXmlProperty\Get\When the configuration is present" {
                    BeforeEach {
                        # Return the value requested
                        $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name ReadProperty -Value {
                            Write-Verbose "Mock value '$($script:instanceDesiredState.Value)' for ReadProperty() called."
                            $script:instanceDesiredState.Value
                        } -Force
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
        }
    }

    Describe "OpenfireXmlProperty\Test Method" -Tag 'Test' {
        $contexts = @{
            "Unencrypted Values" = $false
            "Encrypted Values"   = $true
        }

        foreach ($context in $contexts.keys)
        {
            Context $context {
                BeforeEach {
                    $script:instanceDesiredState = [OpenfireXmlProperty] @{
                        OpenfireHome = 'C:\Program Files\Openfire'
                        PropertyName = 'purple.people'
                        Value        = 'eater'
                        Encrypted    = $contexts[$context]
                        Ensure       = 'Present'
                    }

                    $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name CreateProperty -Value {
                        Write-Verbose "Mock value for CreateProperty() called."
                    } -Force

                    $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name DeleteProperty -Value {
                        Write-Verbose "Mock value for DeleteProperty() called."
                    } -Force
                }


                Context 'OpenfireXmlProperty\Test\When the system is in the desired state' {
                    BeforeEach {
                        # Return the value requested
                        $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name ReadProperty -Value {
                            Write-Verbose "Mock value '$($script:instanceDesiredState.Value)' for ReadProperty() called."
                            $script:instanceDesiredState.Value
                        } -Force
                    }

                    Context 'OpenfireXmlProperty\Test\When the configuration is absent' {
                        It 'Should return $true' {
                            $script:instanceDesiredState.Test() | Should -BeTrue
                        }
                    }

                    Context 'OpenfireXmlProperty\Test\When the configuration are present' {
                        It 'Should return $true' {
                            $script:instanceDesiredState.Test() | Should -Be $true
                        }
                    }
                }

                Context 'OpenfireXmlProperty\Test\When the system is not in the desired state' {
                    BeforeEach {
                        # return an empty value to signify a missing value
                        $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name ReadProperty -Value {
                            Write-Verbose "Mock value '' for ReadProperty() called."
                            ""
                        } -Force
                    }

                    Context 'OpenfireXmlProperty\Test\When the configuration should be absent' {
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
        }
    }

    Describe "OpenfireXmlProperty\Set Method" -Tag 'Set' {
        $contexts = @{
            "Unencrypted Values" = $false
            "Encrypted Values"   = $true
        }

        foreach ($context in $contexts.keys)
        {
            Context $context {
                BeforeEach {
                    $script:instanceDesiredState = [OpenfireXmlProperty] @{
                        OpenfireHome = 'C:\Program Files\Openfire'
                        PropertyName = 'purple.people'
                        Value        = 'eater'
                        Encrypted    = $contexts[$context]
                        Ensure       = 'Present'
                    }
                }

                Context 'When the system is not in the desired state' {
                    BeforeEach {
                        Mock -CommandName Remove-Item -MockWith {
                        }
                        Mock -CommandName New-Item -MockWith {
                        }
                        Mock -CommandName Set-Item -MockWith {
                        }

                        # Return an empty value to signify a missing value
                        $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name ReadProperty -Value {
                            Get-Item .\
                        } -Force

                        # Mock the DeleteProperty() method
                        $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name DeleteProperty -Value {
                            Write-Verbose "Mock for DeleteProperty() called."
                            Remove-Item .\
                        } -Force

                        # Mock the CreateProperty() method
                        $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name CreateProperty -Value {
                            Write-Verbose "Mock for CreateProperty() called."
                            New-Item .\
                        } -Force

                        # Mock the UpdateProperty() method
                        $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name UpdateProperty -Value {
                            Write-Verbose "Mock for UpdateProperty() called."
                            Set-Item .\ -Value "mock"
                        } -Force
                    }

                    Context 'When the configuration should be absent' {
                        BeforeEach {
                            $script:instanceDesiredState.Ensure = 'Absent'
                            $script:instanceDesiredState.Value = $null
                        }

                        It 'Should delete the property' {
                            Mock -CommandName Get-Item -MockWith {
                                Write-Verbose "Mock value '$($script:instanceDesiredState.Value)' for ReadProperty() called."
                                'a value to delete'
                            } {
                                $script:instanceDesiredState.Set()
                            } | Should -Not -Throw
                            Assert-MockCalled -CommandName Remove-Item -Times 1
                        }
                    }

                    Context 'When the configuration should be present' {
                        BeforeEach {
                            $script:instanceDesiredState.Ensure = 'Present'
                        }

                        It 'Should create the property' {
                            Mock -CommandName Get-Item -MockWith {
                                Write-Verbose "Mock value '' for ReadProperty() called."
                                ''
                            }
                            { $script:instanceDesiredState.Set() } | Should -Not -Throw
                            Assert-MockCalled -CommandName New-Item -Times 1
                        }
                    }

                    Context 'When the configuration is present but has the wrong properties' {
                        BeforeAll {
                            # return an dummy value to signify an incorrect value
                            $dummy = 'dummy'
                            $script:instanceDesiredState | Add-Member -MemberType ScriptMethod -Name ReadProperty -Value {
                                Write-Verbose "Mock value '$dummy' for ReadProperty() called."
                                $dummy
                            } -Force
                        }

                        It 'Should update the property' {
                            { $script:instanceDesiredState.Set() } | Should -Not -Throw
                            Assert-MockCalled -CommandName Set-Item -Times 1
                        }
                    }

                    Assert-VerifiableMock
                }
            }

        }
    }
}
