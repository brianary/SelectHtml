# Pester tests, see https://github.com/Pester/Pester/wiki
$envPath = $env:Path # avoid testing the wrong cmdlets
$module = Import-Module (Resolve-Path ./src/*/bin/Debug/*/*.psd1) -PassThru -vb
Import-LocalizedData -BindingVariable manifest -BaseDirectory ./src/* -FileName (Split-Path $PWD -Leaf)
Describe $module.Name {
    Context "$($module.Name) module" -Tag Module {
        It "Given the module, the version should match the manifest version" {
            $module.Version |Should -BeExactly $manifest.ModuleVersion
        }
		It "Given the module, the DLL file version should match the manifest version" {
            (Get-Item "$($module.ModuleBase)\$($module.Name).dll").VersionInfo.FileVersionRaw |
                Should -BeLike "$($manifest.ModuleVersion)*"
		}
		It "Given the module, the DLL product version should match the manifest version" {
            (Get-Item "$($module.ModuleBase)\$($module.Name).dll").VersionInfo.ProductVersionRaw |
                Should -BeLike "$($manifest.ModuleVersion)*"
		} -Pending
		It "Given the module, the DLL should have a valid semantic product version" {
			$v = (Get-Item "$($module.ModuleBase)\$($module.Name).dll").VersionInfo.ProductVersion
			[semver]::TryParse($v, [ref]$null) |Should -BeTrue
		} -Pending
    }
    Context 'Get-Foo cmdlet' -Tag Cmdlet,Get-Foo {
        It "Given a name '<Name>', '<Expected>' should be returned." -TestCases @(
            @{ Name = 'Hello, world'; Expected = 'Hello, world' }
            @{ Name = 'Zaphod'; Expected = 'Zaphod' }
        ) {
            Param($Name,$Expected)
            Get-Foo $Name |Should -BeExactly $Expected
        }
    }
}.GetNewClosure()
$env:Path = $envPath
