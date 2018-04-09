open Ctypes
open Foreign

let strlen_ffi = foreign "strlen" (ptr char @-> returning size_t)
let basic_str_free_ffi = foreign "basic_str_free" ((ptr char) @-> returning void)
let ascii_art_str_ffi = foreign "ascii_art_str" (void @-> returning (ptr char))

let string_from_ptr str = string_from_ptr str ~length:(strlen_ffi str |> Unsigned.Size_t.to_int)

let from_c_string str =
  let s = string_from_ptr str in
  basic_str_free_ffi str;
  s

let ascii_art_str () = from_c_string (ascii_art_str_ffi ())

module BasicSym = struct
  type t = unit ptr
  let t = ptr void
  module FFI = struct
    type const = t -> unit
    type unary_op = t -> t -> unit
    type binary_op = t -> t -> t -> unit
    let basic_new_heap = foreign "basic_new_heap" (void @-> returning t)
    let basic_free_heap = foreign "basic_free_heap" (t @-> returning void)
    let basic_str = foreign "basic_str" (t @-> returning (ptr char))

    let basic_const_zero = foreign "basic_const_zero" (t @-> returning void)
    let basic_const_one = foreign "basic_const_one" (t @-> returning void)
    let basic_const_minus_one = foreign "basic_const_minus_one" (t @-> returning void)
    let basic_const_I = foreign "basic_const_I" (t @-> returning void)
    let basic_const_pi = foreign "basic_const_pi" (t @-> returning void)
    let basic_const_E = foreign "basic_const_E" (t @-> returning void)
    let basic_const_EulerGamma = foreign "basic_const_EulerGamma" (t @-> returning void)

    let basic_neg = foreign "basic_neg" (t @-> t @-> returning void)
    let basic_abs = foreign "basic_abs" (t @-> t @-> returning void)

    let basic_add = foreign "basic_add" (t @-> t @-> t @-> returning void)
    let basic_sub = foreign "basic_sub" (t @-> t @-> t @-> returning void)
    let basic_mul = foreign "basic_mul" (t @-> t @-> t @-> returning void)
    let basic_div = foreign "basic_div" (t @-> t @-> t @-> returning void)
    let basic_pow = foreign "basic_pow" (t @-> t @-> t @-> returning void)
  end
  let create () : t =
    let x = FFI.basic_new_heap () in
    Gc.finalise FFI.basic_free_heap x;
    x
  let mk_const (f : FFI.const) = let z = create () in f z; z
  let unary_op (f : FFI.unary_op) x = let z = create () in f z x; z
  let binary_op (f : FFI.binary_op) x y = let z = create () in f z x y; z

  let zero = mk_const FFI.basic_const_zero
  let one = mk_const FFI.basic_const_one
  let minus_one = mk_const FFI.basic_const_minus_one
  let i = mk_const FFI.basic_const_I
  let pi = mk_const FFI.basic_const_pi
  let e = mk_const FFI.basic_const_E
  let euler_gamma = mk_const FFI.basic_const_EulerGamma

  let neg = unary_op FFI.basic_neg
  let abs = unary_op FFI.basic_abs

  let add = binary_op FFI.basic_add
  let sub = binary_op FFI.basic_sub
  let mul = binary_op FFI.basic_mul
  let div = binary_op FFI.basic_div
  let pow = binary_op FFI.basic_pow

  let to_str t = FFI.basic_str t |> from_c_string
end
