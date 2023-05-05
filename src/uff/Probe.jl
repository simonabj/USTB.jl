import LinearAlgebra: norm
import Lazy: @switch

export Probe

"""
    Probe

`Probe` contains the position and attitude of all elements of a
probe.  Optionally PROBE can hold each element width and height,
assuming the elements were rectangular. Information is stored in a 
single matrix form called geometry, one row per element containing:
[x y z azimuth elevation width height]
"""
Base.@kwdef mutable struct Probe
    origin::Point{Float64,Float64} = Point(0.0, 0.0, 0.0)
    geometry::Matrix{Float64} = Matrix{Float64}(undef, 0, 7)
end

"Return the number of elements in the Probe"
Base.length(p::Probe) = size(p.geometry, 1)

"Forwarded `Base.size` to `Probe.geometry`"
Base.size(p::USTB.UFF.Probe, args...; kwargs...) = Base.size(p.geometry, args...; kwargs...)

"Forwarded `Base.getindex` to `Probe.geometry`"
Base.getindex(p::USTB.UFF.Probe, args...; kwargs...) = Base.getindex(p.geometry, args...; kwargs...)

"Forwarded `Base.setindex!` to `Probe.geometry`"
Base.setindex!(p::USTB.UFF.Probe, args...; kwargs...) = Base.setindex!(p.geometry, args...; kwargs...)

const _probe_symbol_map = Dict(
    :x => 1,
    :y => 2,
    :z => 3,
    :θ => 4, :az => 4, :azimuth => 4,
    :ϕ => 5, :alt => 5, :elevation => 5,
    :w => 6, :width => 6,
    :h => 7, :height => 7,
)

"Implement the property interface for the same variables used by MATLAB"
Base.propertynames(::Probe, private::Bool=false) = union(collect(keys(_probe_symbol_map)), [:r], fieldnames(Probe))

"""
    Base.getproperty(p::Probe, s::Symbol)

Allow indexing by property, similar to MATLABs
dependent get methods, `getproperty` is extended to allow
getting the geometries columns by symbols for lookups.
Available symbols and [aliases] for lookup are given by
```
:x                    = p.geometry[:, 1]  # center of the element in the x axis[m]
:y                    = p.geometry[:, 2]  # center of the element in the y axis[m]
:z                    = p.geometry[:, 3]  # center of the element in the z axis[m]
:θ [:az, :azimuth]    = p.geometry[:, 4]  # orientation of the element in the azimuth direction [rad]
:ϕ [:alt, :elevation] = p.geometry[:, 5]  # orientation of the element in the elevation direction [rad]
:w [:width]           = p.geometry[:, 6]  # element width [m]
:h [:height]          = p.geometry[:, 7]  # element height [m]
:r [:distance]        = norm(p.geometry[:,1:3], dims=2) # Distance from elements to origin [m] 
```


"""
function Base.getproperty(p::Probe, s::Symbol)
    @switch _ begin
        s ∈ keys(_probe_symbol_map); p.geometry[:, _probe_symbol_map[s]] 
        s == :r || s == :distance; mapslices(norm, p.geometry[:, 1:3], dims=2)
        getfield(p, s)
    end
end

"Set property function"
function Base.setproperty!(p::Probe, s::Symbol, value) 
    @switch _ begin
        s ∈ keys(_probe_symbol_map); p.geometry[:, _probe_symbol_map[s]] = value
        setfield!(p, s, value)
    end
end