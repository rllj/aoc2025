type tile = Space | Beam | Splitter

let map =
  Arg.read_arg "input.txt"
  |> Array.map (fun s -> Array.init (String.length s) (fun i -> String.get s i))
  |> Array.map
       (Array.map (fun c ->
            match c with
            | '|' | 'S' -> Beam
            | '.' -> Space
            | '^' -> Splitter
            | _ -> failwith "invalid char"))

let start =
  match Array.find_index (( = ) Beam) map.(0) with
  | Some s -> s
  | None -> failwith "Didn't find beam start"

let height = Array.length map
let width = Array.length map.(0)

let traverse depth pos =
  let memo = Array.make (height * width) None in
  let split_count = ref 0 in
  let rec traverse_rec depth pos =
    if depth + 1 = height then 1
    else
      match map.(depth).(pos) with
      | Space | Beam -> traverse_rec (depth + 1) pos
      | Splitter -> (
          let cache_idx = (depth * width) + pos in
          match memo.(cache_idx) with
          | Some cnt -> cnt
          | None ->
              incr split_count;
              let res =
                traverse_rec (depth + 1) (pos - 1)
                + traverse_rec (depth + 1) (pos + 1)
              in
              memo.(cache_idx) <- Some res;
              res)
  in
  let count = traverse_rec depth pos in
  (!split_count, count)
;;

let part_one, part_two = traverse 0 start in
Printf.printf "Part one: %d\n" part_one;
Printf.printf "Part two: %d\n" part_two
