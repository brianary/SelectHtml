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
		It "Given XPath '<XPath>' and HTML '<Html>', '<Expected>' should be returned." -TestCases @(
			@{ XPath = '//title'; Html = '<!DOCTYPE html><title>Test Title</title><p>'; Expected = 'Test Title' }
			@{ XPath = '//title'; Html = '<!DOCTYPE html><title>Other Title</title><p>'; Expected = 'Other Title' }
		) {
			Param($XPath,$Html,$Expected)
			$Html |SelectHtml\Select-Html $XPath -vb |Should -BeExactly $Expected
		}
		It "Given XPath '<XPath>' and file '<Path>', '<Expected>' should be returned." -TestCases @(
			@{ XPath = '//title'; Path = "$PSScriptRoot/test/csharp-history.html"; Expected = 'C# History' }
			@{ XPath = '//table/thead'; Path = "$PSScriptRoot/test/csharp-history.html"; Expected = '*Feature*' }
		) {
			Param($XPath,$Path,$Expected)
			SelectHtml\Select-Html $XPath -Path $Path -vb |Should -BeLike $Expected
		}
		It "Given XPath '<XPath>' and file '<Path>', value #<Row> of the result should be '<Expected>'." -TestCases @(
			@{ XPath = '//ul[contains(.,"QuickRef")]'; Path = "$PSScriptRoot/test/xslt2.html"; Row = 0; Expected = 'XSLT 2.0 QuickRef*' }
		) {
			Param($XPath,$Path,$Row,$Expected)
			[string[]] $table = SelectHtml\Select-Html $XPath -Path $Path -vb
			$table[$Row] |Should -BeLike $Expected
		}
		It "Given XPath '<XPath>' and file '<Path>', row #<Row> property '<Property>' of the result should be '<Expected>'." -TestCases @(
			@{ XPath = '//table'; Path = "$PSScriptRoot/test/csharp-history.html"; Row = 0; Property = 'Feature'; Expected = 'Anonymous methods' }
			@{ XPath = '//table'; Path = "$PSScriptRoot/test/csharp-history.html"; Row = 4; Property = 'Version'; Expected = '7.0' }
			@{ XPath = '//table'; Path = "$PSScriptRoot/test/csharp-history.html"; Row = 5; Property = 'Released'; Expected = '2010-04-12' }
		) {
			Param($XPath,$Path,$Row,$Property,$Expected)
			[psobject[]] $table = SelectHtml\Select-Html $XPath -Path $Path -vb
			$table[$Row].$Property |Should -BeExactly $Expected
		}
		It "Given XPath '<XPath>' and URL '<Url>', '<Expected>' should be returned." -TestCases @(
			@{ XPath = '//section[@id="main_content"]/h1'; Url = 'http://webcoder.info/windowskey.html'; Expected = 'Windows Key Shortcuts for Windows 10' }
			@{ XPath = '//section/p/a'; Url = 'http://webcoder.info/windowskey.html'; Expected = 'Windows Key' }
		) {
			Param($XPath,$Url,$Expected)
			SelectHtml\Select-Html $XPath -Uri $Url -vb |Should -BeExactly $Expected
		}
	}
}.GetNewClosure()
