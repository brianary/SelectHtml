# Pester tests, see https://github.com/Pester/Pester/wiki
Import-LocalizedData -BindingVariable manifest -BaseDirectory src -FileName (Split-Path $PWD -Leaf)
$psd1 = Resolve-Path ./src/bin/*/net*/publish/*.psd1
if(1 -lt ($psd1 |Measure-Object).Count) {throw "Too many module binaries found: $psd1"}
$module = Import-Module "$psd1" -PassThru -vb

Describe $module.Name {
	Context 'Select-Html cmdlet' -Tag Cmdlet,Select-Html {
		It "Given XPath '<XPath>' and HTML '<Html>', '<Expected>' should be returned." -TestCases @(
			@{ XPath = '//title'; Html = '<!DOCTYPE html><title>Test Title</title><p>'; Expected = 'Test Title' }
			@{ XPath = '//title'; Html = '<!DOCTYPE html><title>Other Title</title><p>'; Expected = 'Other Title' }
		) {
			Param($XPath,$Html,$Expected)
			$Html |SelectHtml\Select-Html $XPath -vb |Should -BeExactly $Expected
		}
		It "Given XPath '<XPath>' and HTML '<Html>', object '<Expected>' should be returned." -TestCases @(
			@{ XPath = '/table'; Html = '<table><tbody><tr><th><p><strong>Count</strong></p></th><th><p><strong>Name</strong></p></th>
				<th><p><strong>Audience</strong></p></th></tr><tr><td><p>9</p></td><td><p>Accounts</p></td><td><p>Members</p></td></tr>
				</tbody></table>'; Expected = [pscustomobject]@{Count=9;Name='Accounts';Audience='Members'} }
		) {
			Param($XPath,$Html,$Expected)
			$selected = $Html |SelectHtml\Select-Html $XPath -vb
			$props = $selected.PSObject.Properties.Name
			$props |ForEach-Object {$selected.$_ |Should -BeExactly $Expected.$_}
		}
		It "Given XPath '<XPath>' and file '<Path>', '<Expected>' should be returned." -TestCases @(
			@{ XPath = '//title'; Path = "$PSScriptRoot/csharp-history.html"; Expected = 'C# History' }
			@{ XPath = '//table/thead'; Path = "$PSScriptRoot/csharp-history.html"; Expected = '*Feature*' }
		) {
			Param($XPath,$Path,$Expected)
			SelectHtml\Select-Html $XPath -Path $Path -vb |Should -BeLike $Expected
		}
		It "Given XPath '<XPath>' and file '<Path>', value #<Row> of the result should be '<Expected>'." -TestCases @(
			@{ XPath = '//ul[contains(.,"QuickRef")]'; Path = "$PSScriptRoot/xslt2.html"; Row = 0; Expected = 'XSLT 2.0 QuickRef*' }
		) {
			Param($XPath,$Path,$Row,$Expected)
			[string[]] $table = SelectHtml\Select-Html $XPath -Path $Path -vb
			$table[$Row] |Should -BeLike $Expected
		}
		It "Given XPath '<XPath>' and file '<Path>', row #<Row> property '<Property>' of the result should be '<Expected>'." -TestCases @(
			@{ XPath = '//table'; Path = "$PSScriptRoot/csharp-history.html"; Row = 0; Property = 'Feature'; Expected = 'Anonymous methods' }
			@{ XPath = '//table'; Path = "$PSScriptRoot/csharp-history.html"; Row = 4; Property = 'Version'; Expected = '7.0' }
			@{ XPath = '//table'; Path = "$PSScriptRoot/csharp-history.html"; Row = 5; Property = 'Released'; Expected = '2010-04-12' }
		) {
			Param($XPath,$Path,$Row,$Property,$Expected)
			[psobject[]] $table = SelectHtml\Select-Html $XPath -Path $Path -vb
			$table[$Row].$Property |Should -BeExactly $Expected
		}
		It "Given XPath '<XPath>' and URL '<Url>', '<Expected>' should be returned." -TestCases @(
			@{ XPath = '//section[@id="main_content"]/h1'; Url = 'http://webcoder.info/windowskey.html'; Like = 'Windows Key Shortcuts for Windows*' }
			@{ XPath = '//section/p/a'; Url = 'http://webcoder.info/windowskey.html'; Like = 'Windows Key' }
		) {
			Param($XPath,$Url,$Like)
			SelectHtml\Select-Html $XPath -Uri $Url -vb |Should -BeLike $Like
		}
	}
}.GetNewClosure()
