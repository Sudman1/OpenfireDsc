<#
.SYNOPSIS
    Basic functionality for Openfire property-based resources

.DESCRIPTION
    Basic functionality for Openfire property-based resources

.PARAMETER PropertyName
    Name of the property to configure

.PARAMETER Value
    Data to set. Must be provided if Ensure is set to 'Present'

.PARAMETER Ensure
    Whether the property should be present or removed.
#>
class OpenfirePropertyBase : OpenfireBase
{
    [DscProperty(Key)]
    [System.String]
    $PropertyName

    [DscProperty()]
    [System.String]
    $Value

    [DscProperty()]
    [System.Boolean]
    $Encrypted = $false

    [DscProperty()]
    [Ensure]
    $Ensure = 'Present'

    hidden [object] $jiveGlobals

    [void] initJiveGlobals()
    {
        $this.jiveGlobals = $this.LoadJavaClass("org.jivesoftware.util.JiveGlobals").newInstance()
        Invoke-StaticJavaMethod -InputObject $this.jiveGlobals -MethodName 'setHomeDirectory' -Arguments $this.OpenfireHome

        Write-Verbose "Home Directory: $(Invoke-StaticJavaMethod -InputObject $this.jiveGlobals -MethodName 'getHomeDirectory')"

        if ($null -ne $this.ConfigFileName)
        {
            Invoke-StaticJavaMethod -InputObject $this.jiveGlobals -MethodName 'setConfigName' -Arguments $this.ConfigFileName
        }
    }

    [void] assertRequiredValueProvided()
    {
        if ($this.Ensure -eq [Ensure]::Present -and -not $this.Value)
        {
            throw $this.localizedData.ValueRequiredNotSupplied -f $this.PropertyName
        }
    }

    # Return an instance representing the current state of the resource. Should not be overridden.
    [OpenfirePropertyBase] Get()
    {
        # Ensure value is provided if the 'Ensure' value is 'Present'
        $this.assertRequiredValueProvided()

        Write-Verbose -Message (
            $this.localizedData.GetProperty -f $this.PropertyName
        )

        <#
            Create an object of the correct type (i.e.: the subclassed resource type)
            and set its values to those specified in the object.
        #>
        $currentState = [System.Activator]::CreateInstance($this.GetType())
        $currentState.OpenfireHome = $this.OpenfireHome
        $currentState.ConfigFileName = $this.ConfigFileName
        $currentState.PropertyName = $this.PropertyName

        # Get the value
        $currentValue = $this.ReadProperty()

        # Get encryption
        $currentState.Encrypted = $this.getIsEncrypted()

        if ($null -eq $currentValue)
        {
            $currentState.Value = $this.Value
            $currentState.Ensure = 'Absent'
        }
        else
        {
            $currentState.Value = $currentValue
            $currentState.Ensure = 'Present'
        }

        return $currentState
    }

    # Return an instance representing the current state of the resource.
    [void] Set()
    {
        # Ensure value is provided if the 'Ensure' value is 'Present'
        $this.assertRequiredValueProvided()

        $getMethodResourceResult = $this.Get()

        if ($this.Ensure -eq [Ensure]::Present)
        {
            if ($getMethodResourceResult.Ensure -eq [Ensure]::Absent)
            {
                Write-Verbose -Message (
                    $this.localizedData.CreateProperty -f $this.PropertyName, $this.Value
                )

                # Creation Routine
                $this.CreateProperty()
            }
            else
            {
                Write-Verbose -Message (
                    $this.localizedData.SetProperty -f $this.PropertyName, $this.Value
                )

                # Set Routine
                $this.UpdateProperty()
            }
        }
        else
        {
            if ($getMethodResourceResult.Ensure -eq 'Present')
            {
                Write-Verbose -Message (
                    $this.localizedData.RemoveProperty -f $this.PropertyName
                )

                # Remove Routine
                $this.DeleteProperty()
            }
        }
    }

    # Return an instance representing the current state of the resource.
    [System.Boolean] Test()
    {
        # Ensure value is provided if the 'Ensure' value is 'Present'
        $this.assertRequiredValueProvided()

        return ([OpenfireBase] $this).Test()
    }

    # Override in child classes
    [void] getIsEncrypted()
    {
        throw ($this.localizedData.NotImplemented -f "getIsEncrypted()")

    }

    # Override in child classes
    [void] CreateProperty()
    {
        throw ($this.localizedData.NotImplemented -f "CreateProperty()")

    }

    # Override in child classes
    [System.String] ReadProperty()
    {
        throw ($this.localizedData.NotImplemented -f "ReadProperty()")
    }

    # Override in child classes
    [void] UpdateProperty()
    {
        throw ($this.localizedData.NotImplemented -f "UpdateProperty()")
    }

    # Override in child classes
    [void] DeleteProperty()
    {
        throw ($this.localizedData.NotImplemented -f "DeleteProperty()")
    }
}
