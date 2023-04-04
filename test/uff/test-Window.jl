using USTB, USTB.UFF, Test

@testset "UFF Window" begin
    @test Window.None === Window.WindowEnum(0)
    @test Window.Boxcar === Window.Rectangular === Window.Flat
    @test Window.Tukey80 === Window.Sta
    @test Window.Boxcar !== Window.None
end