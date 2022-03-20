module SelectHtml.Transforms
open System
open System.Text.RegularExpressions
open HtmlAgilityPack

let private ToName (i:int) (value:string) =
    match Regex.Replace(value.Trim(), @"\W+", "") with
    | result when String.IsNullOrWhiteSpace(result) -> sprintf "_%d" i
    | result -> result

let private Tr (n:HtmlNode) =
    n.SelectNodes("th|td")
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
    properties |> List.iter (sprintf "'%s'" >> System.Console.WriteLine)
    n.ChildNodes
        |> Seq.filter (fun n -> n.NodeType = HtmlNodeType.Element)
        |> Seq.map (fun n -> n.Name)

let TransformNode (n:HtmlNode) =
    match n.Name with
    // | "table" -> Table n
    | _ -> [n.InnerText]
