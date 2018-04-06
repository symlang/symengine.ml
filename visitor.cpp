#include "symengine/visitor.h"
#include "visitor.h"

using namespace SymEngine;

struct AST {
  std::string type;
  std::string name;
  std::vector<AST> content;
};

static std::ostream& ident(std::ostream& o, int ident_) {
  for (int i = 0; i < ident_; i++) {
    o << "  ";
  }
  return o;
}

std::ostream& operator<<(std::ostream& o, const AST& i) {
  thread_local static int ident_ = 0;
  ident(o, ident_) << "<" << i.type << " " << i.name << (i.content.empty() ? " />" : ">") << std::endl;
  if (i.content.empty()) return o;
  ident_++;
  for (const auto & x : i.content) {
    ident(o, ident_) << x;
  }
  ident_--;
  ident(o, ident_) << "</" << i.type << ">" << std::endl;
  return o;
}

class ExprVisitor : public BaseVisitor<ExprVisitor> {
protected:
  AST ast_;

public:
  static const std::vector<std::string> names_;
  void bvisit(const Basic &x) {
    ast_ = {.type=names_[x.get_type_code()], .name=x.__str__(), .content=apply(x.get_args())};
  }

  AST apply(const RCP<const Basic> &b) {
    b->accept(*this);
    return ast_;
  }
  std::vector<AST> apply(const vec_basic &v) {
    std::vector<AST> vec;
    for (const auto& i : v) {
      vec.push_back(this->apply(i));
    }
    return vec;
  }
  AST apply(const Basic &b) {
    b.accept(*this);
    return ast_;
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

struct CRCPBasic {
  SymEngine::RCP<const SymEngine::Basic> m;
};

void print_ast(basic x) {
  ExprVisitor astPrinter;
  auto ast = astPrinter.apply(x->m);
  std::cout << ast;
}
