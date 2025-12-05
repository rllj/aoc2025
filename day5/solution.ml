let merge fst_range snd_range =
  if fst snd_range >= fst fst_range && fst snd_range <= snd fst_range then
    ((fst fst_range, max (snd fst_range) (snd snd_range)), None)
  else (fst_range, Some snd_range)
in

let rec merge_ranges = function
  | [] -> []
  | [ x ] -> [ x ]
  | f :: s :: t -> (
      match merge f s with
      | x, None -> merge_ranges (x :: t)
      | x, Some y -> x :: merge_ranges (y :: t))
in

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
  |> List.sort (fun lhs rhs -> fst lhs - fst rhs)
  |> merge_ranges
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
