[DscResource()]
class OpenfireXmlProperty : OpenfirePropertyBase
{
    # Return an instance representing the current state of the resource.
    [OpenfireXmlProperty] Get()
    {
        return ([OpenfirePropertyBase] $this).Get()
    }

    # Set the state to match the properties specified in this resource.
    [void] Set()
    {
        ([OpenfirePropertyBase] $this).Set()
    }

    # Compare the current state with the desired state.
    [System.Boolean] Test()
    {
        return ([OpenfirePropertyBase] $this).Test()
    }

    # OVERRIDES

    # Gets the encryption state of the property
    [System.Boolean] getIsEncrypted()
    {
        $this.initJiveGlobals()
        return Invoke-StaticJavaMethod -InputObject $this.jiveGlobals -MethodName 'isXMLPropertyEncrypted' -Arguments $this.PropertyName
    }

    # Create a new property
    [void] CreateProperty()
    {
        $this.initJiveGlobals()
        Invoke-StaticJavaMethod -InputObject $this.jiveGlobals -MethodName 'setXMLProperty' -Arguments $this.PropertyName, $this.Value, $this.Encrypted
    }

    # Read the value of a property
    [System.String] ReadProperty()
    {
        $this.initJiveGlobals()
        $currentValue = Invoke-StaticJavaMethod -InputObject $this.jiveGlobals -MethodName 'getXMLProperty' -Arguments $this.PropertyName
        return $currentValue
    }

    # Update and existing property
    [void] UpdateProperty()
    {
        # Updates and creation follow the same pattern
        $this.CreateProperty()
    }

    # remove an existing property
    [void] DeleteProperty()
    {
        $this.initJiveGlobals()
        Invoke-StaticJavaMethod -InputObject $this.jiveGlobals -MethodName 'deleteXMLProperty' -Arguments $this.PropertyName
    }
}
