#include "visitor.h"

int main() {
  basic x, y;
  int t;
  basic_new_stack(x);
  basic_new_stack(y);
  symbol_set(x, "x");
  basic_cos(y, x);
  print_ast(y);
  basic_free_stack(x);
  basic_free_stack(y);
  return 0;
}