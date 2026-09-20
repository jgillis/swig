%module python_pyi_parameters
%feature("python:annotations", "typing");
%feature("python:stub:parameters");
%feature("compactdefaultargs");
%feature("compactdefaultargs", "0") plain;
%feature("compactdefaultargs", "0") combined_default;
%feature("python:stub:parameters", "0") broad;
%feature("kwargs") keywords;
%feature("kwargs") Widget::keyword;
%include <std_string.i>
%include <typemaps.i>
%apply int *OUTPUT { int *out };
%ignore default_number;
%typemap(in) (int argc, char **argv) {
  $1 = (int)PyList_Size($input);
  if ($1 < 0) SWIG_fail;
  $2 = 0;
}
%typemap(pytyping) (int argc, char **argv) "typing.List[str]"
%inline %{
int default_number() { return 7; }
int size1() { return 3; }
int compact(int value, int extra = default_number()) { return value + extra; }
std::string plain(std::string value = std::string("ready")) { return value; }
int keywords(int value, int extra = default_number()) { return value + extra; }
int broad() { return 3; }
int actual(int n) { return n; }
std::string actual(std::string s) { return s; }
int grouped(int argc, char **argv) { (void)argv; return argc; }
void output(int *out) { *out = 11; }
int combined(int value, int *out) { *out = value + 1; return value; }
int combined_default(int *out, int value = default_number()) { *out = value + 1; return value; }
class Widget {
public:
  Widget(int value = default_number()) : value(value) {}
  int size1() const { return value; }
  int keyword(int value = default_number()) const { return value; }
  static int make(int value = default_number()) { return value; }
  int value;
};
%}
