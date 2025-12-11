let input =
  Arg.read_arg "example.txt" |> Array.map (String.split_on_char ' ')
in
let initial_state = Array.map (fun line -> List.hd line) input in
let buttons =
  Array.map
    (fun line ->
      List.drop 1 line
      |> List.map (fun str ->
             List.init (String.length str) (fun i -> String.get str i)
             |> List.filter_map (fun c ->
                    match c with
                    | '0' .. '9' -> Some (int_of_char c)
                    | _ -> None)))
    input
in
()
