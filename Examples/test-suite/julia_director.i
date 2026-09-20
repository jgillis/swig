%module(directors="1") julia_director
%feature("director") Callback;
%inline %{
#include <stdexcept>
class Callback {
public:
  Callback() {}
  virtual ~Callback() {}
  virtual int value(int n) { return n + 1; }
  virtual double real(double n) { return n / 2; }
  int call(int n) { return value(n); }
  double call_real(double n) { return real(n); }
};
%}
