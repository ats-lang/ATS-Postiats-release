(* ****** ****** *)

#include "../share/utfpl_symintr.hats"

(* ****** ****** *)

fun isevn (n) = if n > 0 then isodd (n-1) else true
and isodd (n) = if n > 0 then isevn (n-1) else false

(* ****** ****** *)

val () = fprintln (stdout, "isevn(100) = ", isevn(100))
val () = fprintln (stdout, "isodd(100) = ", isodd(100))

(* ****** ****** *)

(* end of [test04.dats] *)
