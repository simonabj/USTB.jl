using USTB, Test

@testset "common.jl" begin
    @test isnothing(set!())
    @test isnothing(update!())
end