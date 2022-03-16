namespace SelectHtml

open System
open System.Management.Automation

open HtmlAgilityPack

/// Returns content from the HTML retrieved from a URL.
[<Cmdlet(VerbsCommon.Select, "Html", DefaultParameterSetName="__AllParameterSets")>]
[<OutputType(typeof<PSObject>)>]
type SelectHtmlCommand () =
    inherit PSCmdlet ()

    /// The URL to read the HTML from.
    [<Parameter(Position=0,Mandatory=true)>]
    [<ValidateNotNullOrEmpty>]
    member val Uri : Uri = null with get, set

    /// The name of elements to return all occurrences of,
    /// or a dot followed by the class of elements to return all occurrences of,
    /// or a hash followed by the ID of elements to return all occurrences of.
    [<Parameter(Position=1)>]
    [<ValidateNotNullOrEmpty>]
    member val Select : string = "table" with get, set

    /// Only elements whose inner text contain this value are included.
    [<Parameter(ParameterSetName="Contains",Position=2,Mandatory=true)>]
    [<ValidateNotNullOrEmpty>]
    member val Contains : string = "" with get, set

    /// The position of an individual element to select, or all matching elements by default.
    [<Parameter(ParameterSetName="Index",Position=2,Mandatory=true)>]
    member val Index : int = -1 with get, set

    /// Indicates the attributes of the element should be returned rather than the content.
    member val Attributes : SwitchParameter = (SwitchParameter false) with get, set

    // optional: setup before pipeline input starts (e.g. Name is set, InputObject is not)
    override x.BeginProcessing () =
        base.BeginProcessing ()

    // optional: handle each pipeline value (e.g. InputObject)
    override x.ProcessRecord () =
        base.ProcessRecord ()

    // optional: finish after all pipeline input
    override x.EndProcessing () =
        x.WriteObject x.Uri
        base.EndProcessing ()
