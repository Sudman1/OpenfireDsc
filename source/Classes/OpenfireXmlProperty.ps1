$script:localizedDataClassFolder = Get-LocalizedData -DefaultUICulture en-US -FileName 'DSC_ClassFolder.strings.psd1'

[DscResource()]
class OpenfireXmlProperty
{
    [DscProperty(Key)]
    [System.String]
    $OpenfireHome

    [DscProperty(Key)]
    [System.String]
    $PropertyName

    [DscProperty(Mandatory)]
    [System.String]
    $Value

    [DscProperty()]
    [System.String]
    $ConfigFileName = 'openfire.xml'

    [DscProperty()]
    [Ensure]
    $Ensure = 'Present'

    # Hidden property for holding localization strings
    hidden [System.Collections.Hashtable] $localizedData

    # Hidden method to integrate localized strings from classes up the inheritance stack
    hidden [void] SetLocalizedData()
    {
        # Create a list of the inherited class names
        $inheritedClasses = @(, $this.GetType().Name)
        $parentClass = $this.GetType().BaseType
        while ($parentClass -ne [System.Object])
        {
            $inheritedClasses += $parentClass.Name
            $parentClass = $parentClass.BaseType
        }

        $this.localizedData = @{}

        foreach ($className in $inheritedClasses)
        {
            # Get localized data for the class
            $localizationFile = "$($className).strings.psd1"

            try
            {
                $tmpData = Get-LocalizedData -DefaultUICulture 'en-US' -FileName $localizationFile -ErrorAction Stop

                # Append only previously unspecified keys in the localization data
                foreach ($key in $tmpData.Keys)
                {
                    if (-not $this.localizedData.ContainsKey($key))
                    {
                        $this.localizedData[$key] = $tmpData[$key]
                    }
                }
            }
            catch
            {
                if ($_.CategoryInfo.Category.ToString() -eq 'ObjectNotFound')
                {
                    Write-Warning $_.Exception.Message
                }
                else
                {
                    throw $_
                }
            }
        }

        Write-Debug ($this.localizedData | ConvertTo-JSON)
    }

    # Default constructor sets the $isScoped variable and loads the localization strings
    OpenfireXmlProperty()
    {
        # Import the localization strings.
        $this.SetLocalizedData()
    }

    # Return an instance representing the current state of the resource.
    [OpenfireXmlProperty] Get()
    {
        Write-Verbose -Message (
            $script:localizedData.GetProperty -f $this.PropertyName
        )

        $currentState = [OpenfireXmlProperty]::New()
        $currentState.PropertyName = $this.PropertyName

        # Get the value
        $currentValue = ""

        if ([System.String]::IsNullOrWhiteSpace())
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

    # Set the state to match the properties specified in this resource.
    [void] Set()
    {
        $getMethodResourceResult = $this.Get()

        if ($this.Ensure -eq [Ensure]::Present)
        {
            if ($getMethodResourceResult.Ensure -eq [Ensure]::Absent)
            {
                Write-Verbose -Message (
                    $script:localizedDataClassFolder.CreateProperty -f $this.PropertyName, $this.Value
                )

                # Creation Routine
            }
            else
            {
                Write-Verbose -Message (
                    $script:localizedDataClassFolder.SetProperty -f $this.PropertyName, $this.Value
                )

                # Set Routine
            }
        }
        else
        {
            if ($getMethodResourceResult.Ensure -eq 'Present')
            {
                Write-Verbose -Message (
                    $script:localizedDataClassFolder.RemoveProperty -f $this.PropertyName
                )

                # Remove Routine
            }
        }
    }

    # Compare the current state with the desired state.
    [System.Boolean] Test()
    {
        $isInDesiredState = $true

        <#
            Returns all enforced properties not in desires state, or $null if
            all enforced properties are in desired state.
        #>
        $propertiesNotInDesiredState = $this.Compare()

        if ($propertiesNotInDesiredState)
        {
            $isInDesiredState = $false
        }

        return $isInDesiredState
    }

    # Returns a hashtable containing all properties that should be enforced.
    hidden [System.Collections.Hashtable[]] Compare()
    {
        $currentState = $this.Get() | ConvertTo-HashTableFromObject
        $desiredState = $this | ConvertTo-HashTableFromObject

        # Remove properties that have $null as the value.
        @($desiredState.Keys) | ForEach-Object -Process {
            $isReadProperty = $this.GetType().GetMember($_).CustomAttributes.Where( { $_.NamedArguments.MemberName -eq 'NotConfigurable' }).NamedArguments.TypedValue.Value -eq $true

            # Also remove read properties so that there is no chance to campare those.
            if ($isReadProperty -or $null -eq $desiredState[$_])
            {
                $desiredState.Remove($_)
            }
        }

        $CompareDscParameterState = @{
            CurrentValues     = $currentState
            DesiredValues     = $desiredState
            Properties        = $desiredState.Keys
            ExcludeProperties = @()
            IncludeValue      = $true
        }

        <#
            Returns all enforced properties not in desires state, or $null if
            all enforced properties are in desired state.
        #>
        return (Compare-DscParameterState @CompareDscParameterState)
    }
}
