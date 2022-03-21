# see https://docs.microsoft.com/powershell/scripting/developer/module/how-to-write-a-powershell-module-manifest
# and https://docs.microsoft.com/powershell/module/microsoft.powershell.core/new-modulemanifest
@{
RootModule = 'SelectHtml.dll'
ModuleVersion = '1.0.0'
CompatiblePSEditions = @('Core','Desktop')
GUID = '28f9b47e-c048-4923-9361-9a0ea6bab4c7'
Author = 'Brian Lalonde'
# CompanyName = 'Unknown'
Copyright = 'Copyright © 2022 Brian Lalonde. All rights reserved.'
Description = 'Extracts content from an HTML document using an XPath expression.'
PowerShellVersion = '5.1'
FunctionsToExport = @()
CmdletsToExport = @('Select-Html')
VariablesToExport = @()
AliasesToExport = @()
FileList = @('SelectHtml.dll','SelectHtml.dll-Help.xml')
PrivateData = @{
    PSData = @{
        Tags = @('scrape','html','agility')
        LicenseUri = 'https://github.com/brianary/SelectHtml/blob/master/LICENSE'
        ProjectUri = 'https://github.com/brianary/SelectHtml/'
        IconUri = 'http://webcoder.info/images/SelectHtml.svg'
        # ReleaseNotes = ''
    }
}
}
