let () =
  Symengine.ascii_art_str () |> Format.printf "%s@.";
  Symengine.BasicSym.(pow e (mul pi i) |> to_str) |> Format.printf "e^(pi*I) = %s@."
