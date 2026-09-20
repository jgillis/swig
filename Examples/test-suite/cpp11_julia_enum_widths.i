%module cpp11_julia_enum_widths
%include <std_pair.i>
#ifdef SWIGJULIA
%warnfilter(465) unsupported_pointer_pair;
#endif
%ignore Hidden;
%rename(Renamed) Original;
%inline %{
#include <limits>
enum Ordinary { First = -2, Hidden = 12, Next, Original = 0x20, Alias = Original, Expression = (1 << 8) };
enum : unsigned long long { AnonymousHigh = 18446744073709551615ULL };
enum class SignedShort : short { Low = -32768, High = 32767 };
enum class UnsignedInt : unsigned int { High = 4294967295U };
enum class SignedByte : signed char { Low = -128, High = 127 };
enum class UnsignedByte : unsigned char { Low = 0, High = 255 };
enum class SignedWide : long long { Low = (-9223372036854775807LL - 1), High = 9223372036854775807LL };
enum class UnsignedWide : unsigned long long { Low = 0, Middle = (1ULL << 63), High = 18446744073709551615ULL };
Ordinary ordinary(Ordinary value) { return value; }
SignedByte signed_byte(SignedByte value) { return value; }
UnsignedByte unsigned_byte(const UnsignedByte &value) { return value; }
SignedWide signed_wide(const SignedWide &value) { return value; }
UnsignedWide unsigned_wide(UnsignedWide value) { return value; }
const UnsignedWide &wide_reference() {
  static const UnsignedWide value = UnsignedWide::High;
  return value;
}
std::pair<unsigned long long, unsigned long long> unsigned_pair() {
  return std::make_pair(std::numeric_limits<unsigned long long>::max(), 1ULL << 63);
}
std::pair<unsigned int*, unsigned int*> unsupported_pointer_pair() {
  return std::make_pair(static_cast<unsigned int*>(0), static_cast<unsigned int*>(0));
}
std::pair<long long, long long> signed_pair() {
  return std::make_pair(std::numeric_limits<long long>::min(), std::numeric_limits<long long>::max());
}
std::pair<UnsignedWide, SignedByte> enum_pair() {
  return std::make_pair(UnsignedWide::High, SignedByte::Low);
}
struct EnumOwner {
  enum class Nested : unsigned short { High = 65535 };
  static Nested nested(Nested value) { return value; }
};
%}
