let dump_expr oc =
  let open Symengine.BasicSym in
  let rec ident = function
  | 0 -> Format.fprintf oc
  | i -> let () = Format.fprintf oc "  " in ident (i-1)
  and d i = function
  | Const s -> ident i "<const %s />@." s
  | Symbol s -> ident i "<symbol %s />@." s
  | Func (s, children) -> begin
    ident i "<%s>@." s;
    Array.iter (d (i+1)) children;
    ident i "</%s>@." s
  end in
  d 0

let () =
  Symengine.ascii_art_str () |> Format.printf "%s@.";
  Symengine.BasicSym.(cos pi |> expand |> to_str) |> Format.printf "cos(pi) = %s@.";
  Symengine.BasicSym.(pow e (pi *: i) |> expr ) |> Format.printf "e^(pi*I) = %a@." dump_expr
