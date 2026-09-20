

/* SWIG_AsVal_frag / SWIG_From_frag macros (SWIG-level, used in %fragment names). */
/* fragments.swg depends on swigmacros.swg for %string_name / %symbol_name. */
%include <typemaps/swigmacros.swg>
%include <typemaps/fragments.swg>

/* SWIG runtime macros (status codes, ownership flag).  SWIG_ConvertPtr */
/* and SWIG_NewPointerObj live in wasm_jsrun.swg (with the proper */
/* EM_VAL signatures) -- do NOT redefine them here. */
%{
#ifndef SWIG_OK
#define SWIG_OK         (0)
#define SWIG_ERROR      (-1)
#define SWIG_TypeError  (-5)
#define SWIG_IsOK(r)    ((r) >= 0)
#endif

#ifndef SWIG_POINTER_OWN
#define SWIG_POINTER_OWN  0x1
#endif

#include <emscripten/val.h>
#include <type_traits>
%}

%define %wasm_js_primtype_asval(T)
%fragment(SWIG_AsVal_frag(T), "header") {
SWIGINTERN int SWIG_AsVal_dec(T)(void* p, T* val) {
  if (!p) return SWIG_ERROR;
  emscripten::val v = emscripten::val::take_ownership(
      reinterpret_cast< ::emscripten::EM_VAL >(p));
  std::string ty = v.typeOf().as<std::string>();
  bool ok = (ty == "number" || ty == "bigint");
  if (ok) {
    double d = (ty == "bigint")
      ? emscripten::val::global("Number")(v).as<double>()
      : v.as<double>();

    if (std::is_integral< T >::value &&
        d != static_cast<double>(static_cast<long long>(d))) {
      ok = false;
    } else if (val) {
      *val = static_cast< T >(d);
    }
  }
  v.release_ownership();
  return ok ? SWIG_OK : SWIG_ERROR;
}
}
%enddef

%define %wasm_js_primtype_from(T)
%fragment(SWIG_From_frag(T), "header") {
SWIGINTERNINLINE void* SWIG_From_dec(T)(T value) {
  T* p = (T*)std::malloc(sizeof(T));
  *p = value;
  return p;
}
}
%enddef

%define %wasm_js_primtype(T)
%wasm_js_primtype_asval(T)
%wasm_js_primtype_from(T)
%enddef

/* bool: special-cased.  JS 'true'/'false' map to bool; permissively
   also accept truthy numbers (so '0' / '1' from BigInt round-trip). */
%fragment(SWIG_AsVal_frag(bool), "header") {
SWIGINTERN int SWIG_AsVal_dec(bool)(void* p, bool* val) {
  if (!p) return SWIG_ERROR;
  emscripten::val v = emscripten::val::take_ownership(
      reinterpret_cast< ::emscripten::EM_VAL >(p));
  std::string ty = v.typeOf().as<std::string>();
  /* Strict: only a real JS boolean is a bool.  Numbers must NOT
     masquerade as bool, else GenericType dispatch picks OT_BOOL for
     numeric options (ipopt.max_iter -> true -> 1) and overload dispatch
     lets Slice(int,bool) shadow Slice(int,int). */
  bool ok = (ty == "boolean");
  if (ok && val) *val = v.as<bool>();
  v.release_ownership();
  return ok ? SWIG_OK : SWIG_ERROR;
}
}
%fragment(SWIG_From_frag(bool), "header") {
SWIGINTERNINLINE void* SWIG_From_dec(bool)(bool value) {
  int* p = (int*)std::malloc(sizeof(int));
  *p = value ? 1 : 0;
  return p;
}
}

%wasm_js_primtype(int)
%wasm_js_primtype(long)
%wasm_js_primtype(long long)
%wasm_js_primtype(double)
%wasm_js_primtype(float)
%wasm_js_primtype(unsigned int)
%wasm_js_primtype(unsigned long)
%wasm_js_primtype(unsigned long long)
