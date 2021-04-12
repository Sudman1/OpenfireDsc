$ProjectPath = "$PSScriptRoot\..\..\.." | Convert-Path
$ProjectName = (Get-ChildItem $ProjectPath\*\*.psd1 | Where-Object {
        ($_.Directory.Name -match 'source|src' -or $_.Directory.Name -eq $_.BaseName) -and
        $(try { Test-ModuleManifest $_.FullName -ErrorAction Stop }catch{$false}) }
    ).BaseName

Import-Module $ProjectName

InModuleScope $ProjectName {

    $mockOpenfireHome = Resolve-Path -Path "$PSScriptRoot\..\..\TestOpenfireHome"

    Describe OpenfireBase {
        Context 'OpenfireBase\Constructors' {
            It 'Should not throw an exception when instantiated' {
                {[OpenfireBase]::new()} | Should -Not -Throw
            }

            It 'Has a default or empty constructor' {
                $instance = [OpenfireBase]::new()
                $instance | Should -Not -BeNullOrEmpty
            }
        }

        Context 'OpenfireBase\Type creation' {
            It 'Should be type named OpenfireBase' {
                $instance = [OpenfireBase]::new()
                $instance.GetType().Name | Should -Be 'OpenfireBase'
            }
        }
    }

    Describe 'OpenfireBase\Testing Get Method' -Tag 'Get' {
        BeforeAll {
            $script:mockOpenfireHome = "$($mockOpenfireHome)"
            $script:mockConfigFileName = 'openfire.xml'
        }

        BeforeEach {
            $script:instanceDesiredState = [OpenfireBase]::New()
            $script:instanceDesiredState.OpenfireHome = $script:mockOpenfireHome
            $script:instanceDesiredState.ConfigFileName = $script:mockConfigFileName
        }

        It 'Should return the same values passed' {
            $currentState = $script:instanceDesiredState.Get()
            $currentState.OpenfireHome | Should -Be $script:mockOpenfireHome
            $currentState.ConfigFileName | Should -Be $script:mockConfigFileName
        }

    }

    Describe "OpenfireBase\Testing Test Method" -Tag 'Test' {
        BeforeAll {
            $script:mockOpenfireHome = "$($mockOpenfireHome)"
            $script:mockConfigFileName = 'openfire.xml'
        }

        BeforeEach {
            $script:instanceDesiredState = [OpenfireBase]::New()
            $script:instanceDesiredState.OpenfireHome = $script:mockOpenfireHome
            $script:instanceDesiredState.ConfigFileName = $script:mockConfigFileName
        }

        It 'Should always return $true' {
            $script:instanceDesiredState.Test() | Should -BeTrue
        }
    }

    Describe "OpenfireBase\Testing Set Method" -Tag 'Set' {
        BeforeAll {
            $script:mockOpenfireHome = "$($mockOpenfireHome)"
            $script:mockConfigFileName = 'openfire.xml'
        }

        BeforeEach {
            $script:instanceDesiredState = [OpenfireBase]::New()
            $script:instanceDesiredState.OpenfireHome = $script:mockOpenfireHome
            $script:instanceDesiredState.ConfigFileName = $script:mockConfigFileName
        }

        It 'Should throw' {
            { $script:instanceDesiredState.Set() } | Should -Throw
        }
    }

    Describe "OpenfireBase\Classloading" {
        BeforeAll {
            $script:mockOpenfireHome = "$($mockOpenfireHome)"
            $script:mockConfigFileName = 'openfire.xml'
        }

        BeforeEach {
            $script:instanceDesiredState = [OpenfireBase]::New()
            $script:instanceDesiredState.OpenfireHome = $script:mockOpenfireHome
            $script:instanceDesiredState.ConfigFileName = $script:mockConfigFileName
        }

        It "Should load the java.lang.String class" {
            $script:instanceDesiredState.LoadJavaClass('java.lang.String') | Should -Not -BeNullOrEmpty
        }

        It "Should throw on an invalid class name" {
            {$script:instanceDesiredState.LoadJavaClass('java.lang.DNE')} | Should -Throw
        }
    }
}
