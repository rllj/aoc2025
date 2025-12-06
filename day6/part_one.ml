let rec transpose mat =
  match mat with
  | [] -> []
  | [] :: _ -> []
  | rows -> List.map List.hd rows :: transpose (List.map List.tl rows)
in

let input = Arg.read_arg "input.txt" |> Array.to_list in

input
|> List.map (String.split_on_char ' ')
|> List.map (List.map String.trim)
|> List.map (List.filter (fun s -> s <> String.empty))
|> List.rev |> transpose
|> List.map (function
  | [] -> failwith "empty list!"
  | h :: t -> (
      let numbers = List.map int_of_string t in
      match h with
      | "*" -> List.fold_left (fun e acc -> e * acc) 1 numbers
      | "+" -> List.fold_left (fun e acc -> e + acc) 0 numbers
      | _ -> failwith "Oh no!"))
|> List.fold_left (fun e acc -> e + acc) 0
|> Printf.printf "Part one: %d\n"
