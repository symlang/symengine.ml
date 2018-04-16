#include <fstream>

enum class CB_CODE {
  BASIC = 0,
#define SYMENGINE_INCLUDE_ALL
#define SYMENGINE_ENUM(type, Class) type,
#include "symengine/type_codes.inc"
#undef SYMENGINE_ENUM
#undef SYMENGINE_INCLUDE_ALL
  Count,
};

void generate_mli(const char* filename) {
  std::ofstream fout(filename);
  fout << "let class_count = " << static_cast<int>(CB_CODE::Count) << std::endl;
  fout << "type class_name = " << std::endl;
#define SYMENGINE_INCLUDE_ALL
#define SYMENGINE_ENUM(type, Class) fout << "  | " #Class "  (* " #type " *)" << std::endl;
#include "symengine/type_codes.inc"
#undef SYMENGINE_ENUM
#undef SYMENGINE_INCLUDE_ALL
  fout << "let id_of_class_name = function" << std::endl;
#define SYMENGINE_INCLUDE_ALL
#define SYMENGINE_ENUM(type, Class) fout << "  | " #Class " -> " << static_cast<int>(CB_CODE::type) << std::endl;
#include "symengine/type_codes.inc"
#undef SYMENGINE_ENUM
#undef SYMENGINE_INCLUDE_ALL
}

int main(int argc, char *argv[]) {
  if (argc < 2) {
    return 1;
  }
  generate_mli(argv[1]);
  return 0;
}