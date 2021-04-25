using module .\output\OpenfireDsc\
$script:dscResourceCommonModulePath = Join-Path -Path .\output\OpenfireDsc\0.1.0\ -ChildPath 'Modules\DscResource.Common'
Import-Module -Name $script:dscResourceCommonModulePath -verbose


$mockOpenfireHome = Resolve-Path -Path "tests\TestOpenfireHome"

$script:instanceDesiredState = [OpenfireXmlProperty]  @{
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

$script:instanceDesiredState.mockActualValue = 'red'
$script:instanceDesiredState.mockActualEncrypted = $false

"Desired:"
$script:instanceDesiredState | Ft -a

"Actual:"
$script:instanceDesiredState.Get() | Ft -a

"Compare:"
$script:instanceDesiredState.Compare()

"`nTest:"
$script:instanceDesiredState.Test()

"`nSetting.`n"
$script:instanceDesiredState.Set()

$script:instanceDesiredState.methodInvocations

"Actual now:"
$script:instanceDesiredState.Get() | Ft -a

"Test:"
$script:instanceDesiredState.Test()
