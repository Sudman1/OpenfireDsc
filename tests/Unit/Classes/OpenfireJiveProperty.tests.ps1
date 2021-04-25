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
        Context ('{0}Constructors' -f $global:encString) {
            It ('{0}Should not throw an exception when instantiated' -f $global:encString) {
                { [OpenfireJiveProperty]::new() } | Should -Not -Throw
            }

            It ('{0}Has a default or empty constructor' -f $global:encString) {
                $instance = [OpenfireJiveProperty]::new()
                $instance | Should -Not -BeNullOrEmpty
                $instance.GetType().Name | Should -Be 'OpenfireJiveProperty'
            }
        }

        Context ('{0}Type creation' -f $global:encString) {
            It ('{0}Should be type named OpenfireJiveProperty' -f $global:encString) {
                $instance = [OpenfireJiveProperty]::new()
                $instance.GetType().Name | Should -Be 'OpenfireJiveProperty'
            }
        }
    }

    # Run tests twice - once for unencrypted values, once encrypted
    @($false, $true) | ForEach-Object {
        $global:shouldBeEncrypted = $_
        $global:encString = if ($global:shouldBeEncrypted)
        {
            "Encrypted: "
        }
        else
        {
            "Unencrypted: "
        }
        Describe ("{0}OpenfireJiveProperty\CRUD functions" -f $global:encString) -Tag 'CRUD' {
            BeforeEach {
                $script:testInstance = [OpenfireJiveProperty] @{
                    OpenfireHome = "$($mockOpenfireHome)"
                    PropertyName = 'purple.people'
                    Value        = 'eater'
                    Encrypted    = $global:shouldBeEncrypted
                }
            }

            It ('{0}Adds a new XML property value' -f $global:encString) {
                $script:testInstance.CreateProperty()
            }

            It ('{0}Should return the right value when asking if the value is encrypted' -f $global:encString) {
                $script:testInstance.getIsEncrypted() | Should -Be $global:shouldBeEncrypted
            }

            It ('{0}Gets an XML Property Value' -f $global:encString) {
                $script:testInstance.ReadProperty() | Should -Be $script:testInstance.Value
            }

            It ('{0}Modifies an existing XML property value' -f $global:encString) {
                { $script:testInstance.UpdateProperty() } | Should -Not -Throw
                $script:testInstance.ReadProperty() | Should -Be $script:testInstance.Value
            }

            It ('{0}Deletes an existing XML property value' -f $global:encString) {
                { $script:testInstance.DeleteProperty() } | Should -Not -Throw
                $script:testInstance.ReadProperty() | Should -BeNullOrEmpty
            }
        }

        Describe ("{0}OpenfireJiveProperty\Get Method" -f $global:encString) -Tag 'Get' {
            BeforeEach {
                $script:instanceDesiredState = [OpenfireJiveProperty]  @{
                    OpenfireHome = "$($mockOpenfireHome)"
                    PropertyName = 'purple.people'
                    Value        = 'eater'
                    Ensure       = 'Present'
                    Encrypted    = $global:shouldBeEncrypted
                }

                # Track calls to mocked commands
                $script:instanceDesiredState | Add-Member -MemberType NoteProperty -Name methodInvocations -Value ([System.Collections.ArrayList]::new())

                # What should the value of the mock actually be?
                $script:instanceDesiredState | Add-Member -MemberType NoteProperty -Name mockActualValue -Value ''

                # What should the encryption status of the mock actually be?
                $script:instanceDesiredState | Add-Member -MemberType NoteProperty -Name mockActualEncrypted -Value $global:shouldBeEncrypted

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

                It ('{0}Should return the state as absent' -f $global:encString) {
                    $script:instanceDesiredState.Get().Ensure | Should -Be 'Absent'
                }

                It ('{0}Should return the same values as present in properties' -f $global:encString) {
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

                It ('{0}Should return the state as present' -f $global:encString) {
                    $script:instanceDesiredState.Get().Ensure | Should -Be 'Present'
                }

                It ('{0}Should return the same values as present in properties' -f $global:encString) {
                    $getMethodResourceResult = $script:instanceDesiredState.Get()

                    $getMethodResourceResult.OpenfireHome | Should -Be $script:instanceDesiredState.OpenfireHome
                    $getMethodResourceResult.ConfigFileName | Should -Be $script:instanceDesiredState.ConfigFileName
                    $getMethodResourceResult.PropertyName | Should -Be $script:instanceDesiredState.PropertyName
                    $getMethodResourceResult.Value | Should -Be $script:instanceDesiredState.Value
                }
            }

        }

        Describe ("{0}OpenfireJiveProperty\Test Method" -f $global:encString) -Tag 'Test' {
            BeforeEach {
                $script:instanceDesiredState = [OpenfireJiveProperty]  @{
                    OpenfireHome = "$($mockOpenfireHome)"
                    PropertyName = 'purple.people'
                    Value        = 'eater'
                    Ensure = 'Present'
                    Encrypted    = $global:shouldBeEncrypted
                }

                # Track calls to mocked commands
                $script:instanceDesiredState | Add-Member -MemberType NoteProperty -Name methodInvocations -Value ([System.Collections.ArrayList]::new())

                # What should the value of the mock actually be?
                $script:instanceDesiredState | Add-Member -MemberType NoteProperty -Name mockActualValue -Value ''

                # What should the encryption status of the mock actually be?
                $script:instanceDesiredState | Add-Member -MemberType NoteProperty -Name mockActualEncrypted -Value $global:shouldBeEncrypted

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


            Context ('{0}OpenfireJiveProperty\Test\When the system is in the desired state' -f $global:encString) {

                Context ('{0}OpenfireJiveProperty\Test\When the configuration is absent' -f $global:encString) {
                    It ('{0}Should return $true' -f $global:encString) {
                        $script:instanceDesiredState.Ensure = 'Absent'
                        # Return $null
                        $script:instanceDesiredState.mockActualValue = $null
                        $script:instanceDesiredState.Test() | Should -BeTrue
                    }
                }

                Context ('{0}OpenfireJiveProperty\Test\When the configuration is present' -f $global:encString) {
                    It ('{0}Should return $true' -f $global:encString) {
                        $script:instanceDesiredState.Ensure = 'Present'
                        # Return the value requested
                        $script:instanceDesiredState.mockActualValue = $script:instanceDesiredState.Value
                        $script:instanceDesiredState.Test() | Should -BeTrue
                    }
                }
            }

            Context ('{0}OpenfireJiveProperty\Test\When the system is not in the desired state' -f $global:encString) {
                BeforeEach {
                    # return an empty value to signify a missing value
                    $script:instanceDesiredState.mockActualValue = $null
                }

                Context ('{0}OpenfireJiveProperty\Test\When the configuration should be absent' -f $global:encString) {
                    It ('{0}Should return $false' -f $global:encString) {
                        $script:instanceDesiredState.Test() | Should -BeFalse
                    }
                }

                Context ('{0}When the configuration should be present' -f $global:encString) {
                    It ('{0}Should return $false' -f $global:encString) {
                        $script:instanceDesiredState.Test() | Should -BeFalse
                    }
                }
            }
        }

        Describe ("{0}OpenfireJiveProperty\Set Method" -f $global:encString) -Tag 'Set' {
            BeforeEach {
                $script:instanceDesiredState = [OpenfireJiveProperty]  @{
                    OpenfireHome = "$($mockOpenfireHome)"
                    PropertyName = 'purple.people'
                    Value        = 'eater'
                    Ensure = 'Present'
                    Encrypted    = $global:shouldBeEncrypted
                }

                # Track calls to mocked commands
                $script:instanceDesiredState | Add-Member -MemberType NoteProperty -Name methodInvocations -Value ([System.Collections.ArrayList]::new())

                # What should the value of the mock actually be?
                $script:instanceDesiredState | Add-Member -MemberType NoteProperty -Name mockActualValue -Value ''

                # What should the encryption status of the mock actually be?
                $script:instanceDesiredState | Add-Member -MemberType NoteProperty -Name mockActualEncrypted -Value $global:shouldBeEncrypted

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

            Context ('{0}When the system is not in the desired state' -f $global:encString) {

                Context ('{0}When the configuration should be absent' -f $global:encString) {
                    It ('{0}Should delete the property' -f $global:encString) {
                        $script:instanceDesiredState.Ensure = 'Absent'
                        $script:instanceDesiredState.Value = $null
                        $script:instanceDesiredState.mockActualValue = 'value exists'
                        { $script:instanceDesiredState.Set() } | Should -Not -Throw
                        $script:instanceDesiredState.methodInvocations | Should -Contain 'DeleteProperty'
                    }
                }

                Context ('{0}When the configuration should be present' -f $global:encString) {
                    It ('{0}Should create the property' -f $global:encString) {
                        $script:instanceDesiredState.Ensure = 'Present'
                        $script:instanceDesiredState.mockActualValue = $null
                        { $script:instanceDesiredState.Set() } | Should -Not -Throw
                        $script:instanceDesiredState.methodInvocations | Should -Contain 'CreateProperty'
                    }
                }

                Context ('{0}When the configuration is present but has the wrong properties' -f $global:encString) {
                    It ('{0}Should update the property' -f $global:encString) {
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
}
