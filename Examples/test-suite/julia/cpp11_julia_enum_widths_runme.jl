using Test
include(joinpath(pwd(), "cpp11_julia_enum_widths.jl"))
using .cpp11_julia_enum_widths
const m = cpp11_julia_enum_widths

@test Integer(Ordinary_Next) == 13
@test Integer(Ordinary_Renamed) == 32
@test Ordinary_Alias == Ordinary_Renamed
@test Integer(Ordinary_Expression) == 256
@test !isdefined(m, :Ordinary_Hidden)
@test First == -2
@test Next == 13
@test ordinary(Ordinary_First) == -2
@test AnonymousHigh === typemax(UInt64)
@test Base.Enums.basetype(SignedShort) === Int16
@test Base.Enums.basetype(UnsignedInt) === UInt32
@test Integer(SignedShort_Low) === typemin(Int16)
@test Integer(UnsignedInt_High) === typemax(UInt32)
@test Base.Enums.basetype(SignedByte) === Int8
@test Base.Enums.basetype(UnsignedByte) === UInt8
@test Base.Enums.basetype(SignedWide) === Int64
@test Base.Enums.basetype(UnsignedWide) === UInt64
@test signed_byte(SignedByte_Low) === typemin(Int8)
@test unsigned_byte(UnsignedByte_High) === typemax(UInt8)
@test signed_wide(SignedWide_Low) === typemin(Int64)
@test signed_wide(SignedWide_High) === typemax(Int64)
@test unsigned_wide(UnsignedWide_Middle) === UInt64(1) << 63
@test unsigned_wide(UnsignedWide_High) === typemax(UInt64)
@test unsigned_wide(big(typemax(UInt64))) === typemax(UInt64)
@test wide_reference() === typemax(UInt64)
@test !isdefined(m, :unsupported_pointer_pair)
@test unsigned_pair() === (typemax(UInt64), UInt64(1) << 63)
@test signed_pair() === (typemin(Int64), typemax(Int64))
@test enum_pair() === (typemax(UInt64), typemin(Int8))
@test Base.Enums.basetype(Nested) === UInt16
@test EnumOwner.nested(Nested_High) === typemax(UInt16)
for (f, invalid) in ((signed_byte, -129), (signed_byte, 128),
                     (unsigned_byte, -1), (unsigned_byte, 256),
                     (signed_wide, big(typemin(Int64)) - 1),
                     (signed_wide, big(typemax(Int64)) + 1),
                     (unsigned_wide, -1), (unsigned_wide, big(typemax(UInt64)) + 1))
  @test_throws m.SwigError f(invalid)
end
@test unsigned_byte(255) === UInt8(255)
