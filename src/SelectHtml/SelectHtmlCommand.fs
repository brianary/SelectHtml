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
    member val Html : string = null with get, set

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
        let doc = match x.ParameterSetName with
                  | "Html" ->
                      let h = HtmlDocument()
                      h.LoadHtml(x.Html)
                      h
                  | "Uri" ->
                      let w = HtmlWeb()
                      w.Load(string x.Uri)
                  | "Path" ->
                      let h = HtmlDocument()
                      h.Load(x.Path)
                      x.WriteDebug(sprintf "Loaded HTML (length %d)" h.DocumentNode.OuterHtml.Length)
                      h
                  | name -> sprintf "Unknown parameter set %s" name |> failwith
        x.WriteDebug(sprintf "Searching document for '%s'" x.XPath)
        match doc.DocumentNode.SelectNodes(x.XPath) with
        | null ->
            x.WriteDebug(sprintf "XPath '%s': No matches found" x.XPath)
        | matches ->
            x.WriteDebug(sprintf "XPath '%s': %d matches found" x.XPath matches.Count)
            matches
                |> Seq.map (fun n -> n.InnerText)
                |> x.WriteObject
        base.ProcessRecord ()

    // optional: finish after all pipeline input
    override x.EndProcessing () =
        base.EndProcessing ()
