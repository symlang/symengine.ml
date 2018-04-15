open Symengine

module Expr = struct
  open BasicSym
  type t =
  | Const of string
  | Symbol of string
  | Func of string * t array

  module Type = struct
    type a = t
    let visit_basic t = function
    | [| |] -> Const (to_str t)
    | children -> Func ((get_class t), children)
  end
  module Visitor = Visitor(Type)

  let expr : BasicSym.t -> t = Visitor.visit
end

let dump_expr oc =
  let open Expr in
  let rec ident = function
  | 0 -> Format.fprintf oc
  | i -> let () = Format.fprintf oc "  " in ident (i-1)
  and d i = function
  | Const s -> ident i "<Const %s />@." s
  | Symbol s -> ident i "<Symbol %s />@." s
  | Func (s, children) -> begin
    ident i "<%s>@." s;
    Array.iter (d (i+1)) children;
    ident i "</%s>@." s
  end in
  d 0

let () =
  Symengine.ascii_art_str () |> Format.printf "%s@.";
  Symengine.BasicSym.(cos pi |> expand |> to_str) |> Format.printf "cos(pi) = %s@.";
  Symengine.BasicSym.(pow e (pi *: i) |> Expr.expr ) |> Format.printf "e^(pi*I) = %a@." dump_expr
