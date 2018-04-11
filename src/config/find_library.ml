open Base
open Stdio

let write_sexp file sexp =
  Out_channel.write_all file ~data:(Sexp.to_string sexp)

let config c =
  (* let all_load = match Configurator.ocaml_config_var c "system" with
    | Some "macosx" -> "-all_load" 
    | _ -> "--whole-archive" in *)
  let src = "../../symengine" in
  let prefix = "../../build/symengine" in
  let cflags = ["-I../"^prefix; "-I../"^src;]
  and libs = ["-L"^prefix^"/symengine"; "-lsymengine"; "-lgmp"; "-lc++"] in
  write_sexp "c_flags.sexp" (sexp_of_list sexp_of_string cflags);
  write_sexp "c_library_flags.sexp" (sexp_of_list sexp_of_string libs)

let () =
  Configurator.main ~name:"symengine" config
