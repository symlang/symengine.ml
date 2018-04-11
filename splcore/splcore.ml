module BasicSym = struct
  type t
  external add: t -> t -> t = "basicsym_add"
  external zero: unit -> t = "basicsym_zero"
end