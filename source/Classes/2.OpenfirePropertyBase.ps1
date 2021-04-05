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
class OpenfireBase : OpenfireBase
{
    [DscProperty(Key)]
    [System.String]
    $PropertyName

    [DscProperty()]
    [System.String]
    $Value

    [DscProperty()]
    [Ensure]
    $Ensure = 'Present'

    # Return an instance representing the current state of the resource. Should not be overridden.
    [OpenfirePropertyBase] Get()
    {
        Write-Verbose -Message (
            $script:localizedData.GetProperty -f $this.PropertyName
        )

        <#
            Create an object of the correct type (i.e.: the subclassed resource type)
            and set its values to those specified in the object, but set Ensure to Absent
        #>
        $currentState = [System.Activator]::CreateInstance($this.GetType())
        $currentState.PropertyName = $this.PropertyName

        # Get the value
        $currentValue = $this.GetCurrentValue()

        if ([System.String]::IsNullOrWhiteSpace($currentValue))
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
    [OpenfireXmlProperty] Set()
    {
        return ([OpenfireBase] $this).Set()
    }
    # Return an instance representing the current state of the resource.
    [OpenfireXmlProperty] Test()
    {
        return ([OpenfireBase] $this).Test()
    }

    [System.String] GetCurrentValue()
    {
        throw "GetCurrentValue() not implemented."
    }
}
