import Statistics: mean
import Lazy: @switch

export LinearScan

Base.@kwdef mutable struct LinearScan
    scan::Scan = Scan()
    x_axis::Vector{Float64} = []
    z_axis::Vector{Float64} = []
end

Base.propertynames(::LinearScan, private::Bool = false) = union(
        fieldnames(LinearScan), 
        fieldnames(Scan), 
        [:N_x_axis, :N_z_axis, :x_step, :z_step, :reference_distance])

function Base.getproperty(sca::LinearScan, s::Symbol)
    @switch _ begin
        s ∈ fieldnames(LinearScan); getfield(sca, s)
        s ∈ propertynames(sca.scan); getproperty(sca.scan, s)
        s == :N_x_axis; length(sca.x_axis)
        s == :N_z_axis; length(sca.z_axis)
        s == :x_step; mean(diff(sca.x_axis))
        s == :z_step; mean(diff(sca.z_axis))
        s == :reference_distance; getfield(sca.scan,:z)
    end
end

function update_pixel_position(sca::LinearScan)
    # Define pixel mesh
    X = ones()
end