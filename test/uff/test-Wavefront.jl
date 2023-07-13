using USTB, USTB.UFF, Test

@testset "Wavefront" begin
    @test Wavefront.Plane !== Wavefront.Spherical !== Wavefront.Photoacustic
    @test Wavefront.Plane === Wavefront.WavefrontType(0)
end
