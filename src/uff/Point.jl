import CoordinateTransformations: Transformation
import StaticArrays: SVector

export Point
export PointFromCartesian, CartesianFromPoint

"""
    Point(r, θ, ϕ)

Point contains the position of a point in a tridimensional space. It
express that location in spherical coordinates which allows to place 
points at infinity but in a given direction.

The Julia implementation of the UFF Point type is a derivation of the
CoordinateTransformations.jl `Spherical` type. The UFF Point defines
the azimuth θ as the angle from the point location to the YZ plane.
The elevation ϕ is the angle from the point location to the XZ plane.
"""
struct Point{T,A}
    r::T
    θ::A
    ϕ::A

    Point{T,A}(r, θ, ϕ) where {T,A} = new(r, θ, ϕ)
end

function Point(r, θ, ϕ)
    r2, θ2, ϕ2 = promote(r, θ, ϕ)
    return Point{typeof(r2),typeof(θ2)}(r2, θ2, ϕ2)
end

"""
    Point(x::AbstractVector)

Construct a `Point` from 3D Cartesian coordinates.
"""
Point(x::AbstractVector) = PointFromCartesian()(x)


Base.show(io::IO, x::Point) = print(io, "Point(r=$(x.r), θ=$(x.θ) rad, ϕ=$(x.ϕ) rad)")
Base.isapprox(p1::Point, p2::Point; kwargs...) = isapprox(p1.r, p2.r; kwargs...) && isapprox(p1.θ, p2.θ; kwargs...) && isapprox(p1.ϕ, p2.ϕ; kwargs...)

struct PointFromCartesian <: Transformation end
struct CartesianFromPoint <: Transformation end

Base.show(io::IO, trans::PointFromCartesian) = print(io, "PointFromCartesian()")
Base.show(io::IO, trans::CartesianFromPoint) = print(io, "CartesianFromPoint()")

"""
    (::PointFromCartesian)(x::AbstractVector)

Transformation functor to map 3D Cartesian coordinates into UFFs
`Point` type. The conversion for ``[x, y, z]`` is given by

```math
\\begin{aligned}
    r       &= \\sqrt{x^2+y^2+z^2}  \\\\
    \\theta &= \\text{atan}(x, z)           \\\\
    \\phi   &= \\text{asin}(y, r)
\\end{aligned}
```
"""
function (::PointFromCartesian)(x::AbstractVector)
    length(x) == 3 || error("Spherical transform takes a 3D coordinate")

    d = hypot(x[1], x[2], x[3])
    Point(d, atan(x[1], x[3]), asin(x[2] / d))
end

"""
    (::CartesianFromPoint)(x::Point)

Transformation functor to map UFF `Point` into Cartesian
coordinates. The conversion for ``[r, \\theta, \\phi]`` is given by

```math
\\begin{aligned}
    x &= r\\cdot\\sin(\\theta)\\cdot\\cos(\\phi) \\\\
    y &= r\\cdot\\sin(\\phi)                     \\\\
    z &= r\\cdot\\cos(\\theta)\\cdot\\cos(\\phi) 
\\end{aligned}
```
"""
function (::CartesianFromPoint)(x::Point)
    sθ, cθ = sincos(x.θ)
    sϕ, cϕ = sincos(x.ϕ)
    SVector(x.r * sθ * cϕ, x.r * sϕ, x.r * cθ * cϕ)
end

