let pattern = "aabcaabxaaz"

(* k < |text| *)
let prefix_match_length text k =
  let pattern = BatList.drop k text in
  let text_prefix = BatList.take (List.length pattern) text in
  let paired_chars = List.combine text_prefix pattern in
  let matched_prefix = BatList.take_while (fun (x, y) -> x = y) paired_chars in
  List.length matched_prefix

(* so imperative it hurts *)
let z_alg s =
  let s_list = BatString.to_list s in
  let s_length = List.length s_list in
  let zs = Array.create s_length 0 in
  let l = ref 0 in
  let r = ref 0 in
  for k = 1 to s_length - 1 do
    if k > !r then
      let z_k = prefix_match_length s_list k in
      if z_k > 0 then
        zs.(k) <- z_k;
        l := k;
        r := k + z_k - 1
    else
      (* alpha := S[l..r] *)
      (* beta  := S[k..r] *)
      let k' = k - !l in
      let z_k' = zs.(k') in
      let beta_length = (!r - k) + 1 in
      if z_k' <= beta_length then
        zs.(k) <- z_k'
      else
        let z_k = if k + beta_length < s_length then
                    let alpha_length = (!r - !l) + 1 in
                    let s_dropped_alpha = BatList.drop alpha_length s_list in
                    let new_ix = (k + beta_length) - alpha_length in
                    let post_beta_length = prefix_match_length s_dropped_alpha new_ix in
                    beta_length + post_beta_length
                  else
                    beta_length
                  in
        zs.(k) <- z_k
  done;
  zs

let () =
  let zs = z_alg pattern in
  Array.iteri (fun i z -> Printf.printf "z_%d: %d\n" i z) zs
