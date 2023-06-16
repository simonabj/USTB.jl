import Statistics: mean
import DocStringExtensions: TYPEDEF, TYPEDFIELDS

export LinearArray

"""
$(TYPEDEF)

Composite type to define a linear array probe geometry
LinearArray defines an array of regularly spaced elements
along a line. Optionally it can hold each element 
width and height, assuming the elements are rectangular. 

**Fields**
---
$(TYPEDFIELDS)

**Example**
---
```
prb = CurvilinearArray()
prb.N = 128;
prb.pitch = 500e-6;
prb.radius = 70e-3;
```

TODO: Link up Probe
"""
Base.@kwdef mutable struct LinearArray <: AbstractProbeArray
    "Wrapped probe type"
    probe::Probe = Probe()

    "Number of elements"
    N::Integer = 1
    "Distance between eleents in the azimuth direction [m]"
    pitch::Float64 = 0.0

    "Width of the elements in the azimuth direction [m]"
    element_width::Float64 = 0.0
    "Width of the elements in the elecation direction [m]"
    element_height::Float64 = 0.0
end

"Return the number of elements in the Probe"
Base.length(p::LinearArray) = size(p.probe.geometry, 1)

"Forwarded `Base.size` to `Probe.geometry`"
Base.size(p::LinearArray, args...; kwargs...) = size(p.probe.geometry, args...; kwargs...)

"Forwarded `Base.getindex` to `Probe.geometry`"
Base.getindex(p::LinearArray, args...; kwargs...) = getindex(p.probe.geometry, args...; kwargs...)

"Forwarded `Base.setindex!` to `Probe.geometry`"
Base.setindex!(p::LinearArray, args...; kwargs...) = setindex!(p.probe.geometry, args...; kwargs...)

function update!(p::LinearArray)
    setfield!(p, :element_width, getfield(p, :pitch))
    setfield!(p, :element_height, 10 * getfield(p, :pitch))

    # Compute element abscissa
    x0 = (1:p.N) .* p.pitch
    x0 = x0 .- mean(x0)

    getfield(p, :probe).geometry = [x0 zeros(p.N, 4) p.element_width * ones(p.N, 1) p.element_height * ones(p.N, 1)]
end

# Implement instance properties and delegate backwards
Base.propertynames(a::LinearArray) = union(
    propertynames(a.probe), fieldnames(LinearArray)
)

function Base.getproperty(p::LinearArray, s::Symbol)
    if s ∈ propertynames(getfield(p, :probe))
        getproperty(getfield(p, :probe), s)
    else
        getfield(p, s)
    end
end

function Base.setproperty!(p::LinearArray, s::Symbol, value)
    if s ∈ propertynames(getfield(p, :probe))
        setproperty!(getfield(p, :probe), s, value)
    else
        setfield!(p, s, value)
        update!(p)
    end
end
