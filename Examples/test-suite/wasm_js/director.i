%module(directors="1") director
%feature("director") Callback;
%newobject make_callback;
%inline %{
class Callback {
public:
  virtual ~Callback() {}
  virtual long long wide(long long n) { return n; }
  virtual int call(int n) { return n + 1; }
};
int invoke(Callback *callback, int n) { return callback->call(n); }
long long invoke_wide(Callback *callback, long long n) { return callback->wide(n); }
Callback *borrow(Callback *callback) { return callback; }
Callback *make_callback() { return new Callback(); }
%}
