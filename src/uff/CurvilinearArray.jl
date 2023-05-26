import Statistics: mean
import Lazy: @switch

export CurvilinearArray

Base.@kwdef mutable struct CurvilinearArray <: AbstractProbeArray
    probe::Probe = Probe()

    N::Integer = 0
    pitch::Float64  = 1.0
    radius::Float64 = 1.0

    element_width::Float64  = 0.0
    element_height::Float64 = 0.0
end

@forward CurvilinearArray.probe (
    Base.length, Base.size,
    Base.getindex, Base.setindex!, 
)

function update!(p::CurvilinearArray)
    setfield!(p, :element_width, p.pitch)
    setfield!(p, :element_height, 10*p.pitch)
    
    # Compute element coordinates
    dθ = 2*asin(p.pitch / 2.0 / p.radius)
    θ = (0:p.N-1).*dθ; θ = θ .- mean(θ);
    
    x0 = p.radius.*sin.(θ);
    z0 = p.radius.*cos.(θ) .- p.radius;

    p.probe.geometry = [x0 zeros(p.N) z0 θ zeros(p.N) p.element_width*ones(p.N) p.element_height*ones(p.N)]
end

# Implement instance properties and delegate backwards
Base.propertynames(a::CurvilinearArray, private::Bool=false) = union(
    propertynames(a.probe), fieldnames(CurvilinearArray)
)

function Base.getproperty(p::CurvilinearArray, s::Symbol)
    @switch _ begin
        s ∈ propertynames(getfield(p, :probe)); getproperty(getfield(p, :probe), s)
        getfield(p, s)
    end
end

function Base.setproperty!(p::CurvilinearArray, s::Symbol, value) 
    @switch _ begin
        s ∈ propertynames(getfield(p, :probe)); setproperty!(getfield(p, :probe), s, value)
        ; begin
            setfield!(p, s, value)
            update!(p)
        end
    end
end