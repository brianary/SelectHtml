# Pester tests, see https://github.com/Pester/Pester/wiki
Import-LocalizedData -BindingVariable manifest -BaseDirectory ./src/* -FileName (Split-Path $PWD -Leaf)
$psd1 = Resolve-Path ./src/*/bin/Debug/*/*.psd1
if(1 -lt ($psd1 |Measure-Object).Count) {throw "Too many module binaries found: $psd1"}
$module = Import-Module "$psd1" -PassThru -vb

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
	Context 'Select-Html cmdlet' -Tag Cmdlet,Select-Html {
		It "Given uri '<Uri>', '<Expected>' should be returned." -TestCases @(
			@{ Uri = 'https://example.com/'; Expected = 'https://example.com/' }
			@{ Uri = 'https://example.org/'; Expected = 'https://example.org/' }
		) {
			Param([uri]$Uri,$Expected)
			Select-Html $Uri |Should -BeExactly $Expected
		}
	}
}.GetNewClosure()
