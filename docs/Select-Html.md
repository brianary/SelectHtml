---
external help file: SelectHtml.dll-Help.xml
Module Name: SelectHtml
online version:
schema: 2.0.0
---

# Select-Html

## SYNOPSIS
Returns content from the HTML retrieved from a URL.

## SYNTAX

### Html (Default)
```
Select-Html [-XPath] <String> -Html <String> [<CommonParameters>]
```

### Uri
```
Select-Html [-XPath] <String> [-Uri] <Uri> [<CommonParameters>]
```

### Path
```
Select-Html [-XPath] <String> -Path <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> Select-Html //title https://www.h2g2.com/
```

```txt
h2g2 - The Guide to Life, The Universe and Everything
```

### Example 2
```powershell
PS C:\> Select-Html '//*[contains(concat(" ", normalize-space(@class), " "), " page-status ")]' https://www.githubstatus.com/
```

```txt
All Systems Operational
```

### Example 3
```powershell
PS C:\> Select-Html //table https://www.irs.gov/e-file-providers/foreign-country-code-listing-for-modernized-e-file
```

```txt
CountryName CountryCode
----------- -----------
Afghanistan AF
Akrotiri    AX
Albania     AL
...
```

### Example 4
```powershell
PS C:\> Select-Html //table https://www.federalreserve.gov/aboutthefed/k8.htm |Format-Table -AutoSize
```

```txt
nbsp                                 2021         2022          2023         2024        2025
--------                             ----         ----          ----         ----        ----
New Year's Day                       January 1    January 1*    January 1**  January 1   January 1
Birthday of Martin Luther King, Jr.  January 18   January 17    January 16   January 15  January 20
Washington's Birthday                February 15  February 21   February 20  February 19 February 17
Memorial Day                         May 31       May 30        May 29       May 27      May 26
Juneteenth National Independence Day June 19*     June 19**     June 19      June 19     June 19
Independence Day                     July 4**     July 4        July 4       July 4      July 4
Labor Day                            September 6  September 5   September 4  September 2 September 1
Columbus Day                         October 11   October 10    October 9    October 14  October 13
Veterans Day                         November 11  November 11   November 11* November 11 November 11
Thanksgiving Day                     November 25  November 24   November 23  November 28 November 27
Christmas Day                        December 25* December 25** December 25  December 25 December 25
```

## PARAMETERS

### -Html
The HTML to read from.

```yaml
Type: String
Parameter Sets: Html
Aliases: Content

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Path
The file to read the HTML from.

```yaml
Type: String
Parameter Sets: Path
Aliases: FullName

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Uri
The URL to read the HTML from.

```yaml
Type: Uri
Parameter Sets: Uri
Aliases: Url

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -XPath
XPath that specifies the HTML elements to extract.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Select

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

### System.Uri

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS
