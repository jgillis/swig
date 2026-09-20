%module julia_numeric

#ifdef SWIGJULIA
%typemap(ctype) long long boxed "jl_value_t *"
%typemap(jltype) long long boxed "Any"
%typemap(jlparam) long long boxed "Any"
%typemap(in, fragment=SWIG_AsVal_frag(long long)) long long boxed %{
  if (!SWIG_IsOK(SWIG_AsVal_long_SS_long($input, &$1)))
    throw std::runtime_error("integer conversion failed");
%}

#endif

%inline %{
long long roundtrip(long long value) { return value; }
unsigned long long unsigned_roundtrip(unsigned long long value) { return value; }
long long boxed_roundtrip(long long boxed) { return boxed; }
int signed_byte(signed char value) { return value; }
unsigned int unsigned_byte(unsigned char value) { return value; }
bool bool_reference(const bool& value) { return value; }
long long integer_reference(const long long& value) { return value; }
%}
