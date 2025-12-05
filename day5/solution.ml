let input = Array.to_list (Arg.read_arg "input.txt") in

let ranges, ids =
  List.filter (fun s -> String.trim s <> "") input
  |> List.partition (fun s -> String.contains s '-')
in

let merged_ranges =
  ranges
  |> List.filter_map (fun s ->
         match String.split_on_char '-' s with
         | f :: s :: _ -> Some (int_of_string f, int_of_string s)
         | _ -> None)
  |> List.sort (fun (lo1, _) (lo2, _) -> compare lo1 lo2)
  |> List.fold_left
       (fun acc (lo, hi) ->
         match acc with
         | [] -> [ (lo, hi) ]
         | (last_lo, last_hi) :: rest ->
             if lo <= last_hi then (last_lo, max last_hi hi) :: rest
             else (lo, hi) :: acc)
       []
in

(* Part one *)
ids |> List.map int_of_string
|> List.filter_map (fun id ->
       List.find_opt (fun r -> fst r <= id && snd r >= id) merged_ranges)
|> List.length |> string_of_int |> print_endline;

(* Part two *)
merged_ranges
|> List.fold_left (fun acc (lo, hi) -> acc + hi - lo + 1) 0
|> string_of_int |> print_endline
