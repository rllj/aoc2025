let map =
  Arg.read_arg "input.txt"
  |> Array.map (fun s -> Array.init (String.length s) (fun i -> String.get s i))
in

let start =
  match Array.find_index (fun c -> c = 'S') (Array.get map 0) with
  | Some s -> s
  | None -> failwith "Didn't find beam start"
in

let height = Array.length map in
let width = Array.length (Array.get map 0) in
let traverse depth pos =
  let memo = Array.make (height * width) None in
  let rec traverse_rec depth pos =
    if depth + 1 = Array.length map then 1
    else
      match Array.get (Array.get map depth) pos with
      | '.' | 'S' -> traverse_rec (depth + 1) pos
      | '^' -> (
          let cache_idx = (depth * width) + pos in
          match memo.(cache_idx) with
          | Some cnt -> cnt
          | None ->
              let res =
                traverse_rec (depth + 1) (pos - 1)
                + traverse_rec (depth + 1) (pos + 1)
              in
              memo.(cache_idx) <- Some res;
              res)
      | char -> failwith (Printf.sprintf "%c" char)
  in
  traverse_rec depth pos
in

Printf.printf "Part two: %d\n" (traverse 0 start)
