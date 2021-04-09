@{
    # Version number of this module.
    moduleVersion        = '0.0.2'

    # ID used to uniquely identify this module
    GUID                 = '5743e617-dfdb-472f-a80d-8dc5fadb8304'

    # Author of this module
    Author               = 'James Sudbury'

    # Company or vendor of this module
    CompanyName          = 'Sudstyle.com'

    # Copyright statement for this module
    Copyright            = 'Copyright James Sudbury. All rights reserved.'

    # Description of the functionality provided by this module
    Description          = 'This module contains DSC resources for the management and configuration of Ingnite Realtime''s Openfire server.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion    = '5.0'

    # Script module or binary module file associated with this manifest.
    RootModule           = 'OpenfireDsc.psm1'

    NestedModules        = '.\preload.ps1' # Load IKVM before the main module loads

    # Functions to export from this module
    FunctionsToExport    = @()

    # Cmdlets to export from this module
    CmdletsToExport      = @()

    # Variables to export from this module
    VariablesToExport    = @()

    # Aliases to export from this module
    AliasesToExport      = @()

    DscResourcesToExport = @()

    <#
      Private data to pass to the module specified in RootModule/ModuleToProcess.
      This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    #>
    PrivateData          = @{
        PSData = @{
            # Set to a prerelease string value if the release should be a prerelease.
            Prerelease   = ''

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags         = @('DesiredStateConfiguration', 'DSC', 'DSCResource')

            # A URL to the license for this module.
            # LicenseUri   = 'https://github.com/dsccommunity/DnsServerDsc/blob/main/LICENSE'

            # A URL to the main website for this project.
            # ProjectUri   = 'https://github.com/dsccommunity/DnsServerDsc'

            # A URL to an icon representing this module.
            # IconUri      = 'https://dsccommunity.org/images/DSC_Logo_300p.png'

            # ReleaseNotes of this module
            ReleaseNotes = ''
        } # End of PSData hashtable
    } # End of PrivateData hashtable
}
