<#
.SYNOPSIS
    Basic functionality for Openfire resources
.DESCRIPTION
    Basic functionality for Openfire resources
#>
class OpenfireBase
{
    [DscProperty(Key)]
    [System.String]
    $OpenfireHome

    [DscProperty()]
    [System.String]
    $ConfigFileName = 'openfire.xml'

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
                $tmpData = Get-LocalizedData -DefaultUICulture 'en-US' -FileName $localizationFile -BaseDirectory $PSScriptRoot -ErrorAction Stop

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

    hidden [java.net.URLClassloader] $classloader

    # Default constructor sets the $isScoped variable and loads the localization strings
    OpenfireBase()
    {
        # Import the localization strings.
        $this.SetLocalizedData()
    }

    [java.lang.Class] LoadJavaClass([System.String] $FullClassName)
    {
        if ($null -eq $this.classloader)
        {
            # Set the classloader based on the OpenfireHome variable
            $openfireJarPath = Get-Item "$($this.OpenfireHome)\lib\xmppserver-*.jar" | Select-Object -First 1
            $jarFileObj = [java.io.File]::new($openfireJarPath)
            $url = [java.net.URL]::new($jarFileObj.toURI().toURL())
            $urlArray = [java.net.URL[]]::new(1)
            $urlArray[0] = $url
            $currentCl = [java.lang.Thread]::currentThread().getContextClassLoader()
            $this.classloader = [java.net.URLClassloader]::newInstance($urlArray, $currentCl)
        }

        return $this.classloader.loadClass($FullClassName)
    }

    [OpenfireBase] Get()
    {
        return $this
    }

    [void] Set()
    {
        throw "Set() not Implemented"
    }

    # Compare current state to desired state. Should not be overridden.
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
