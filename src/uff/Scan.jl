import Lazy: @switch

export Scan

Base.@kwdef mutable struct Scan
    x::Vector{Float64} = []
    y::Vector{Float64} = []
    z::Vector{Float64} = []
end

Base.propertynames(::Scan, private::Bool=false) = union([:xyz, :N_pixels], fieldnames(Scan))

function Base.getproperty(sca::Scan, s::Symbol)
    @switch _ begin
        s == :xyz; hcat(sca.x, sca.y, sca.z)
        s == :N_pixels; min(length(sca.x), length(sca.y), length(sca.z))
        getfield(sca, s)
    end
end

# Base.setproperty!(sca::Scan, s::Symbol, value) = setfield!(sca, s, value)