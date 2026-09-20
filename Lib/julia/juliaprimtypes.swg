/* juliaprimtypes.swg
 *
 * Primitive-type SWIG_AsVal / SWIG_From fragments for the -julia target,
 * operating on jl_value_t*.
 */

%include <typemaps/swigmacros.swg>
%include <typemaps/fragments.swg>

%{
#include <julia.h>
#include <cmath>
#include <limits>
#include <type_traits>

/* Keep integer sources integral: converting through double loses low bits. */
template <typename T> static int swig_jl_asval(jl_value_t *p, T *value) {
  if (!p) return SWIG_ERROR;
  if (jl_typeis(p, jl_int64_type)) {
    int64_t input = jl_unbox_int64(p);
    if (std::is_integral<T>::value) {
      if (std::is_signed<T>::value) {
        if (input < (int64_t)std::numeric_limits<T>::min() ||
            input > (int64_t)std::numeric_limits<T>::max()) return SWIG_ERROR;
      } else if (input < 0 || (uint64_t)input > (uint64_t)std::numeric_limits<T>::max()) {
        return SWIG_ERROR;
      }
    }
    if (value) *value = static_cast<T>(input);
    return SWIG_OK;
  }
  if (jl_typeis(p, jl_bool_type)) {
    if (value) *value = static_cast<T>(jl_unbox_bool(p));
    return SWIG_OK;
  }
  if (!jl_typeis(p, jl_float64_type)) return SWIG_ERROR;
  double input = jl_unbox_float64(p);
  if (std::is_integral<T>::value) {
    double bound = std::ldexp(1.0, std::numeric_limits<T>::digits);
    double lower = std::is_signed<T>::value ? -bound : 0.0;
    if (!std::isfinite(input) || std::trunc(input) != input || input < lower || input >= bound)
      return SWIG_ERROR;
  }
  if (value) *value = static_cast<T>(input);
  return SWIG_OK;
}
%}

%define %julia_primtype_asval(T)
%fragment(SWIG_AsVal_frag(T), "header") {
SWIGINTERN int SWIG_AsVal_dec(T)(jl_value_t *p, T *val) {
  return swig_jl_asval(p, val);
}
}
%enddef

%define %julia_primtype_from_body(T, BOX)
%fragment(SWIG_From_frag(T), "header") {
SWIGINTERNINLINE jl_value_t* SWIG_From_dec(T)(T value) {
  return BOX;
}
}
%enddef

%julia_primtype_asval(bool)
%julia_primtype_asval(int)
%julia_primtype_asval(long)
%julia_primtype_asval(long long)
%julia_primtype_asval(size_t)
%julia_primtype_asval(double)
%julia_primtype_asval(float)

%julia_primtype_from_body(bool, jl_box_bool(value ? 1 : 0))
%julia_primtype_from_body(int, jl_box_int64((int64_t)value))
%julia_primtype_from_body(long, jl_box_int64((int64_t)value))
%julia_primtype_from_body(long long, jl_box_int64((int64_t)value))
%julia_primtype_from_body(size_t, jl_box_int64((int64_t)value))
%julia_primtype_from_body(double, jl_box_float64(value))
%julia_primtype_from_body(float, jl_box_float64((double)value))
