let () =
  Symengine.ascii_art_str () |> Format.printf "%s@.";
  Symengine.BasicSym.(pow e (mul pi i) |> expand |> to_str) |> Format.printf "e^(pi*I) = %s@.";
  Symengine.BasicSym.(cos pi |> expand |> to_str) |> Format.printf "cos(pi) = %s@."
