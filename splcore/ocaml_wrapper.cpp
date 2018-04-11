#include <symengine/cwrapper.h>
#include "ocaml_wrapper.h"

inline basic_struct*& Val_basic(value &a) {
  return (basic_struct*&)Field(a, 1);
}

void final_basic(value a) {
  basic_free_heap(Val_basic(a));
}

CAMLprim value basicsym_zero() {
  CAMLparam0();
  CAMLlocal1(result);
  basic_struct *c = basic_new_heap();
  basic_const_zero(c);
  result = caml_alloc_final(1, final_basic, 0, 1);
  Val_basic(result) = c;
  CAMLreturn(result);
}

CAMLprim value basicsym_add(value a, value b) {
  CAMLparam2(a, b);
  CAMLlocal1(result);
  basic_struct *c = basic_new_heap();
  basic_add(c, Val_basic(a), Val_basic(b));
  result = caml_alloc_final(1, final_basic, 0, 1);
  Val_basic(result) = c;
  CAMLreturn(result);
}
