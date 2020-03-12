if VERSION < v"1.3.0-rc3.0"
    # tosimplex / libnormaliz segfaults when called from different thread, see
    # https://github.com/oscar-system/Polymake.jl/issues/144
    # this has been fixed in julia-1.3:
    # https://github.com/JuliaLang/julia/pull/33284
    ENV["OMP_NUM_THREADS"] = 1
end

using Oscar
using Test

include("Rings/integer-test.jl")
include("Rings/rational-test.jl")
include("Rings/mpoly-test.jl")
include("Polymake/nmbthy-test.jl")
