let parse_inst str =
  let amount = int_of_string (String.sub str 1 (String.length str - 1)) in
  if str.[0] = 'R' then amount else -amount
in

let input = Arg.read_arg "input.txt" in
let result, _ =
  Array.fold_left
    (fun (result, acc) a ->
      let next = (acc + parse_inst a) mod 100 in
      if next = 0 then (result + 1, next) else (result, next))
    (0, 50) input
in
print_int result;
print_endline ""
