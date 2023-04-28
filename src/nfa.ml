open List
open Sets

(*********)
(* Types *)
(*********)

type ('q, 's) transition = 'q * 's option * 'q

type ('q, 's) nfa_t = {
  sigma: 's list;
  qs: 'q list;
  q0: 'q;
  fs: 'q list;
  delta: ('q, 's) transition list;
}

(***********)
(* Utility *)
(***********)

let explode (s: string) : char list =
  let rec exp i l =
    if i < 0 then l else exp (i - 1) (s.[i] :: l)
  in
  exp (String.length s - 1) []

(****************)
(* Part 1: NFAs *)
(****************)

let contains lst element = exists (fun h -> h = element) lst

let move (nfa: ('q,'s) nfa_t) (qs: 'q list) (s: 's option) : 'q list =
  fold_left (fun ac elm -> if (contains ac elm) then ac else elm::ac) [] (
    fold_left (fun acc lst -> lst @ acc) [] (
      map (fun state -> fold_left (fun acum (a,b,c) -> if a = state && s = b then c::acum else acum) [] nfa.delta) qs))

let e_closure (nfa: ('q,'s) nfa_t) (qs: 'q list) : 'q list =
  let rec build lst =
    let updated = union (move nfa lst None) lst in
      if eq lst updated then lst else build updated
  in build qs

let accept (nfa: ('q,char) nfa_t) (s: string) : bool =
  let rec helper list1 s c = match s with
    |[] -> List.mem (c)(list1.fs)
    |head::tails-> (List.fold_left (fun a b -> if a = true then true else helper list1 tails b) false
            (e_closure list1(move list1 [c](Some head))))
  in
  List.fold_left (fun x y -> if x = true then true else helper nfa (explode s) y)false
  (e_closure nfa [nfa.q0])

(*******************************)
(* Part 2: Subset Construction *)
(*******************************)

let new_states (nfa: ('q,'s) nfa_t) (qs: 'q list) : 'q list list =
  List.fold_left (fun a s ->
    let state_set = [e_closure nfa (move nfa qs (Some s))] in
    union state_set a
  ) [] nfa.sigma

let new_trans (nfa: ('q,'s) nfa_t) (qs: 'q list) : ('q list, 's) transition list =
  List.map (fun symbol ->
    let moves = move nfa qs (Some symbol) in
    let closures = e_closure nfa moves in
    (qs, (Some symbol), closures)
  ) nfa.sigma

let new_finals (nfa: ('q,'s) nfa_t) (qs: 'q list) : 'q list list =
  let is_final = List.fold_left (fun a x -> a || List.mem x nfa.fs) false qs in
  if is_final then [qs] else []

let rec nfa_to_dfa_step (nfa: ('q,'s) nfa_t) (dfa: ('q list, 's) nfa_t) (work: 'q list list) : ('q list, 's) nfa_t =
  match work with
  | [] -> dfa
  | h::t ->
      if List.mem h dfa.qs then
        nfa_to_dfa_step nfa dfa t
      else
        let states = new_states nfa h in
        let finals = new_finals nfa h in
        let transitions = new_trans nfa h in
        let updated_dfa = {sigma = dfa.sigma; qs = dfa.qs@[h]; q0 = dfa.q0; fs = dfa.fs@finals; delta = dfa.delta @ transitions} in
        nfa_to_dfa_step nfa updated_dfa (t@states)

let nfa_to_dfa (nfa: ('q,'s) nfa_t) : ('q list, 's) nfa_t =
  let initial_state = e_closure nfa [nfa.q0] in
  let initial_work = [initial_state] in
  nfa_to_dfa_step nfa {sigma = nfa.sigma; qs = []; q0 = initial_state; fs = []; delta = []} initial_work
