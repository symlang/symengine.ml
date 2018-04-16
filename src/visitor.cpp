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

class ExprTableVisitor : public BaseVisitor<ExprTableVisitor, ExprVisitor>  {
protected:
  value cbs;
  int len;
public:
  enum class CB_CODE {
    BASIC = 0,
#define SYMENGINE_INCLUDE_ALL
#define SYMENGINE_ENUM(type, Class) type,
#include "symengine/type_codes.inc"
#undef SYMENGINE_ENUM
#undef SYMENGINE_INCLUDE_ALL
    Count,
  };
  ExprTableVisitor(value cbs) : BaseVisitor(Field(cbs, 0)), cbs(cbs), len(Wosize_val(cbs)) {
    caml_register_global_root(&this->cbs);
  }
  ~ExprTableVisitor() {
    caml_remove_global_root(&this->cbs);
  }
  inline value callback(value cb, const Basic *x) {
    CAMLparam1(cb);
    CAMLlocal3(curr, children, result);
    basic c;
    c->m = x->rcp_from_this();
    curr = caml_copy_nativeint((long)c);
    children = apply(x->get_args());
    result = caml_callback2(cb, curr, children);
    CAMLreturn(result);
  }
  inline value get_cb(CB_CODE code) {
    int i = static_cast<int>(code);
    if (i >= len) return cb;
    value r = Field(cbs, i);
    if (r == Val_unit) return cb;
    return r;
  }

  using ExprVisitor::bvisit;

#define SYMENGINE_ENUM(type, Class) \
  void bvisit(const Class &x) { \
    caml_modify_generational_global_root(&a, callback(get_cb(CB_CODE::type), &x)); \
  }
#include "symengine/type_codes.inc"
#undef SYMENGINE_ENUM
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

CAMLprim value basicsym_visit2(value root, value visitors) {
  CAMLparam2(root, visitors);
  CAMLlocal1(result);
  auto x = reinterpret_cast<CRCPBasic*>(Nativeint_val(root));
  ExprTableVisitor exprVisitor(visitors);
  result = exprVisitor.apply(x->m);
  CAMLreturn(result);
}
