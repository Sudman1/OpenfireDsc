[DscResource()]
class OpenfireXmlProperty
{
    [DscProperty(Key)]
    [System.String]
    $PropertyName

    [DscProperty(Mandatory)]
    [System.String]
    $Value

    [DscProperty()]
    [Ensure]
    $Ensure = 'Present'


    # Return an instance representing the current state of the resource.
    [OpenfireXmlProperty] Get()
    {
        return ([OpenfirePropertyBase] $this).Get()
    }

    # Set the state to match the properties specified in this resource.
    [void] Set()
    {
        $getMethodResourceResult = $this.Get()

        if ($this.Ensure -eq [Ensure]::Present)
        {
            if ($getMethodResourceResult.Ensure -eq [Ensure]::Absent)
            {
                Write-Verbose -Message (
                    $this.localizedData.CreateProperty -f $this.PropertyName, $this.Value
                )

                # Creation Routine
            }
            else
            {
                Write-Verbose -Message (
                    $this.localizedData.SetProperty -f $this.PropertyName, $this.Value
                )

                # Set Routine
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
            }
        }
    }

    # Compare the current state with the desired state.
    [System.Boolean] Test()
    {
        return ([OpenfirePropertyBase] $this).Test()
    }

    [System.String] GetCurrentValue()
    {
        return ""
    }
}
