using USTB, USTB.UFF, Test

replstr(x, kv::Pair...) = sprint((io,x) -> show(IOContext(io, :limit => true, :displaysize => (24, 80), kv...), MIME("text/plain"), x), x)
showstr(x, kv::Pair...) = sprint((io,x) -> show(IOContext(io, :limit => true, :displaysize => (24, 80), kv...), x), x)

@testset "Point Type" verbose=true begin
    a = Point{Float64, Float64}(0.1,0.2,0.3)
    b = Point(0.1,0.2,0.3)
    @test isapprox(a.r, b.r) && isapprox(a.θ, b.θ) && isapprox(a.ϕ, b.ϕ)
    @test isapprox(a, b)
    
    # Test show
    @test showstr(a) == "Point(r=0.1, θ=0.2 rad, ϕ=0.3 rad)"
    @test showstr(b) == "Point(r=0.1, θ=0.2 rad, ϕ=0.3 rad)"

    @testset "Transformations" begin
        @test CartesianFromPoint()(a) ≈ [0.0190, 0.0296, 0.0936] atol=3
        @test PointFromCartesian()([0.1,0.2,0.3]) ≈ Point(0.3742,0.3218,0.5639) atol=4

        @test showstr(CartesianFromPoint()) == "CartesianFromPoint()"
        @test showstr(PointFromCartesian()) == "PointFromCartesian()"
    end
end