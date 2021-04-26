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

    [System.Xml.XmlDocument] parseConfig()
    {
        $configFilePath = '{0}\conf\{1}' -f $this.OpenfireHome, $this.ConfigFileName
        return (Get-Content -Encoding UTF8 -Path $configFilePath)
    }

    [System.Xml.XmlDocument] parseSecurity()
    {
        $configFilePath = '{0}\conf\{1}' -f $this.OpenfireHome, 'security.xml'
        return (Get-Content -Encoding UTF8 -Path $configFilePath)
    }

    [bool] $currentlyEncrypted = $false

    [void] saveXml([xml] $xmlDoc)
    {
        $configFilePath = '{0}\conf\{1}' -f $this.OpenfireHome, $this.ConfigFileName
        $settings = [System.Xml.XmlWriterSettings]::new()
        $settings.Encoding = [System.Text.UTF8Encoding]::new($false) # Do not emit Byte Order Mark (it breaks Java SAX parser)
        $settings.Indent = $true
        $settings.IndentChars = "    "
        $writer = [System.Xml.XmlTextWriter]::Create($configFilePath, $settings)
        $xmlDoc.Save($writer)
        $writer.Flush()
        $writer.CLose()
        $writer.Dispose()
    }

    [void] saveSecurity([xml] $xmlDoc)
    {
        $configFilePath = '{0}\conf\{1}' -f $this.OpenfireHome, 'security.xml'
        $settings = [System.Xml.XmlWriterSettings]::new()
        $settings.Encoding = [System.Text.UTF8Encoding]::new($false) # Do not emit Byte Order Mark (it breaks Java SAX parser)
        $settings.Indent = $true
        $settings.IndentChars = "    "
        $writer = [System.Xml.XmlTextWriter]::Create($configFilePath, $settings)
        $xmlDoc.Save($writer)
        $writer.Flush()
        $writer.CLose()
        $writer.Dispose()
    }

    # OVERRIDES

    # Gets the encryption state of the property
    [System.Boolean] getIsEncrypted()
    {
        # Ensure the currentlyEncrypted field is populated
        [void] $this.ReadProperty()
        return $this.currentlyEncrypted
    }

    # Create a new property
    [void] CreateProperty()
    {
        # Read in the XML
        [xml] $xml = $this.parseConfig()

        # Create the elements along the XML path
        $parent = $xml.jive
        $xmlPathElements = $this.PropertyName.Split('.')

        foreach ($xmlPathElement in $xmlPathElements)
        {
            $targetNode = $parent.SelectSingleNode($xmlPathElement)

            if ($null -eq $targetNode)
            {
                $newNode = $xml.CreateElement($xmlPathElement)
                $targetNode = $parent.AppendChild($newNode)
            }

            # Set up next loop
            $parent = $targetNode
        }

        # last object created is now the target node
        $targetNode = $parent

        if ($this.Encrypted)
        {
            $this.initJiveGlobals()

            # Generate the encrypted value
            $encryptor = Invoke-StaticJavaMethod -InputObject $this.jiveGlobals -MethodName 'getPropertyEncryptor'
            $encValue = $encryptor.encrypt($this.Value)

            # Set the 'encrypted' attribute on the last element to 'true'
            $newAttribute = $xml.CreateAttribute('encrypted')
            $newAttribute.InnerText = 'true'
            $targetNode.Attributes.Append($newAttribute)

            # Set the inner text to the encrypted value
            $targetNode.InnerText = $encValue

            # Ensure an entry exists in security.xml
            $sec = $this.parseSecurity()
            if ($this.PropertyName -notin $sec.security.encrypt.property.name)
            {
                $propNode = $sec.SelectSingleNode('/security/encrypt/property')
                $propNameNode = $sec.CreateElement('name')
                $propNameNode.InnerText = $this.PropertyName
                $propNode.AppendChild($propNameNode)
                $this.saveSecurity($sec)
            }
        }
        else
        {
            # Set the inner text to the unencrypted value
            $targetNode.InnerText = $this.Value
        }

        # Save the XML
        $this.saveXml($xml)
    }

    # Read the value of a property
    [System.String] ReadProperty()
    {
        [xml] $xml = $this.parseConfig()
        [xml] $sec = $this.parseSecurity()
        $data = Invoke-Expression ('$xml.jive.{0}' -f $this.PropertyName)
        $this.currentlyEncrypted = ($data.encrypted -eq 'true') -and ($this.PropertyName -in $sec.security.encrypt.property.name)

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

    # Update and existing property
    [void] UpdateProperty()
    {
        # Updates and creation follow the same pattern
        $this.CreateProperty()
    }

    # remove an existing property
    [void] DeleteProperty()
    {
        # Read in the XML
        [xml] $xml = $this.parseConfig()

        # Get elements of the XML path
        [string[]] $xmlPathElements = $this.PropertyName.Split('.')

        # Walk the path back, deleting elements with no children
        for ($i = $xmlPathElements.Count; $i -gt 0; $i--)
        {
            $elementPath = ($xmlPathElements | Select-Object -First $i) -join "/"
            $element = $xml.jive.SelectSingleNode($elementPath)
            if (($element.ChildNodes.Count -eq 1 -and $element.ChildNodes.NodeType -eq 'Text') -or -not $element.HasChildNodes)
            {
                [void] $element.ParentNode.RemoveChild($element)
            }
        }

        $this.saveXml($xml)

        # Remove any entries from security.xml
        [xml] $sec = $this.parseSecurity()
        $propNameNode = $sec.SelectSingleNode(("/security/encrypt/property/name[text()='{0}']" -f $this.PropertyName))
        if ($propNameNode)
        {
            # Remove the node
            $propNameNode.ParentNode.RemoveChild($propNameNode)
            $this.saveSecurity($sec)
        }
    }
}
