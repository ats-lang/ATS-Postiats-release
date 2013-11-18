(*
** Implementing UTFPL
** with substitution-based evaluation
*)

(* ****** ****** *)

#include
"share/atspre_staload.hats"

(* ****** ****** *)

staload "./../utfpl.sats"

(* ****** ****** *)

staload "./eval_subst.sats"

(* ****** ****** *)

extern
fun
d2varlst_contains (d2varlst, d2var): bool

implement
d2varlst_contains
  (d2vs, d2v0) = let
//
implement
list_exists$pred<d2var> (d2v) = d2v0 = d2v
//
in
  list_exists<d2var> (d2vs)
end // end of [d2varlst_contains]

(* ****** ****** *)

extern
fun
subst_d2varlst_find
  (subst, d2varlst, d2var): Option_vt (d2exp)
// end of [subst_d2varlst_find]

implement
subst_d2varlst_find
  (sub, d2vs, d2v0) = let
//
val isexi = d2varlst_contains (d2vs, d2v0)
//
in
  if isexi then None_vt(*void*) else subst_find (sub, d2v0)
end // end of [subst_d2varlst_find]

(* ****** ****** *)

implement
d2exp_subst
  (d2e0, sub) = let
//
fun aux
(
  d2e0: d2exp
, d2vs0: d2varlst, flag: &int >> _
) : d2exp = let
  val loc0 = d2e0.d2exp_loc
in
//
case+
d2e0.d2exp_node of
//
| D2Evar (d2v) => let
    val opt =
      subst_d2varlst_find (sub, d2vs0, d2v)
    // end of [val]
  in
    case+ opt of
    | ~None_vt () => d2e0
    | ~Some_vt (d2e) => (flag := flag + 1; d2e)
  end // end of [D2Evar]
| D2Ecst _ => d2e0
//
| D2Eint _ => d2e0
| D2Echar _ => d2e0
| D2Efloat _ => d2e0
| D2Estring _ => d2e0
//
| D2Elam
    (d2vs, d2e) => let
    val flag0 = flag
    val d2vs0 =
      list_reverse_append (d2vs, d2vs0)
    val d2e = aux (d2e, d2vs0, flag)
  in
    if flag > flag0 then d2exp_lam (loc0, d2vs, d2e) else d2e0
  end // end of [D2Elam]
//
| D2Eapp
    (d2e1, d2es2) => let
    val flag0 = flag
    val d2e1 = aux (d2e1, d2vs0, flag)
    val d2es2 = auxlst (d2es2, d2vs0, flag)
  in
    if flag > flag0 then d2exp_app (loc0, d2e1, d2es2) else d2e0
  end // end of [D2Eapp]
| _ =>
  (
    let val () = assertloc (false) in exit (1) end
  ) // end of [_]
//
end // end of [aux]
//
and auxlst
(
  d2es0: d2explst, d2vs0: d2varlst, flag: &int >> _
) : d2explst = let
in
//
case+ d2es0 of
| list_cons
    (d2e, d2es) => let
    val flag0 = flag
    val d2e = aux (d2e, d2vs0, flag)
    val d2es = auxlst (d2es, d2vs0, flag)
  in
    if flag > flag0 then list_cons{d2exp}(d2e, d2es) else d2es0
  end // end of [list_cons]
| list_nil () => list_nil ()
//
end // end of [auxlst]
//
var flag: int = 0
//
in
  aux (d2e0, list_nil(*d2vs*), flag)
end // end of [d2exp_subst]

(* ****** ****** *)

local
//
typedef
d2varexp = @(d2var, d2exp)
//
assume subst_type = List0 (d2varexp)
//
in (* end of [local] *)

implement
subst_find (sub, d2v0) = let
//
fun loop
(
  xs: List0(d2varexp)
) : Option_vt (d2exp) =
  case+ xs of
  | list_cons (x, xs) =>
      if d2v0 = x.0 then Some_vt{d2exp}(x.1) else loop (xs)
  | list_nil ((*void*)) => None_vt ()
//
in
  loop (sub)
end // end of [subst_find]

end // end of [local]

(* ****** ****** *)

(* end of [eval_subst.dats] *)
