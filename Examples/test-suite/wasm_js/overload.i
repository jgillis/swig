%module overload
%inline %{
#include <string>
int choose(int n) { return n + 1; }
std::string choose(std::string s) { return s + "!"; }
int default_value(int n = 7) { return n; }
long default_long(long n = 8) { return n; }
long long default_wide(long long n = 9) { return n; }
class Base {
public:
  Base() {}
  virtual ~Base() {}
  int base() const { return 17; }
};
class Derived : public Base {
public:
  Derived(int n = 4) : value(n) {}
  int value;
};
int identify(Base *b) { return b->base(); }
int identify(int n) { return n; }
struct Left {
  Left(): left_value(17) {}
  int left_value;
  static int left_static() { return 19; }
};
struct GenCombined {
  GenCombined(): right_value(41) {}
  int right_value;
  int right() const { return right_value; }
};
struct Combined : Left, GenCombined {
};
int read_right(GenCombined *value) { return value->right_value; }
%}
