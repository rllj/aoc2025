let input = Arg.read_arg "input.txt" in
let connections : (string, string list) Hashtbl.t =
  Hashtbl.create (Array.length input)
in

let parsed_input =
  input
  |> Array.map (fun s ->
         s |> String.split_on_char ':' |> List.map String.trim
         |> List.map (String.split_on_char ' ')
         |> List.flatten)
in
let () =
  parsed_input
  |> Array.iter (fun list ->
         Hashtbl.add connections (List.hd list) (List.tl list))
in

let find_paths start goal =
  let rec find_paths_rec current goal =
    if current = goal then 1
    else
      Hashtbl.find connections current
      |> List.fold_left (fun acc n -> acc + find_paths_rec n goal) 0
  in
  find_paths_rec start goal
in

let find_paths_pt2 start goal =
  let memo = Hashtbl.create (Array.length input * 4) in
  let rec find_paths_rec current goal dac fft =
    let memoized = Hashtbl.find_opt memo (current, dac, fft) in
    match memoized with
    | Some paths -> paths
    | None ->
        if current = goal then if dac && fft then 1 else 0
        else
          let dac, fft =
            match current with
            | "dac" -> (true, fft)
            | "fft" -> (dac, true)
            | _ -> (dac, fft)
          in
          let paths =
            Hashtbl.find connections current
            |> List.fold_left
                 (fun acc n -> acc + find_paths_rec n goal dac fft)
                 0
          in
          Hashtbl.add memo (current, dac, fft) paths;
          paths
  in
  find_paths_rec start goal false false
in

(* Printf.printf "Part one: %d\n" (find_paths "you" "out") *)
Printf.printf "Part two: %d\n" (find_paths_pt2 "svr" "out")
