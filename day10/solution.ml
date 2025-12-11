let input =
  Arg.read_arg "example.txt" |> Array.map (String.split_on_char ' ')
in
let initial_state =
  Array.map
    (fun line ->
      let initial = List.hd line in
      List.init (String.length initial) (fun i -> String.get initial i)
      |> List.filter_map (fun c ->
          match c with '.' -> Some 0 | '#' -> Some 1 | _ -> None))
    input
in
let buttons =
  Array.map
    (fun line ->
      List.drop 1 line
      |> List.filter_map (fun str ->
          if String.contains str '{' then None
          else
            Some
              (List.init (String.length str) (fun i -> String.get str i)
              |> List.filter_map (fun c ->
                  match c with
                  | '0' .. '9' -> Some (int_of_char c - int_of_char '0')
                  | _ -> None))))
    input
in

let rec solve initial buttons depth = 
    let pressed = List.map (fun button -> List.map2 () initial button) buttons

Array.iter
  (fun a ->
    List.iter (fun c -> print_int c) a;
    print_endline "")
  initial_state;

Array.iter
  (fun a ->
    List.iter
      (fun b ->
        List.iter (fun c -> Printf.printf "%d " c) b;
        print_endline "")
      a)
  buttons
