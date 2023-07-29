using LinearAlgebra

export Phantom

Base.@kwdef mutable struct Phantom
    points::Matrix{Float64} = Matrix{Float64}(undef, 0, 4)
    time = 0.0
    sound_speed = 1540.0
    density = 1020.0
    alpha = 0.0
end

_phantom_dependant_symbols = [
    :N_points,
    :x, :y, :z,
    :Gamma, :Γ,
    :r, :radius,
    :theta, :θ,
    :phi, :ϕ
]

Base.propertynames(::Phantom, private::Bool=false) = union(_phantom_dependant_symbols, fieldnames(Phantom))

function Base.getproperty(p::Phantom, s::Symbol)
    if s == :N_points
        return size(p.points, 1)
    elseif s == :x
        return p.points[:, 1]
    elseif s == :y
        return p.points[:, 2]
    elseif s == :z
        return p.points[:, 3]
    elseif s ∈ [:Gamma, :Γ]
        return p.points[:, 4]
    elseif s ∈ [:r, :radius]
        return norm(p.points[:, 1:3])
    elseif s ∈ [:theta, :θ]
        return atan(p.points[:, 1], p.points[:, 3])
    elseif s ∈ [:phi, :ϕ]
        return atan(p.points[:, 2], p.points[:, 3])
    else
        return getfield(p, s)
    end
end

