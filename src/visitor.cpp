#include "symengine/visitor.h"
#include "visitor.h"
#include <caml/callback.h>

using namespace SymEngine;

struct CRCPBasic {
  SymEngine::RCP<const SymEngine::Basic> m;
};

template <typename C>
struct reverse_wrapper {
  C & c_;
  reverse_wrapper(C & c) :  c_(c) {}

  typename C::reverse_iterator begin() {return c_.rbegin();}
  typename C::reverse_iterator end() {return c_.rend(); }
};

class ExprVisitor : public BaseVisitor<ExprVisitor> {
protected:
  value a;
  value cb;

public:
  ExprVisitor(value cb) : a(Val_unit), cb(cb) {
    caml_register_generational_global_root(&this->a);
    caml_register_generational_global_root(&this->cb);
    // caml_garbage_collection();
  }
  ~ExprVisitor() {
    caml_remove_generational_global_root(&this->cb);
    caml_remove_generational_global_root(&this->a);
  }
  static const std::vector<std::string> names_;
  void bvisit(const Basic &x) {
    CAMLparam0();
    CAMLlocal2(curr, children);
    basic c;
    c->m = x.rcp_from_this();
    curr = caml_copy_nativeint((long)c);
    children = apply(x.get_args());
    caml_modify_generational_global_root(&a, caml_callback2(cb, curr, children));
    CAMLreturn0;
  }

  value apply(const RCP<const Basic> &b) {
    b->accept(*this);
    return a;
  }
  value apply(const vec_basic &v) {
    CAMLparam0();
    CAMLlocal1(result);
    result = caml_alloc(v.size(), 0);
    int i = 0;
    for (const auto& x : v) {
      Store_field(result, i++, this->apply(x));
    }
    CAMLreturn(result);
  }
  value apply(const Basic &b) {
    b.accept(*this);
    return a;
  }
};

static std::vector<std::string> init_str_printer_names()
{
  std::vector<std::string> names;
  names.assign(TypeID_Count, "");
#define SYMENGINE_INCLUDE_ALL
#define SYMENGINE_ENUM(type, Class) names[type] = #Class;
#include "symengine/type_codes.inc"
#undef SYMENGINE_ENUM
#undef SYMENGINE_INCLUDE_ALL
  return names;
}

const std::vector<std::string> ExprVisitor::names_ = init_str_printer_names();

CAMLprim value basicsym_visit(value root, value visitor) {
  CAMLparam2(root, visitor);
  CAMLlocal1(result);
  auto x = reinterpret_cast<CRCPBasic*>(Nativeint_val(root));
  ExprVisitor exprVisitor(visitor);
  result = exprVisitor.apply(x->m);
  CAMLreturn(result);
}
