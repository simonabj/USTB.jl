import Lazy: @forward

export LinearArray

Base.@kwdef mutable struct LinearArray
    probe::Probe = Probe()
    
    N::Integer = 1
    pitch::Float64 = 0.0

    element_width::Union{Float64, Nothing} = nothing
    element_height::Union{Float64, Nothing} = nothing
end

# Forward all relevant functions on probe to LinearArray.probe field
@forward LinearArray.probe dist, Base.getindex, Base.setindex!, Base.length, Base.size

