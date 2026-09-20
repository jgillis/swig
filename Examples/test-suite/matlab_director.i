%module(directors="1") matlab_director
%feature("director") Callback;
%apply int &OUTPUT { int &extra };
#ifdef SWIGMATLAB
%typemap(directorargout) int &extra { $1 = (int)mxGetScalar($result); }
#endif
%inline %{
struct Callback {
  virtual ~Callback() {}
  virtual int value(int x) { return x; }
  virtual int split(int x, int &extra) { extra = x + 1; return x; }
};
int invoke(Callback &callback, int value) {
  return callback.value(value);
}
int invoke_split(Callback &callback, int value) {
  int extra = 0;
  return callback.split(value, extra) + extra;
}
%}
