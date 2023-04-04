using USTB, Test, USTB.UFF
import ContentHashes: hash, SHA

# Include all UFF tests
# include("uff/...")

@testset "UFF Struct" begin
    # Make some dummy data
    a = Uff()
    b = Uff(name="Test name")
    
    # A new hash is the same as the hash of an empty UFF
    @test save_hash!(a) == hash(Uff())
    
    # When changed to have similar field as b, should have same hash
    a.name = "Test name"
    @test save_hash!(b) == save_hash!(a)

    # Now both hash checks should be true
    @test check_hash!(a) & check_hash!(b)
    
    # Change a field so hash does not match anymore
    a.reference = "Someone"
    @test ! check_hash!(a)

    # Save the new hash, and check if it validates again    
    save_hash!(a)
    @test check_hash!(a)
end

@testset "UFF Window" begin
    @test Window.None === Window.WindowEnum(0)
    @test Window.Boxcar === Window.Rectangular === Window.Flat
    @test Window.Tukey80 === Window.Sta
    @test Window.Boxcar !== Window.None
end

@testset "UFF Wavefront" begin
    @test Wavefront.Plane !== Wavefront.Spherical !== Wavefront.Photoacustic
    @test Wavefront.Plane === Wavefront.WavefrontEnum(0)
end