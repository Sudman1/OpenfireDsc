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

    [bool] $currentlyEncrypted = $false

    [System.String] getCurrentValue()
    {
        [xml] $xml = Get-Content -Encoding UTF8 -Path ('{0}\conf\{1}' -f $this.OpenfireHome, $this.ConfigFileName)
        $data = Invoke-Expression ('$xml.jive.{0}' -f $this.PropertyName)
        $this.currentlyEncrypted = $data.encrypted -eq 'true'

        # We can use straight powershell if the value is unencrypted, giving us some performance benefits.
        if ($this.currentlyEncrypted)
        {
            $this.initJiveGlobals()
            $currentValue = Invoke-StaticJavaMethod -InputObject $this.jiveGlobals -MethodName 'getXMLProperty' -Arguments $this.PropertyName
        }
        else
        {
            if ($data -is [System.Xml.XmlElement])
            {
                $currentValue = $data.InnerText
            }
            else
            {
                $currentValue = $data
            }
        }

        return $currentValue
    }

    # OVERRIDES

    # Gets the encryption state of the property
    [System.Boolean] getIsEncrypted()
    {
        # Ensure the currentlyEncrypted field is populated
        [void] $this.getCurrentValue()
        return $this.currentlyEncrypted
    }

    # Create a new property
    [void] CreateProperty()
    {
        $this.initJiveGlobals()
        Invoke-StaticJavaMethod -InputObject $this.jiveGlobals -MethodName 'setXMLProperty' -Arguments $this.PropertyName, $this.Value
    }

    # Read the value of a property
    [System.String] ReadProperty()
    {
        return $this.getCurrentValue()
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
