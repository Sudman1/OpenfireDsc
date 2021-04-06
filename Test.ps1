$dlls = Get-ChildItem .\source\ikvm8\lib\ -Filter "*.dll"

foreach ($file in $dlls)
{
    [system.reflection.assembly]::LoadFile($file.FullName)
}

$javaStringType = [java.lang.Class]::instancehelper_getClass("java.lang.String")

$openfireJarPath = "C:\Program Files\Openfire\lib\xmppserver-4.6.2.jar"
$jarFileObj = [java.io.File]::new($openfireJarPath)
$url = [java.net.URL]::new($jarFileObj.toURI().toURL())
$urlArray = [java.net.URL[]]::new(1)
$urlArray[0] = $url
$currentCl = [java.lang.Thread]::currentThread().getContextClassLoader()
$urlCl = [java.net.URLClassloader]::newInstance($urlArray, $currentCl)
# [java.lang.Thread]::currentThread().setContextClassLoader($urlCl)

$jiveGlobalsClass = $urlCl.loadClass("org.jivesoftware.util.JiveGlobals")
$jiveGlobals = $jiveGlobalsClass.newInstance()

# Hinkey Reflection
function Invoke-StaticJavaMethod {
    param (
        [Parameter(Mandatory)]
        [System.Object]
        $InputObject,

        [Parameter(Mandatory)]
        [System.String]
        $MethodName,

        [Parameter()]
        [System.Object[]] $Arguments
    )

    if ($null -eq $Arguments) {
        $Arguments = [System.Object[]]::new(0)
    }

    $methods = $InputObject.getType().GetMember($MethodName)
    $correctMethod = $methods | Where-Object {
        $status = $true
        $params = $_.GetParameters()

        if ($params.Count -eq $Arguments.Count)
        {
            for ($i = 0; $i -lt $params.Count; $i++)
            {
                if ($params[$i].ParameterType -ne $Arguments[$i].GetType())
                {
                    $status = $false
                    break;
                }
            }
        }
        else
        {
            $status = $false
        }

        $status | Write-Output
    }
    $correctMethod.Invoke($InputObject, $Arguments)
}

# Set Home Directory
$jiveGlobals.GetType().getmember('setHomeDirectory').Invoke($jiveGlobals, @("C:\Program Files\Openfire"))
$jiveGlobals.GetType().getmember('getHomeDirectory').Invoke($jiveGlobals, $null)

# Set Config File
#$jiveGlobals.GetType().getmember('setConfigName').Invoke($jiveGlobals, @("openfire.xml"))

# Get Property
#$jiveGlobals.GetType().getmember('getProperty')[0].Invoke($jiveGlobals, @("locale"))

$DbConnectionManager = [org.jivesoftware.database.DbConnectionManager]::new()
$con = Invoke-StaticJavaMethod -InputObject $DbConnectionManager -MethodName "getConnection"

$SchemaManager = [org.jivesoftware.database.SchemaManager]::new()
$schemaCheckStatus = $SchemaManager.checkOpenfireSchema($con)

"Schema check was successful: $schemaCheckStatus"
