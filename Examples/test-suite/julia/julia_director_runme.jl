using Test
include(joinpath(pwd(), "julia_director.jl"))
using .julia_director

struct Override end
julia_director.Callback_value(::Override, n) = n * 3
callback = Callback(Override())
GC.gc()
@test callback.call(7) == 21
@test callback.call_real(8.0) == 4.0
@test length(julia_director._swig_director_roots) == 1
finalize(callback)
@test isempty(julia_director._swig_director_roots)

struct Throwing end
julia_director.Callback_value(::Throwing, n) = error("callback failure")
callback = Callback(Throwing())
@test_throws julia_director.SwigError callback.call(1)
GC.gc()
@test callback.call_real(8.0) == 4.0
finalize(callback)
@test isempty(julia_director._swig_director_roots)

struct WrongType end
julia_director.Callback_value(::WrongType, n) = "invalid"
callback = Callback(WrongType())
for i in 1:10
    @test_throws julia_director.SwigError callback.call(1)
    GC.gc()
end
finalize(callback)
@test isempty(julia_director._swig_director_roots)
