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

  let type_t = int

  module FFI = struct
    type const = t -> unit
    type unary_op = t -> t -> int
    type binary_op = t -> t -> t -> int
    type unary_relation = t -> bool
    type binary_relation = t -> t -> bool
    let basic_new_heap = foreign "basic_new_heap" (void @-> returning t)
    let basic_free_heap = foreign "basic_free_heap" (t @-> returning void)
    let basic_str = foreign "basic_str" (t @-> returning (ptr char))

    let basic_const_set = foreign "basic_const_set" (t @-> string @-> returning void)

    let basic_const_zero = foreign "basic_const_zero" (t @-> returning void)
    let basic_const_one = foreign "basic_const_one" (t @-> returning void)
    let basic_const_minus_one = foreign "basic_const_minus_one" (t @-> returning void)
    let basic_const_I = foreign "basic_const_I" (t @-> returning void)
    let basic_const_pi = foreign "basic_const_pi" (t @-> returning void)
    let basic_const_E = foreign "basic_const_E" (t @-> returning void)
    let basic_const_EulerGamma = foreign "basic_const_EulerGamma" (t @-> returning void)
    let basic_const_Catalan = foreign "basic_const_Catalan" (t @-> returning void)
    let basic_const_GoldenRatio = foreign "basic_const_GoldenRatio" (t @-> returning void)
    let basic_const_infinity = foreign "basic_const_infinity" (t @-> returning void)
    let basic_const_neginfinity = foreign "basic_const_neginfinity" (t @-> returning void)
    let basic_const_complex_infinity = foreign "basic_const_complex_infinity" (t @-> returning void)
    let basic_const_nan = foreign "basic_const_nan" (t @-> returning void)

    (* unused *)
    let basic_assign = foreign "basic_assign" (t @-> t @-> returning error_code_t)
    let basic_parse = foreign "basic_parse" (t @-> string @-> returning error_code_t)
    let basic_parse2 = foreign "basic_parse2" (t @-> string @-> bool @-> returning error_code_t)

    let basic_get_type = foreign "basic_get_type" (t @-> returning type_t)
    let basic_get_class_id = foreign "basic_get_class_id" (string @-> returning type_t)
    let basic_get_class_from_id = foreign "basic_get_class_from_id" (type_t @-> returning (ptr char))

    let symbol_set = foreign "symbol_set" (t @-> string @-> returning error_code_t)

    let basic_neg = foreign "basic_neg" (t @-> t @-> returning error_code_t)
    let basic_abs = foreign "basic_abs" (t @-> t @-> returning error_code_t)

    let basic_add = foreign "basic_add" (t @-> t @-> t @-> returning error_code_t)
    let basic_sub = foreign "basic_sub" (t @-> t @-> t @-> returning error_code_t)
    let basic_mul = foreign "basic_mul" (t @-> t @-> t @-> returning error_code_t)
    let basic_div = foreign "basic_div" (t @-> t @-> t @-> returning error_code_t)
    let basic_pow = foreign "basic_pow" (t @-> t @-> t @-> returning error_code_t)
    let basic_diff = foreign "basic_diff" (t @-> t @-> t @-> returning error_code_t)

    let basic_erf = foreign "basic_erf" (t @-> t @-> returning error_code_t)
    let basic_erfc = foreign "basic_erfc" (t @-> t @-> returning error_code_t)

    let basic_sin = foreign "basic_sin" (t @-> t @-> returning error_code_t)
    let basic_cos = foreign "basic_cos" (t @-> t @-> returning error_code_t)
    let basic_tan = foreign "basic_tan" (t @-> t @-> returning error_code_t)
    let basic_asin = foreign "basic_asin" (t @-> t @-> returning error_code_t)
    let basic_acos = foreign "basic_acos" (t @-> t @-> returning error_code_t)
    let basic_atan = foreign "basic_atan" (t @-> t @-> returning error_code_t)
    let basic_csc = foreign "basic_csc" (t @-> t @-> returning error_code_t)
    let basic_sec = foreign "basic_sec" (t @-> t @-> returning error_code_t)
    let basic_cot = foreign "basic_cot" (t @-> t @-> returning error_code_t)
    let basic_acsc = foreign "basic_acsc" (t @-> t @-> returning error_code_t)
    let basic_asec = foreign "basic_asec" (t @-> t @-> returning error_code_t)
    let basic_acot = foreign "basic_acot" (t @-> t @-> returning error_code_t)
    let basic_sinh = foreign "basic_sinh" (t @-> t @-> returning error_code_t)
    let basic_cosh = foreign "basic_cosh" (t @-> t @-> returning error_code_t)
    let basic_tanh = foreign "basic_tanh" (t @-> t @-> returning error_code_t)
    let basic_asinh = foreign "basic_asinh" (t @-> t @-> returning error_code_t)
    let basic_acosh = foreign "basic_acosh" (t @-> t @-> returning error_code_t)
    let basic_atanh = foreign "basic_atanh" (t @-> t @-> returning error_code_t)
    let basic_csch = foreign "basic_csch" (t @-> t @-> returning error_code_t)
    let basic_sech = foreign "basic_sech" (t @-> t @-> returning error_code_t)
    let basic_coth = foreign "basic_coth" (t @-> t @-> returning error_code_t)
    let basic_acsch = foreign "basic_acsch" (t @-> t @-> returning error_code_t)
    let basic_asech = foreign "basic_asech" (t @-> t @-> returning error_code_t)
    let basic_acoth = foreign "basic_acoth" (t @-> t @-> returning error_code_t)

    let basic_lambertw = foreign "basic_lambertw" (t @-> t @-> returning error_code_t)
    let basic_zeta = foreign "basic_zeta" (t @-> t @-> returning error_code_t)
    let basic_dirichlet_eta = foreign "basic_dirichlet_eta" (t @-> t @-> returning error_code_t)
    let basic_gamma = foreign "basic_gamma" (t @-> t @-> returning error_code_t)
    let basic_sqrt = foreign "basic_sqrt" (t @-> t @-> returning error_code_t)
    let basic_cbrt = foreign "basic_cbrt" (t @-> t @-> returning error_code_t)
    let basic_exp = foreign "basic_exp" (t @-> t @-> returning error_code_t)
    let basic_log = foreign "basic_log" (t @-> t @-> returning error_code_t)
    let basic_expand = foreign "basic_expand" (t @-> t @-> returning error_code_t)

    let integer_set_si = foreign "integer_set_si" (t @-> int @-> returning error_code_t)
    let integer_set_ui = foreign "integer_set_si" (t @-> uint @-> returning error_code_t)
    let integer_set_str = foreign "integer_set_str" (t @-> string @-> returning error_code_t)
    let real_double_set_d = foreign "real_double_set_d" (t @-> double @-> returning error_code_t)
    let rational_set_si = foreign "rational_set_si" (t @-> int @-> int @-> returning error_code_t)
    let rational_set_ui = foreign "rational_set_ui" (t @-> uint @-> uint @-> returning error_code_t)
    let rational_set = foreign "rational_set" (t @-> t @-> t @-> returning error_code_t)
    let complex_set = foreign "complex_set" (t @-> t @-> t @-> returning error_code_t)
    let complex_base_real_part = foreign "complex_base_real_part" (t @-> t @-> returning error_code_t)
    let complex_base_imaginary_part = foreign "complex_base_imaginary_part" (t @-> t @-> returning error_code_t)

    (* unused *)
    let real_double_get_d = foreign "real_double_get_d" (t @-> returning double)
    let integer_get_si = foreign "integer_get_si" (t @-> returning int)
    let integer_get_ui = foreign "integer_get_si" (t @-> returning uint)

    let number_is_zero = foreign "number_is_zero" (t @-> returning bool)
    let number_is_negative = foreign "number_is_negative" (t @-> returning bool)
    let number_is_positive = foreign "number_is_positive" (t @-> returning bool)
    let number_is_complex = foreign "number_is_complex" (t @-> returning bool)

    let is_a_Number = foreign "is_a_Number" (t @-> returning bool)
    let is_a_Integer = foreign "is_a_Integer" (t @-> returning bool)
    let is_a_Rational = foreign "is_a_Rational" (t @-> returning bool)
    let is_a_Symbol = foreign "is_a_Symbol" (t @-> returning bool)
    let is_a_Complex = foreign "is_a_Complex" (t @-> returning bool)
    let is_a_RealDouble = foreign "is_a_RealDouble" (t @-> returning bool)
    let is_a_ComplexDouble = foreign "is_a_ComplexDouble" (t @-> returning bool)
    (* unused *)
    let is_a_RealMPFR = foreign "is_a_RealMPFR" (t @-> returning bool)
    let is_a_ComplexMPC = foreign "is_a_ComplexMPC" (t @-> returning bool)

    let basic_eq = foreign "basic_eq" (t @-> t @-> returning bool)
    let basic_neq = foreign "basic_neq" (t @-> t @-> returning bool)

    module Extended = struct
      (* let visit a = foreign "visit" (t @-> funptr (t @-> returning a) @-> returning a) *)
      type ptr = nativeint
      let to_raw = Ctypes.raw_address_of_ptr
      let from_raw = Ctypes.ptr_of_raw_address
      let fix_raw f = let f t = f (from_raw t) in f
      external visit : ptr -> (ptr -> 'a array -> 'a) -> 'a = "basicsym_visit"
    end
  end
  let create () : t =
    let x = FFI.basic_new_heap () in
    Gc.finalise FFI.basic_free_heap x;
    x
  let unwrap_error i = match error_code_of_int i with
    | NoException -> ()
    | x -> raise (Error (x, ""))
  let general_fn1 f x = let z = create () in f z x |> unwrap_error; z
  let general_fn2 f x y = let z = create () in f z x y |> unwrap_error; z
  let mk_const (f: FFI.const) = let z = create () in f z; z
  let unary_fn (f: FFI.unary_op) x = let z = create () in f z x |> unwrap_error; z
  let binary_fn (f: FFI.binary_op) x y = let z = create () in f z x y |> unwrap_error; z
  let unary_relation (f: FFI.unary_relation) x = let z = f x in z
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
  let catalan = mk_const FFI.basic_const_Catalan
  let golden_ratio = mk_const FFI.basic_const_GoldenRatio
  let inf = mk_const FFI.basic_const_infinity
  let minus_inf = mk_const FFI.basic_const_neginfinity
  let complex_inf = mk_const FFI.basic_const_complex_infinity
  let nan = mk_const FFI.basic_const_nan
  let const_of_str s = let z = create () in FFI.basic_const_set z s; z

  let neg = unary_op FFI.basic_neg
  let abs = unary_op FFI.basic_abs

  let add = binary_op FFI.basic_add
  let sub = binary_op FFI.basic_sub
  let mul = binary_op FFI.basic_mul
  let div = binary_op FFI.basic_div
  let pow = binary_op FFI.basic_pow
  let diff = binary_op FFI.basic_diff

  let ( +: ) = add
  let ( -: ) = sub
  let ( *: ) = mul
  let ( /: ) = div

  let erf = unary_fn FFI.basic_erf
  let erfc = unary_fn FFI.basic_erfc
  let sin = unary_fn FFI.basic_sin
  let cos = unary_fn FFI.basic_cos
  let tan = unary_fn FFI.basic_tan
  let asin = unary_fn FFI.basic_asin
  let acos = unary_fn FFI.basic_acos
  let atan = unary_fn FFI.basic_atan
  let csc = unary_fn FFI.basic_csc
  let sec = unary_fn FFI.basic_sec
  let cot = unary_fn FFI.basic_cot
  let acsc = unary_fn FFI.basic_acsc
  let asec = unary_fn FFI.basic_asec
  let acot = unary_fn FFI.basic_acot
  let sinh = unary_fn FFI.basic_sinh
  let cosh = unary_fn FFI.basic_cosh
  let tanh = unary_fn FFI.basic_tanh
  let asinh = unary_fn FFI.basic_asinh
  let acosh = unary_fn FFI.basic_acosh
  let atanh = unary_fn FFI.basic_atanh
  let csch = unary_fn FFI.basic_csch
  let sech = unary_fn FFI.basic_sech
  let coth = unary_fn FFI.basic_coth
  let acsch = unary_fn FFI.basic_acsch
  let asech = unary_fn FFI.basic_asech
  let acoth = unary_fn FFI.basic_acoth

  let lambertw = unary_fn FFI.basic_lambertw
  let zeta = unary_fn FFI.basic_zeta
  let dirichlet_eta = unary_fn FFI.basic_dirichlet_eta
  let gamma = unary_fn FFI.basic_gamma
  let sqrt = unary_fn FFI.basic_sqrt
  let cbrt = unary_fn FFI.basic_cbrt
  let exp = unary_fn FFI.basic_exp
  let log = unary_fn FFI.basic_log
  let expand = unary_fn FFI.basic_expand

  let symbol_of_str = general_fn1 FFI.symbol_set
  let integer_of_int = general_fn1 FFI.integer_set_si
  let integer_of_uint = general_fn1 FFI.integer_set_ui
  let integer_of_str = general_fn1 FFI.integer_set_str
  let real_of_float = general_fn1 FFI.real_double_set_d
  let rational_of_int = general_fn2 FFI.rational_set_si
  let rational_of_uint = general_fn2 FFI.rational_set_ui
  let rational = binary_fn FFI.rational_set
  let complex = binary_fn FFI.complex_set
  let re = unary_fn FFI.complex_base_real_part
  let im = unary_fn FFI.complex_base_imaginary_part

  let is_zero = unary_relation FFI.number_is_zero
  let is_positive = unary_relation FFI.number_is_positive
  let is_negative = unary_relation FFI.number_is_negative
  let is_complex = unary_relation FFI.number_is_complex

  let is_number = unary_relation FFI.is_a_Number
  let is_integer = unary_relation FFI.is_a_Integer
  let is_retional = unary_relation FFI.is_a_Rational
  let is_complex = unary_relation FFI.is_a_Complex
  let is_real = unary_relation FFI.is_a_RealDouble
  let is_complex_double = unary_relation FFI.is_a_ComplexDouble

  let eq = binary_relation FFI.basic_eq
  let neq = binary_relation FFI.basic_neq

  let to_str (t: t) = FFI.basic_str t |> from_c_string
  let get_class (t: t) = FFI.basic_get_type t |> FFI.basic_get_class_from_id |> from_c_string

  module type VisitorType = sig
    type a
    val visit_basic : t -> a array -> a
  end

  module Visitor (T : VisitorType) = struct
    include T
    let visit root = FFI.Extended.(visit (to_raw root) (fix_raw visit_basic))
  end
end
