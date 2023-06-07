import Lazy: @switch
export Scan, AbstractScan

"""
    Scan
Scan contains the position of a collection of pixels. It is a
base container for more easy-to-handle classes such as LinearScan
and SectorScan.

Example:
```
sca = Scan();
sca.x = range(-20e-3,20e-3,256);
sca.z = range(  0e-3,40e-3,256);

```

#TODO: Link up LinearScan, SectorScan
"""
Base.@kwdef mutable struct Scan
    x::Vector{Float64} = [0]
    y::Vector{Float64} = [0]
    z::Vector{Float64} = [0]
end

abstract type AbstractScan end

Base.propertynames(::Scan, private::Bool=false) = union([:xyz, :N_pixels], fieldnames(Scan))

function Base.getproperty(sca::Scan, s::Symbol)
    @switch _ begin
        s == :xyz
        reduce(hcat, [sca.x, sca.y, sca.z])

        s == :N_pixels
        min(length(sca.x), length(sca.y), length(sca.z))

        getfield(sca, s)
    end
end

function Base.setproperty!(sca::Scan, s::Symbol, value) 
    @switch _ begin
        s == :xyz
        begin
            setfield!(sca, :x, value[:,1]);
            setfield!(sca, :y, value[:,2]);
            setfield!(sca, :z, value[:,3]);
        end

        setfield!(sca, s, value)
    end
end


