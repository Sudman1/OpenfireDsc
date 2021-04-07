$ProjectPath = "$PSScriptRoot\..\..\.." | Convert-Path
$ProjectName = (Get-ChildItem $ProjectPath\*\*.psd1 | Where-Object {
        ($_.Directory.Name -match 'source|src' -or $_.Directory.Name -eq $_.BaseName) -and
        $(try { Test-ModuleManifest $_.FullName -ErrorAction Stop }catch{$false}) }
    ).BaseName

Import-Module $ProjectName

InModuleScope $ProjectName {

    Describe 'Helper function Invoke-StaticJavaMethod' {
        BeforeAll {
            # Get an object against which to call methods
            $openfireJarPath = "C:\Program Files\Openfire\lib\xmppserver-4.6.2.jar"
            $jarFileObj = [java.io.File]::new($openfireJarPath)
            $url = [java.net.URL]::new($jarFileObj.toURI().toURL())
            $urlArray = [java.net.URL[]]::new(1)
            $urlArray[0] = $url
            $currentCl = [java.lang.Thread]::currentThread().getContextClassLoader()
            $urlCl = [java.net.URLClassloader]::newInstance($urlArray, $currentCl)
            $jiveGlobalsClass = $urlCl.loadClass("org.jivesoftware.util.JiveGlobals")
            $script:jiveGlobals = $jiveGlobalsClass.newInstance()
        }

        Context 'Invoke-StaticJavaMethod\Calling a method with 0 arguments' {

            It 'Should not Throw' {
                {Invoke-StaticJavaMethod -InputObject $script:jiveGlobals -MethodName 'getLocale' } | Should -Not -Throw
            }

            It 'Should return the correct value' {
                Invoke-StaticJavaMethod -InputObject $script:jiveGlobals -MethodName 'getLocale' | Should -Be 'en_US'
            }
        }

        Context 'Invoke-StaticJavaMethod\Calling a method with 1 argument' {

            It 'Should not Throw' {
                {Invoke-StaticJavaMethod -InputObject $script:jiveGlobals -MethodName 'getXMLProperty' -Arguments 'does.not.exist' } | Should -Not -Throw
            }

            It 'Should return the correct value' {
                Invoke-StaticJavaMethod -InputObject $script:jiveGlobals -MethodName 'getXMLProperty' -Arguments 'does.not.exist' | Should -BeNullOrEmpty
            }
        }

        Context 'Invoke-StaticJavaMethod\Calling a method with more than 1 argument' {

            It 'Should not Throw' {
                {Invoke-StaticJavaMethod -InputObject $script:jiveGlobals -MethodName 'getXMLProperty' -Arguments 'does.not.exist', 'nothing to see here' } | Should -Not -Throw
            }

            It 'Should return the correct value' {
                Invoke-StaticJavaMethod -InputObject $script:jiveGlobals -MethodName 'getXMLProperty' -Arguments 'does.not.exist', 'nothing to see here' | Should -Be 'nothing to see here'
            }
        }
    }
}
