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

  type error_code_t = 
    | NoException
    | RuntimeError
    | DivByZero
    | NotImplemented
    | DomainError
    | ParseError
    | UnknownError of int
  let error_code_t = int
  exception Error of error_code_t * string

  let error_code_of_int = function
    | 0 -> NoException
    | 1 -> RuntimeError
    | 2 -> DivByZero
    | 3 -> NotImplemented
    | 4 -> DomainError
    | 5 -> ParseError
    | id -> UnknownError id

  module FFI = struct
    type const = t -> unit
    type unary_op = t -> t -> int
    type binary_op = t -> t -> t -> int
    type binary_relation = t -> t -> bool
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

    let basic_neg = foreign "basic_neg" (t @-> t @-> returning error_code_t)
    let basic_abs = foreign "basic_abs" (t @-> t @-> returning error_code_t)

    let basic_add = foreign "basic_add" (t @-> t @-> t @-> returning error_code_t)
    let basic_sub = foreign "basic_sub" (t @-> t @-> t @-> returning error_code_t)
    let basic_mul = foreign "basic_mul" (t @-> t @-> t @-> returning error_code_t)
    let basic_div = foreign "basic_div" (t @-> t @-> t @-> returning error_code_t)
    let basic_pow = foreign "basic_pow" (t @-> t @-> t @-> returning error_code_t)

    let basic_sin = foreign "basic_sin" (t @-> t @-> returning error_code_t)
    let basic_cos = foreign "basic_cos" (t @-> t @-> returning error_code_t)
    let basic_tan = foreign "basic_tan" (t @-> t @-> returning error_code_t)
    let basic_asin = foreign "basic_asin" (t @-> t @-> returning error_code_t)
    let basic_acos = foreign "basic_acos" (t @-> t @-> returning error_code_t)
    let basic_atan = foreign "basic_atan" (t @-> t @-> returning error_code_t)
    let basic_sinh = foreign "basic_sinh" (t @-> t @-> returning error_code_t)
    let basic_cosh = foreign "basic_cosh" (t @-> t @-> returning error_code_t)
    let basic_tanh = foreign "basic_tanh" (t @-> t @-> returning error_code_t)
    let basic_asinh = foreign "basic_asinh" (t @-> t @-> returning error_code_t)
    let basic_acosh = foreign "basic_acosh" (t @-> t @-> returning error_code_t)
    let basic_atanh = foreign "basic_atanh" (t @-> t @-> returning error_code_t)

    let basic_exp = foreign "basic_exp" (t @-> t @-> returning error_code_t)
    let basic_log = foreign "basic_log" (t @-> t @-> returning error_code_t)

    let basic_expand = foreign "basic_expand" (t @-> t @-> returning error_code_t)
    let rational_set_si = foreign "rational_set_si" (t @-> int @-> int @-> returning error_code_t)
    let rational_set_ui = foreign "rational_set_ui" (t @-> uint @-> uint @-> returning error_code_t)
    let rational_set = foreign "rational_set" (t @-> t @-> t @-> returning error_code_t)
    let complex_set = foreign "complex_set" (t @-> t @-> t @-> returning error_code_t)

    let basic_eq = foreign "basic_eq" (t @-> t @-> returning bool)
    let basic_neq = foreign "basic_neq" (t @-> t @-> returning bool)
  end
  let create () : t =
    let x = FFI.basic_new_heap () in
    Gc.finalise FFI.basic_free_heap x;
    x
  let unwrap_error i = match error_code_of_int i with
    | NoException -> ()
    | x -> raise (Error (x, ""))
  let mk_const (f: FFI.const) = let z = create () in f z; z
  let unary_fn (f: FFI.unary_op) x = let z = create () in f z x |> unwrap_error; z
  let binary_fn (f: FFI.binary_op) x y = let z = create () in f z x y |> unwrap_error; z
  let binary_relation (f: FFI.binary_relation) x y = let z = f x y in z
  let unary_op = unary_fn
  let binary_op = binary_fn

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

  let sin = unary_fn FFI.basic_sin
  let cos = unary_fn FFI.basic_cos
  let tan = unary_fn FFI.basic_tan
  let asin = unary_fn FFI.basic_asin
  let acos = unary_fn FFI.basic_acos
  let atan = unary_fn FFI.basic_atan
  let sinh = unary_fn FFI.basic_sinh
  let cosh = unary_fn FFI.basic_cosh
  let tanh = unary_fn FFI.basic_tanh
  let asinh = unary_fn FFI.basic_asinh
  let acosh = unary_fn FFI.basic_acosh
  let atanh = unary_fn FFI.basic_atanh

  let exp = unary_fn FFI.basic_exp
  let log = unary_fn FFI.basic_log

  let expand = unary_fn FFI.basic_expand

  let rational_si x y = let z = create () in FFI.rational_set_si z x y |> unwrap_error; z
  let rational_ui x y = let z = create () in FFI.rational_set_ui z x y |> unwrap_error; z
  let rational = binary_fn FFI.rational_set
  let complex = binary_fn FFI.complex_set

  let eq = binary_relation FFI.basic_eq
  let neq = binary_relation FFI.basic_neq

  let to_str (t: t) = FFI.basic_str t |> from_c_string
end
