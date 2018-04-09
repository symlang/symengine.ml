#pragma once

#include <caml/memory.h>
#include <caml/alloc.h>

#ifdef __cplusplus
extern "C" {
#endif

CAMLprim value basicsym_add(value a, value b);

#ifdef __cplusplus
}
#endif
