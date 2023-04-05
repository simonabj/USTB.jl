using USTB
using Test

@testset "USTB.jl" verbose=true begin
    include("test-common.jl")
    include("test-UFF.jl")
end
