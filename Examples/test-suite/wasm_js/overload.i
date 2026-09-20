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
%}
