type position = { x : int; y : int; z : int }

let positions =
  Arg.read_arg "input.txt" |> Array.to_list
  |> List.map (fun line ->
      match String.split_on_char ',' line with
      | [ x; y; z ] ->
          { x = int_of_string x; y = int_of_string y; z = int_of_string z }
      | _ -> failwith "unexpected input")

let pos_count = List.length positions

let dst p1 p2 =
  let dx = p2.x - p1.x in
  let dy = p2.y - p1.y in
  let dz = p2.z - p1.z in
  (dx * dx) + (dy * dy) + (dz * dz)

let unique_pairs positions =
  let rec unique_pairs_i i = function
    | [] -> []
    | x :: xs ->
        let pairs = List.mapi (fun j y -> (i, j + i + 1, dst x y)) xs in
        pairs @ unique_pairs_i (i + 1) xs
  in
  unique_pairs_i 0 positions

let rec find parents idx =
  if idx = parents.(idx) then idx
  else (
    parents.(idx) <- find parents parents.(idx);
    parents.(idx))

let merge parents a b = parents.(find parents parents.(a)) <- find parents b

let sorted =
  List.sort
    (fun (_, _, dst_a) (_, _, dst_b) -> compare dst_a dst_b)
    (unique_pairs positions)

let parents = Array.init pos_count (fun i -> i)

let part_two =
  Array.of_list sorted
  |> Array.fold_left
       (fun (last_merged, i) (pos_a_i, pos_b_i, _) ->
         if i + 1 = 1000 then (
           let counts = Array.make pos_count 0 in
           Array.iteri
             (fun j _ ->
               let idx = find parents j in
               counts.(idx) <- counts.(idx) + 1)
             counts;
           Array.sort (fun x y -> compare y x) counts;
           Printf.printf "Part one: %d\n" (counts.(0) * counts.(1) * counts.(2)));

         if find parents pos_a_i <> find parents pos_b_i then (
           merge parents pos_a_i pos_b_i;
           ((pos_a_i, pos_b_i), i + 1))
         else (last_merged, i + 1))
       ((0, 0), 0)
  |> fun ((a, b), _) ->
  let pos_arr = Array.of_list positions in
  Printf.printf "Part two: %d * %d = %d\n" pos_arr.(a).x pos_arr.(b).x
    (pos_arr.(a).x * pos_arr.(b).x)
