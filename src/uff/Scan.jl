import DocStringExtensions: TYPEDEF, TYPEDFIELDS
export Scan, AbstractScan

"""
$(TYPEDEF)

A Scan contains the positions of a collection of pixels.

**Fields**
===============
$(TYPEDFIELDS)


**Properties**
===============


Example:
```
sca = Scan();
x = range(-20e-3,20e-3,256);
z = range(  0e-3,40e-3,256);
X = ones(256)' .* x;
Z = z' .* ones(256);

sca.xyz = hcat(X[:], zeros(256^2), Z[:]);

```

#TODO: Link up LinearScan, SectorScan
"""
Base.@kwdef mutable struct Scan
    """X positions for each pixel"""
    x::Vector{Float64} = [0]
    """Y positions for each pixel"""
    y::Vector{Float64} = [0]
    """Z positions for each pixel"""
    z::Vector{Float64} = [0]
end

"""
$(TYPEDEF)

Abstract type used for Scan-composites like LinearScan.
"""
abstract type AbstractScan end

Base.propertynames(::Scan, private::Bool=false) = union([:xyz, :N_pixels], fieldnames(Scan))

function Base.getproperty(sca::Scan, s::Symbol)
    if s == :xyz
        reduce(hcat, [sca.x, sca.y, sca.z])
    elseif s == :N_pixels
        min(length(sca.x), length(sca.y), length(sca.z))
    else
        getfield(sca, s)
    end
end

function Base.setproperty!(sca::Scan, s::Symbol, value)
    if s == :xyz
        setfield!(sca, :x, convert(fieldtype(Scan, :x), value[:, 1]))
        setfield!(sca, :y, convert(fieldtype(Scan, :y), value[:, 2]))
        setfield!(sca, :z, convert(fieldtype(Scan, :z), value[:, 3]))
    else
        setfield!(sca, s, convert(fieldtype(Scan, s), value))
    end
end


