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
            Encrypted    = $false
        }
        OpenfireXmlProperty_ModifyProperty_Config = @{
            OpenfireHome = $openfireHome
            PropertyName = 'purple.people'
            Value        = 'pusher'
            Encrypted    = $false
        }
        OpenfireXmlProperty_DeleteProperty_Config = @{
            OpenfireHome = $openfireHome
            PropertyName = 'purple.people'
            Encrypted    = $false
            Ensure       = 'Absent'
        }
        OpenfireXmlProperty_CreateProperty2_Config = @{
            OpenfireHome = $openfireHome
            PropertyName = 'playing.for'
            Value        = 'keeps'
            Encrypted    = $false
        }
        OpenfireXmlProperty_CreatePropertyEnc_Config = @{
            OpenfireHome = $openfireHome
            PropertyName = 'purple.people'
            Value        = 'eater'
            Encrypted    = $true
        }
        OpenfireXmlProperty_ModifyPropertyEnc_Config = @{
            OpenfireHome = $openfireHome
            PropertyName = 'purple.people'
            Value        = 'pusher'
            Encrypted    = $true
        }
        OpenfireXmlProperty_DeletePropertyEnc_Config = @{
            OpenfireHome = $openfireHome
            PropertyName = 'purple.people'
            Encrypted    = $true
            Ensure       = 'Absent'
        }
        OpenfireXmlProperty_CreateProperty2Enc_Config = @{
            OpenfireHome = $openfireHome
            PropertyName = 'playing.for'
            Value        = 'keeps'
            Encrypted    = $true
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
            Encrypted    = $ConfigurationData.NonNodeData.OpenfireXmlProperty_CreateProperty_Config.Encrypted
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
            Encrypted    = $ConfigurationData.NonNodeData.OpenfireXmlProperty_ModifyProperty_Config.Encrypted
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
            Encrypted    = $ConfigurationData.NonNodeData.OpenfireXmlProperty_DeleteProperty_Config.Encrypted
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
            Encrypted    = $ConfigurationData.NonNodeData.OpenfireXmlProperty_CreateProperty2Enc_Config.Encrypted
        }
    }
}

<#
    .SYNOPSIS
        Create a property (encrypted)
#>
configuration OpenfireXmlProperty_CreatePropertyEnc_Config
{
    Import-DscResource -ModuleName 'OpenfireDsc'

    node $AllNodes.NodeName
    {
        OpenfireXmlProperty 'Integration_Test'
        {
            OpenfireHome = $ConfigurationData.NonNodeData.OpenfireXmlProperty_CreatePropertyEnc_Config.OpenfireHome
            PropertyName = $ConfigurationData.NonNodeData.OpenfireXmlProperty_CreatePropertyEnc_Config.PropertyName
            Value        = $ConfigurationData.NonNodeData.OpenfireXmlProperty_CreatePropertyEnc_Config.Value
            Encrypted    = $ConfigurationData.NonNodeData.OpenfireXmlProperty_CreatePropertyEnc_Config.Encrypted
        }
    }
}

<#
    .SYNOPSIS
        Modifies an existing property (encrypted)
#>
configuration OpenfireXmlProperty_ModifyPropertyEnc_Config
{
    Import-DscResource -ModuleName 'OpenfireDsc'

    node $AllNodes.NodeName
    {
        OpenfireXmlProperty 'Integration_Test'
        {
            OpenfireHome = $ConfigurationData.NonNodeData.OpenfireXmlProperty_ModifyPropertyEnc_Config.OpenfireHome
            PropertyName = $ConfigurationData.NonNodeData.OpenfireXmlProperty_ModifyPropertyEnc_Config.PropertyName
            Value        = $ConfigurationData.NonNodeData.OpenfireXmlProperty_ModifyPropertyEnc_Config.Value
            Encrypted    = $ConfigurationData.NonNodeData.OpenfireXmlProperty_ModifyPropertyEnc_Config.Encrypted
        }
    }
}

<#
    .SYNOPSIS
        Deletes an existing property (encrypted)
#>
configuration OpenfireXmlProperty_DeletePropertyEnc_Config
{
    Import-DscResource -ModuleName 'OpenfireDsc'

    node $AllNodes.NodeName
    {
        OpenfireXmlProperty 'Integration_Test'
        {
            OpenfireHome = $ConfigurationData.NonNodeData.OpenfireXmlProperty_DeletePropertyEnc_Config.OpenfireHome
            PropertyName = $ConfigurationData.NonNodeData.OpenfireXmlProperty_DeletePropertyEnc_Config.PropertyName
            Value        = $ConfigurationData.NonNodeData.OpenfireXmlProperty_DeletePropertyEnc_Config.Value
            Encrypted    = $ConfigurationData.NonNodeData.OpenfireXmlProperty_DeletePropertyEnc_Config.Encrypted
            Ensure       = $ConfigurationData.NonNodeData.OpenfireXmlProperty_DeletePropertyEnc_Config.Ensure
        }
    }
}

<#
    .SYNOPSIS
        Create a property that sticks around (encrypted)
#>
configuration OpenfireXmlProperty_CreateProperty2Enc_Config
{
    Import-DscResource -ModuleName 'OpenfireDsc'

    node $AllNodes.NodeName
    {
        OpenfireXmlProperty 'Integration_Test'
        {
            OpenfireHome = $ConfigurationData.NonNodeData.OpenfireXmlProperty_CreateProperty2Enc_Config.OpenfireHome
            PropertyName = $ConfigurationData.NonNodeData.OpenfireXmlProperty_CreateProperty2Enc_Config.PropertyName
            Value        = $ConfigurationData.NonNodeData.OpenfireXmlProperty_CreateProperty2Enc_Config.Value
            Encrypted    = $ConfigurationData.NonNodeData.OpenfireXmlProperty_CreateProperty2Enc_Config.Encrypted
        }
    }
}
