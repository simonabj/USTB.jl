import CoordinateTransformations: Spherical, SphericalFromCartesian
import Unitful: m, rad
import StaticArrays: SVector

export Point, CartesianFromPoint, PointFromCartesian

struct Point
    distance::typeof(1.0*m)
    azimuth::typeof(1.0*rad)
    elevation::typeof(1.0*rad)
end

Point(r::Float64, θ::Float64, ϕ::Float64)  = Point(r*m, θ*rad, ϕ*rad)
Point(r::Number, θ::Number, ϕ::Number) = Point(convert(Float64, r), convert(Float64, θ), convert(Float64, ϕ))
Point(s::Spherical) = Point(s.r*m, s.θ*rad, s.ϕ*rad)

CartesianFromPoint() = 
    p -> SVector(
    p.distance * sin(p.azimuth) * cos(p.elevation),
    p.distance * sin(p.elevation),
    p.distance * cos(p.azimuth)*cos(p.elevation)
)

PointFromCartesian() = p -> Point((SphericalFromCartesian())(p))