namespace SelectHtml

open System
open System.Management.Automation

open HtmlAgilityPack

/// Returns content from the HTML retrieved from a URL.
[<Cmdlet(VerbsCommon.Select, "Html", DefaultParameterSetName="Html")>]
[<OutputType(typeof<PSObject>)>]
type SelectHtmlCommand () =
    inherit PSCmdlet ()

    /// The name of elements to return all occurrences of,
    /// or a dot followed by the class of elements to return all occurrences of,
    /// or a hash followed by the ID of elements to return all occurrences of.
    [<Parameter(Position=0,Mandatory=true)>]
    [<ValidateNotNullOrEmpty>]
    [<Alias("Select")>]
    member val XPath : string = "//table" with get, set

    /// The HTML to read from.
    [<Parameter(ParameterSetName="Html",Mandatory=true,ValueFromPipeline=true)>]
    [<ValidateNotNullOrEmpty>]
    [<Alias("Content")>]
    member val Html : string = "<!DOCTYPE html><title></title><p>" with get, set

    /// The URL to read the HTML from.
    [<Parameter(ParameterSetName="Uri",Position=1,Mandatory=true,ValueFromPipelineByPropertyName=true)>]
    [<ValidateNotNullOrEmpty>]
    [<Alias("Url")>]
    member val Uri : Uri = null with get, set

    /// The URL to read the HTML from.
    [<Parameter(ParameterSetName="Path",Mandatory=true,ValueFromPipelineByPropertyName=true)>]
    [<ValidateNotNullOrEmpty>]
    [<Alias("FullName")>]
    member val Path : string = null with get, set

    // optional: setup before pipeline input starts (e.g. Name is set, InputObject is not)
    override x.BeginProcessing () =
        base.BeginProcessing ()

    // optional: handle each pipeline value (e.g. InputObject)
    override x.ProcessRecord () =
        base.ProcessRecord ()

    // optional: finish after all pipeline input
    override x.EndProcessing () =
        let htmldoc = new HtmlDocument()
        match x.ParameterSetName with
        | "Html" -> htmldoc.LoadHtml(x.Html)
        | "Uri" -> htmldoc.Load(string x.Uri)
        | "Path" -> htmldoc.Load(x.Path)
        | name -> sprintf "Unknown parameter set %s" name |> failwith
        htmldoc.DocumentNode.SelectNodes(x.XPath)
            |> Seq.map (fun n -> n.InnerText)
            |> x.WriteObject
        base.EndProcessing ()
