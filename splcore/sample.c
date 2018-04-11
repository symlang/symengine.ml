#include "visitor.h"

int main() {
  basic x, y, z;
  basic_new_stack(x);
  basic_new_stack(y);
  basic_new_stack(z);
  symbol_set(x, "x");
  basic_cos(y, x);
  basic_add(z, y, x);
  basic_add(z, z, y);
  print_ast(z);
  basic_free_stack(x);
  basic_free_stack(y);
  return 0;
}