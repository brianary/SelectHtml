# see https://docs.microsoft.com/powershell/scripting/developer/module/how-to-write-a-powershell-module-manifest
# and https://docs.microsoft.com/powershell/module/microsoft.powershell.core/new-modulemanifest
@{
RootModule = 'SelectHtml.dll'
ModuleVersion = '1.0.0'
CompatiblePSEditions = @('Core','Desktop')
GUID = '28f9b47e-c048-4923-9361-9a0ea6bab4c7'
Author = 'Brian Lalonde'
# CompanyName = 'Unknown'
Copyright = '(c) Brian Lalonde. All rights reserved.'
Description = 'Returns content from the HTML retrieved from a URL..'
PowerShellVersion = '5.1'
FunctionsToExport = @()
CmdletsToExport = @('Select-Html')
VariablesToExport = @()
AliasesToExport = @()
FileList = @('SelectHtml.dll','SelectHtml.dll-Help.xml')
PrivateData = @{
    PSData = @{
        Tags = @('scrape','html','agility')
        # LicenseUri = ''
        # ProjectUri = ''
        # IconUri = ''
        # ReleaseNotes = ''
    }
}
}
