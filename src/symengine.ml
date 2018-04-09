open Ctypes
open Foreign

let strlen_ffi = foreign "strlen" (ptr char @-> returning size_t)
let ascii_art_str_ffi = foreign "ascii_art_str" (void @-> returning (ptr char))
let basic_str_free_ffi = foreign "basic_str_free" ((ptr char) @-> returning void)

let string_from_ptr str = string_from_ptr str ~length:(strlen_ffi str |> Unsigned.Size_t.to_int)

let from_c_string str =
  let s = string_from_ptr str in
  basic_str_free_ffi str;
  s

let ascii_art_str () = from_c_string (ascii_art_str_ffi ())
