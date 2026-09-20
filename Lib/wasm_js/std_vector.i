/* Minimal vector interface for explicit template instantiations. */

namespace std {
  template <typename T> class vector {
  public:
    typedef T value_type;
    typedef T const_reference;   /* by value -- skirts the 'const T&' */
                                 /* ctype gap (no typemap for reference */
                                 /* forms of typedef-resolved primitives) */

    vector();

    /* Use 'unsigned long' directly: 'size_t' isn't a SWIG-known typedef */
    /* (no <stddef.h> in our parse path), and 'vector<T>::size_type' is */
    /* a dependent name SWIG can't resolve.  Either route would box the */
    /* primitive as void* via the T_USER fallback.  On wasm32, 'unsigned */
    /* long' is 32-bit (i32 over the wasm ABI); JS receives Number. */
    unsigned long size() const;
    bool empty() const;
    void clear();
    /* push_back takes T by value rather than 'const T&': SWIG resolves */

    /* has no registered typemap.  By-value 'T' matches the value-form */

    void push_back(T x);
    T at(unsigned long i) const;
  };
}
