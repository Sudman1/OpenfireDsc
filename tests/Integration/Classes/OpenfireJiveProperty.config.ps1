$openfireHome = (Resolve-Path -Path "$PSScriptRoot\..\..\TestOpenfireHome").ProviderPath

$ConfigurationData = @{
    AllNodes    = , @{
        NodeName        = 'localhost'
        CertificateFile = $Null
    }
    NonNodeData = @{
        OpenfireJiveProperty_CreateProperty_Config = @{
            OpenfireHome = $openfireHome
            PropertyName = 'new.jive.property'
            Encrypted    = $false
            Value        = 'Foo'
        }
        OpenfireJiveProperty_ModifyProperty_Config = @{
            OpenfireHome = $openfireHome
            PropertyName = 'new.jive.property'
            Encrypted    = $false
            Value        = 'Bar'
        }
        OpenfireJiveProperty_DeleteProperty_Config = @{
            OpenfireHome = $openfireHome
            PropertyName = 'new.jive.property'
            Encrypted    = $false
            Ensure       = 'Absent'
        }
        OpenfireJiveProperty_CreateProperty2_Config = @{
            OpenfireHome = $openfireHome
            PropertyName = 'playing.for'
            Value        = 'hoarding'
            Encrypted    = $false
        }
        OpenfireJiveProperty_CreatePropertyEnc_Config = @{
            OpenfireHome = $openfireHome
            PropertyName = 'new.jive.property'
            Value        = 'Foo'
            Encrypted    = $true
        }
        OpenfireJiveProperty_ModifyPropertyEnc_Config = @{
            OpenfireHome = $openfireHome
            PropertyName = 'new.jive.property'
            Value        = 'Bar'
            Encrypted    = $true
        }
        OpenfireJiveProperty_DeletePropertyEnc_Config = @{
            OpenfireHome = $openfireHome
            PropertyName = 'new.jive.property'
            Encrypted    = $true
            Ensure       = 'Absent'
        }
        OpenfireJiveProperty_CreateProperty2Enc_Config = @{
            OpenfireHome = $openfireHome
            PropertyName = 'playing.for'
            Value        = 'hoarding'
            Encrypted    = $true
        }
    }
}

<#
    .SYNOPSIS
        Create a property
#>
configuration OpenfireJiveProperty_CreateProperty_Config
{
    Import-DscResource -ModuleName 'OpenfireDsc'

    node $AllNodes.NodeName
    {
        OpenfireJiveProperty 'Integration_Test'
        {
            OpenfireHome = $ConfigurationData.NonNodeData.OpenfireJiveProperty_CreateProperty_Config.OpenfireHome
            PropertyName = $ConfigurationData.NonNodeData.OpenfireJiveProperty_CreateProperty_Config.PropertyName
            Value        = $ConfigurationData.NonNodeData.OpenfireJiveProperty_CreateProperty_Config.Value
        }
    }
}

<#
    .SYNOPSIS
        Modifies an existing property
#>
configuration OpenfireJiveProperty_ModifyProperty_Config
{
    Import-DscResource -ModuleName 'OpenfireDsc'

    node $AllNodes.NodeName
    {
        OpenfireJiveProperty 'Integration_Test'
        {
            OpenfireHome = $ConfigurationData.NonNodeData.OpenfireJiveProperty_ModifyProperty_Config.OpenfireHome
            PropertyName = $ConfigurationData.NonNodeData.OpenfireJiveProperty_ModifyProperty_Config.PropertyName
            Value        = $ConfigurationData.NonNodeData.OpenfireJiveProperty_ModifyProperty_Config.Value
        }
    }
}

<#
    .SYNOPSIS
        Deletes an existing property
#>
configuration OpenfireJiveProperty_DeleteProperty_Config
{
    Import-DscResource -ModuleName 'OpenfireDsc'

    node $AllNodes.NodeName
    {
        OpenfireJiveProperty 'Integration_Test'
        {
            OpenfireHome = $ConfigurationData.NonNodeData.OpenfireJiveProperty_DeleteProperty_Config.OpenfireHome
            PropertyName = $ConfigurationData.NonNodeData.OpenfireJiveProperty_DeleteProperty_Config.PropertyName
            Value        = $ConfigurationData.NonNodeData.OpenfireJiveProperty_DeleteProperty_Config.Value
            Ensure       = $ConfigurationData.NonNodeData.OpenfireJiveProperty_DeleteProperty_Config.Ensure
        }
    }
}

<#
    .SYNOPSIS
        Create a property that sticks around
#>
configuration OpenfireJiveProperty_CreateProperty2_Config
{
    Import-DscResource -ModuleName 'OpenfireDsc'

    node $AllNodes.NodeName
    {
        OpenfireJiveProperty 'Integration_Test'
        {
            OpenfireHome = $ConfigurationData.NonNodeData.OpenfireJiveProperty_CreateProperty2_Config.OpenfireHome
            PropertyName = $ConfigurationData.NonNodeData.OpenfireJiveProperty_CreateProperty2_Config.PropertyName
            Value        = $ConfigurationData.NonNodeData.OpenfireJiveProperty_CreateProperty2_Config.Value
        }
    }
}

<#
    .SYNOPSIS
        Create a property (encrypted)
#>
configuration OpenfireJiveProperty_CreatePropertyEnc_Config
{
    Import-DscResource -ModuleName 'OpenfireDsc'

    node $AllNodes.NodeName
    {
        OpenfireJiveProperty 'Integration_Test'
        {
            OpenfireHome = $ConfigurationData.NonNodeData.OpenfireJiveProperty_CreatePropertyEnc_Config.OpenfireHome
            PropertyName = $ConfigurationData.NonNodeData.OpenfireJiveProperty_CreatePropertyEnc_Config.PropertyName
            Value        = $ConfigurationData.NonNodeData.OpenfireJiveProperty_CreatePropertyEnc_Config.Value
            Encrypted    = $ConfigurationData.NonNodeData.OpenfireJiveProperty_CreatePropertyEnc_Config.Encrypted
        }
    }
}

<#
    .SYNOPSIS
        Modifies an existing property (encrypted)
#>
configuration OpenfireJiveProperty_ModifyPropertyEnc_Config
{
    Import-DscResource -ModuleName 'OpenfireDsc'

    node $AllNodes.NodeName
    {
        OpenfireJiveProperty 'Integration_Test'
        {
            OpenfireHome = $ConfigurationData.NonNodeData.OpenfireJiveProperty_ModifyPropertyEnc_Config.OpenfireHome
            PropertyName = $ConfigurationData.NonNodeData.OpenfireJiveProperty_ModifyPropertyEnc_Config.PropertyName
            Value        = $ConfigurationData.NonNodeData.OpenfireJiveProperty_ModifyPropertyEnc_Config.Value
            Encrypted    = $ConfigurationData.NonNodeData.OpenfireJiveProperty_ModifyPropertyEnc_Config.Encrypted
        }
    }
}

<#
    .SYNOPSIS
        Deletes an existing property (encrypted)
#>
configuration OpenfireJiveProperty_DeletePropertyEnc_Config
{
    Import-DscResource -ModuleName 'OpenfireDsc'

    node $AllNodes.NodeName
    {
        OpenfireJiveProperty 'Integration_Test'
        {
            OpenfireHome = $ConfigurationData.NonNodeData.OpenfireJiveProperty_DeletePropertyEnc_Config.OpenfireHome
            PropertyName = $ConfigurationData.NonNodeData.OpenfireJiveProperty_DeletePropertyEnc_Config.PropertyName
            Value        = $ConfigurationData.NonNodeData.OpenfireJiveProperty_DeletePropertyEnc_Config.Value
            Encrypted    = $ConfigurationData.NonNodeData.OpenfireJiveProperty_DeletePropertyEnc_Config.Encrypted
            Ensure       = $ConfigurationData.NonNodeData.OpenfireJiveProperty_DeletePropertyEnc_Config.Ensure
        }
    }
}

<#
    .SYNOPSIS
        Create a property that sticks around (encrypted)
#>
configuration OpenfireJiveProperty_CreateProperty2Enc_Config
{
    Import-DscResource -ModuleName 'OpenfireDsc'

    node $AllNodes.NodeName
    {
        OpenfireJiveProperty 'Integration_Test'
        {
            OpenfireHome = $ConfigurationData.NonNodeData.OpenfireJiveProperty_CreateProperty2Enc_Config.OpenfireHome
            PropertyName = $ConfigurationData.NonNodeData.OpenfireJiveProperty_CreateProperty2Enc_Config.PropertyName
            Value        = $ConfigurationData.NonNodeData.OpenfireJiveProperty_CreateProperty2Enc_Config.Value
            Encrypted    = $ConfigurationData.NonNodeData.OpenfireJiveProperty_CreateProperty2Enc_Config.Encrypted
        }
    }
}
