$ProjectPath = "$PSScriptRoot\..\..\.." | Convert-Path
$ProjectName = (Get-ChildItem $ProjectPath\*\*.psd1 | Where-Object {
        ($_.Directory.Name -match 'source|src' -or $_.Directory.Name -eq $_.BaseName) -and
        $(try { Test-ModuleManifest $_.FullName -ErrorAction Stop }catch{$false}) }
    ).BaseName

Import-Module $ProjectName

InModuleScope $ProjectName {

    Describe 'Helper function Invoke-StaticJavaMethod' {
        BeforeAll {
            # Load the IKVM library

            # Get an object against which to call methods
            $javaObj
        }

        Context 'Calling a method with 0 arguments' {

            It 'Should not Throw' {
                {Invoke-StaticJavaMethod -InputObject $javaObj -MethodName "method" } | Should -Not -Throw
            }

            It 'Should return the correct value' {
                Invoke-StaticJavaMethod -InputObject $javaObj -MethodName "method" | Should -Be "value"
            }
        }

        Context 'Calling a method with 1 argument' {

            It 'Should not Throw' {
                {Invoke-StaticJavaMethod -InputObject $javaObj -MethodName "method" } | Should -Not -Throw
            }

            It 'Should return the correct value' {
                Invoke-StaticJavaMethod -InputObject $javaObj -MethodName "method" | Should -Be "value"
            }
        }

        Context 'Calling a method overload with 1 argument' {

            It 'Should not Throw' {
                {Invoke-StaticJavaMethod -InputObject $javaObj -MethodName "method" } | Should -Not -Throw
            }

            It 'Should return the correct value' {
                Invoke-StaticJavaMethod -InputObject $javaObj -MethodName "method" | Should -Be "value"
            }
        }

        Context 'Calling a method with More than 1 arguments' {

            It 'Should not Throw' {
                {Invoke-StaticJavaMethod -InputObject $javaObj -MethodName "method" } | Should -Not -Throw
            }

            It 'Should return the correct value' {
                Invoke-StaticJavaMethod -InputObject $javaObj -MethodName "method" | Should -Be "value"
            }
        }
    }
}
