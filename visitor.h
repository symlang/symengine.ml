#pragma once

#include "symengine/cwrapper.h"

#ifdef __cplusplus
#define EXPORT extern "C"
#else
#define EXPORT
#endif

EXPORT void print_ast(basic x);
