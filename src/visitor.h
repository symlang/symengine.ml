#pragma once

#include "symengine/cwrapper.h"
#include <caml/memory.h>
#include <caml/alloc.h>

#ifdef __cplusplus
#define EXPORT extern "C"
#else
#define EXPORT
#endif

EXPORT CAMLprim value basicsym_visit(value root, value visitor);
