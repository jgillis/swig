%module unsupported_extend
class Value {};
%extend Value {
  int get() { return 1; }
}
