let rec transpose mat =
  match mat with
  | [] -> []
  | [] :: _ -> []
  | rows -> List.map List.hd rows :: transpose (List.map List.tl rows)
in

Arg.read_arg "input.txt" |> Array.to_list
|> List.map (String.split_on_char ' ')
|> List.map
     (List.filter_map (fun s ->
          let trimmed = String.trim s in
          if trimmed <> "" then Some trimmed else None))
|> List.rev |> transpose
|> List.map (function
  | [] -> failwith "empty column!"
  | h :: t -> (
      let numbers = List.map int_of_string t in
      match h with
      | "*" -> List.fold_left (fun acc e -> e * acc) 1 numbers
      | "+" -> List.fold_left (fun acc e -> e + acc) 0 numbers
      | _ -> failwith "Oh no!"))
|> List.fold_left (fun e acc -> e + acc) 0
|> Printf.printf "Part one: %d\n"
