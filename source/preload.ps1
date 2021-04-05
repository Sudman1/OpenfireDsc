# Load IKVM if it's not already loaded
try
{
    [void] [java.lang.class]
}
catch
{
    # Write-Verbose $this.localizedData.LoadIKVM

    $dlls = Get-ChildItem "$($PSScriptRoot)\ikvm8\lib\" -Filter "*.dll"

    foreach ($file in $dlls)
    {
        [system.reflection.assembly]::LoadFile($file.FullName) | Write-Verbose
    }
}
