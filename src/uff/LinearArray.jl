import Lazy: @forward, @switch
import Statistics: mean

export LinearArray

Base.@kwdef mutable struct LinearArray
    probe::Probe = Probe()
    
    N::Integer = 1
    pitch::Float64 = 0.0

    element_width::Float64  = 0.0
    element_height::Float64 = 0.0
end

# Forward all relevant functions on probe to LinearArray.probe field
@forward LinearArray.probe (
    Base.length, Base.size,
    Base.getindex, Base.setindex!, 
)

function update!(p::LinearArray)
    setfield!(p, :element_width,     getfield(p,:pitch))
    setfield!(p, :element_height, 10*getfield(p,:pitch))

    # Compute element abscissa
    x0 = (1:p.N).*p.pitch
    x0 = x0 .- mean(x0)

    getfield(p,:probe).geometry = [x0 zeros(p.N, 4) p.element_width*ones(p.N,1) p.element_height*ones(p.N,1)]
end

# Implement instance properties and delegate backwards
Base.propertynames(a::LinearArray, private::Bool=false) = union(
    propertynames(a.probe), fieldnames(LinearArray)
)

"Get property function"
function Base.getproperty(p::LinearArray, s::Symbol)
    @switch _ begin
        s ∈ propertynames(getfield(p, :probe)); getproperty(getfield(p, :probe), s)
        getfield(p, s)
    end
end


"Set property function"
function Base.setproperty!(p::LinearArray, s::Symbol, value) 
    @switch _ begin
        s ∈ propertynames(getfield(p, :probe)); setproperty!(getfield(p, :probe), s, value)
        ; begin
            setfield!(p, s, value)
            update!(p)
        end
    end
end