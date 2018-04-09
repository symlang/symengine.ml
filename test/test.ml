let () =
  Symengine.ascii_art_str () |> Format.printf "%s@.";
  Symengine.BasicSym.(add zero zero |> to_str) |> Format.printf "0 + 0 = %s@."
