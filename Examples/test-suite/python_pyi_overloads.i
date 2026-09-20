%module python_pyi_overloads
%feature("python:annotations", "typing");
%feature("python:stub:overloads");
%feature("compactdefaultargs");
%feature("python:stub:overloads", "0") broad;
%feature("compactdefaultargs", "0") defaults;
%include <std_string.i>
%include <typemaps.i>
%apply int *OUTPUT { int *out };
%apply double *OUTPUT { double *out };
%ignore default_number;
%typemap(in) (int argc, char **argv) {
  $1 = (int)PyList_Size($input);
  if ($1 < 0) SWIG_fail;
  $2 = 0;
}
%typemap(typecheck, precedence=SWIG_TYPECHECK_STRING) (int argc, char **argv) {
  $1 = PyList_Check($input);
}
%typemap(pytyping) (int argc, char **argv) "typing.List[str]"

%inline %{
int default_number() { return 7; }
int multi(int argc, char **argv) { (void)argv; return argc; }
double multi(double n) { return n; }
int ranked(int n) { return n; }
int ranked(bool n) { return n ? 17 : 0; }
int choose(int n) { return n; }
std::string choose(std::string s) { return s; }
int broad(int n) { return n; }
std::string broad(std::string s) { return s; }
int defaults(int n, int extra = 3) { return n + extra; }
std::string defaults(std::string s) { return s; }
int compact(int n, int extra = default_number()) { return n + extra; }
std::string compact(std::string s) { return s; }
void produced(int n, int *out) { *out = n + 1; }
void produced(std::string s, double *out) { *out = s.size() + 0.5; }
int duplicate(int n) { return n; }
int duplicate(long n) { return (int)n; }
int conflicting(int n) { return n; }
std::string conflicting(long) { return "large"; }
class Choice {
public:
  Choice(int n, int extra = default_number()) : value(n + extra) {}
  Choice(std::string s) : value((int)s.size()) {}
  int pick(int n) { return n; }
  std::string pick(std::string s) { return s; }
  static int build(int n) { return n; }
  static std::string build(std::string s) { return s; }
  int value;
};
%}
