module FFI = struct
  (* let visit a = foreign "visit" (t @-> funptr (t @-> returning a) @-> returning a) *)
  type ptr = nativeint
  let to_raw = Ctypes.raw_address_of_ptr
  let from_raw = Ctypes.ptr_of_raw_address
  let fix_raw f = let f t = f (from_raw t) in f
  external visit : ptr -> (ptr -> 'a array -> 'a) -> 'a = "basicsym_visit"
  external visit2 : ptr -> (ptr -> 'a array -> 'a) array -> 'a = "basicsym_visit2"
end

module type VisitorType = sig
  type a
  val visit_basic : BasicSym.t -> a array -> a
end

module type VisitorTableType = sig
  type a
  val visit_basic : BasicSym.t -> a array -> a
  val visit_table : (Type_codes.class_name, BasicSym.t -> a array -> a) Hashtbl.t
end

module Visitor (T : VisitorType) = struct
  let visit root = FFI.(visit (to_raw root) (fix_raw T.visit_basic))
end

module Visitor2 (T : VisitorTableType) = struct
  let visit_table =
    let table = Array.make Type_codes.class_count (FFI.fix_raw T.visit_basic) in
    Hashtbl.iter (fun k v -> table.(Type_codes.id_of_class_name k) <- (FFI.fix_raw v)) T.visit_table;
    table
  let visit root = FFI.(visit2 (to_raw root) visit_table)
end
