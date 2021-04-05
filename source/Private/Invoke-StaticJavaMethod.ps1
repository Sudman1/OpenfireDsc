<#
.SYNOPSIS
    Invoke a static method on a Java object provied by the IKVM library
.DESCRIPTION
    Invoke a static method on a Java object provied by the IKVM library
.EXAMPLE
    PS C:\> Invoke-StaticJavaMethod -InputObject $xmppserverObj -MethodName "getInstance"
    Returns the xmppserver singleton intance
.INPUTS
    An object of a Java type
.OUTPUTS
    Results of the reflected method call
.NOTES
    Uses Java reflection to call static Java methods which are not easily exposed to .Net objects.
#>
function Invoke-StaticJavaMethod
{
    param
    (
        # An instance of a type against which a static method will be called.
        [Parameter(Mandatory)]
        [System.Object]
        $InputObject,

        # Case-sensitive name of the method to call.
        [Parameter(Mandatory)]
        [System.String]
        $MethodName,

        <#
            Array of arguments to pass to the command. Type and order matter to
            match the method signature. No need to specify if the method signature
            has no arguments.
        #>
        [Parameter()]
        [System.Object[]]
        $Arguments
    )

    if ($null -eq $Arguments)
    {
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
