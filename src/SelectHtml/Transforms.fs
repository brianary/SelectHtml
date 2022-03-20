module SelectHtml.Transforms
open System
open System.Management.Automation
open System.Text.RegularExpressions
open HtmlAgilityPack

let private ToName (i:int) (value:string) =
    match Regex.Replace(value.Trim(), @"\W+", "") with
    | result when String.IsNullOrWhiteSpace(result) -> sprintf "_%d" i
    | result -> result

let private ToPSCustomObject (properties:string list) (values:string list) =
    let value = PSObject()
    List.zip (List.take (List.length values) properties) values
        |> List.iter (fun (p, v) -> value.Properties.Add(new PSNoteProperty(p, v)))
    value

let private Tr (n:HtmlNode) =
    n.SelectNodes("th|td")
        |> Seq.map (fun n -> n.InnerText)
        |> Seq.toList

let private HtmlList (n:HtmlNode) =
    n.Elements("li")
        |> Seq.map (fun n -> n.InnerText)
        |> Seq.toList

let private Table (n:HtmlNode) =
    let max = (n.SelectNodes("tr|*/tr")
                |> Seq.map Tr
                |> Seq.maxBy List.length
                |> List.length) - 1
    let head = n.SelectNodes("tr[1]|thead/tr")
    let properties = [for i in 0 .. max do
                        head |> Seq.map Tr |> Seq.map (List.tryItem i) |> Seq.map (Option.defaultValue "") |> Seq.reduce (+)]
                        |> List.mapi ToName
    n.SelectNodes("tr[position()>1]|tbody/tr")
        |> Seq.map Tr
        |> Seq.map (ToPSCustomObject properties)
        |> Seq.toList

let TransformNode (n:HtmlNode) =
    match n.Name with
    | "table" -> Table n
    | "ol" | "ul" | "menu" -> HtmlList n |> List.map PSObject
    | _ -> [PSObject n.InnerText]
