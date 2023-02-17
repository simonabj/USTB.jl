import CoordinateTransformations: CartesianFromSpherical
import Lazy: @forward

export Point

Base.@kwdef struct Point
    # UFF metadata
    _header::Uff = Uff()
    
    distance::Float64  = 0.0
    azimuth::Float64   = 0.0
    elevation::Float64 = 0.0
end