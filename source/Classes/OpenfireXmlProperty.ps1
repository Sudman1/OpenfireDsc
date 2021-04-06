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

    # Create a new property
    [void] CreateProperty()
    {
        throw ($this.localizedData.NotImplemented -f "CreateProperty()")
    }

    # Read the value of a property
    [System.String] ReadProperty()
    {
        throw ($this.localizedData.NotImplemented -f "ReadProperty()")
    }

    # Update and existing property
    [void] UpdateProperty()
    {
        throw ($this.localizedData.NotImplemented -f "UpdateProperty()")
    }

    # remove an existing property
    [void] DeleteProperty()
    {
        throw ($this.localizedData.NotImplemented -f "DeleteProperty()")
    }
}
