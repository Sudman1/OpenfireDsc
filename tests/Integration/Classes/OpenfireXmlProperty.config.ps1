$openfireHome = (Resolve-Path -Path "$PSScriptRoot\..\..\TestOpenfireHome").ProviderPath

$ConfigurationData = @{
    AllNodes    = , @{
        NodeName        = 'localhost'
        CertificateFile = $Null
    }
    NonNodeData = @{
        OpenfireXmlProperty_CreateProperty_Config = @{
            OpenfireHome = $openfireHome
            PropertyName = 'purple.people'
            Value        = 'eater'
        }
        OpenfireXmlProperty_ModifyProperty_Config = @{
            OpenfireHome = $openfireHome
            PropertyName = 'purple.people'
            Value        = 'pusher'
        }
        OpenfireXmlProperty_DeleteProperty_Config = @{
            OpenfireHome = $openfireHome
            PropertyName = 'purple.people'
            Ensure       = 'Absent'
        }
        OpenfireXmlProperty_CreateProperty2_Config = @{
            OpenfireHome = $openfireHome
            PropertyName = 'playing.for'
            Value        = 'keeps'
        }
    }
}

<#
    .SYNOPSIS
        Create a property
#>
configuration OpenfireXmlProperty_CreateProperty_Config
{
    Import-DscResource -ModuleName 'OpenfireDsc'

    node $AllNodes.NodeName
    {
        OpenfireXmlProperty 'Integration_Test'
        {
            OpenfireHome = $ConfigurationData.NonNodeData.OpenfireXmlProperty_CreateProperty_Config.OpenfireHome
            PropertyName = $ConfigurationData.NonNodeData.OpenfireXmlProperty_CreateProperty_Config.PropertyName
            Value        = $ConfigurationData.NonNodeData.OpenfireXmlProperty_CreateProperty_Config.Value
        }
    }
}

<#
    .SYNOPSIS
        Modifies an existing property
#>
configuration OpenfireXmlProperty_ModifyProperty_Config
{
    Import-DscResource -ModuleName 'OpenfireDsc'

    node $AllNodes.NodeName
    {
        OpenfireXmlProperty 'Integration_Test'
        {
            OpenfireHome = $ConfigurationData.NonNodeData.OpenfireXmlProperty_ModifyProperty_Config.OpenfireHome
            PropertyName = $ConfigurationData.NonNodeData.OpenfireXmlProperty_ModifyProperty_Config.PropertyName
            Value        = $ConfigurationData.NonNodeData.OpenfireXmlProperty_ModifyProperty_Config.Value
        }
    }
}

<#
    .SYNOPSIS
        Deletes an existing property
#>
configuration OpenfireXmlProperty_DeleteProperty_Config
{
    Import-DscResource -ModuleName 'OpenfireDsc'

    node $AllNodes.NodeName
    {
        OpenfireXmlProperty 'Integration_Test'
        {
            OpenfireHome = $ConfigurationData.NonNodeData.OpenfireXmlProperty_DeleteProperty_Config.OpenfireHome
            PropertyName = $ConfigurationData.NonNodeData.OpenfireXmlProperty_DeleteProperty_Config.PropertyName
            Value        = $ConfigurationData.NonNodeData.OpenfireXmlProperty_DeleteProperty_Config.Value
            Ensure       = $ConfigurationData.NonNodeData.OpenfireXmlProperty_DeleteProperty_Config.Ensure
        }
    }
}

<#
    .SYNOPSIS
        Create a property that sticks around
#>
configuration OpenfireXmlProperty_CreateProperty2_Config
{
    Import-DscResource -ModuleName 'OpenfireDsc'

    node $AllNodes.NodeName
    {
        OpenfireXmlProperty 'Integration_Test'
        {
            OpenfireHome = $ConfigurationData.NonNodeData.OpenfireXmlProperty_CreateProperty2_Config.OpenfireHome
            PropertyName = $ConfigurationData.NonNodeData.OpenfireXmlProperty_CreateProperty2_Config.PropertyName
            Value        = $ConfigurationData.NonNodeData.OpenfireXmlProperty_CreateProperty2_Config.Value
        }
    }
}
