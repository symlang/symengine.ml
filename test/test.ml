let () =
  Symengine.ascii_art_str () |> Format.printf "%s@.";
  Symengine.BasicSym.(pow e (pi *: i) |> expand |> to_str) |> Format.printf "e^(pi*I) = %s@.";
  Symengine.BasicSym.(cos pi |> expand |> to_str) |> Format.printf "cos(pi) = %s@."
