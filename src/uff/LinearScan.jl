import Statistics: mean
import DocStringExtensions: TYPEDEF, TYPEDFIELDS
export LinearScan


"""
$(TYPEDEF)

A LinearScan defines a scan with pixel positions along the x and z axis and populates a wrapped scan.

**Fields**
---
$(TYPEDFIELDS)

**Example**
```
sca = LinearScan()
sca.x_axis=range(-20e-3,20e-3,256);
sca.z_axis=range(0e-3,40e-3,256);
```
#TODO: Link up Scan, SectorScan
"""
Base.@kwdef mutable struct LinearScan <: AbstractScan
    """Wrapped scan type"""
    scan::Scan = Scan()
    """Vector containing the x coordinates of the x - axis [m]"""
    x_axis::Vector{Float64} = [0]
    """Vector containing the z coordinates of the z - axis [m]"""
    z_axis::Vector{Float64} = [0]
end

Base.propertynames(::LinearScan, private::Bool=false) = union(
    fieldnames(LinearScan),
    propertynames(Scan()),
    [:N_x_axis, :N_z_axis, :x_step, :z_step, :reference_distance]
)

function Base.getproperty(sca::LinearScan, s::Symbol)
    s ∈ fieldnames(LinearScan) ? getfield(sca, s) :
    s ∈ propertynames(sca.scan) ? getproperty(sca.scan, s) :
    s == :N_x_axis ? length(sca.x_axis) :
    s == :N_z_axis ? length(sca.z_axis) :
    s == :x_step ? mean(diff(sca.x_axis)) :
    s == :z_step ? mean(diff(sca.z_axis)) :
    s == :reference_distance ? getfield(sca.scan, :z) :
    error("No property :$s in LinearScan")
end

function Base.setproperty!(sca::LinearScan, s::Symbol, value)
    if s ∈ fieldnames(LinearScan)
        setfield!(sca, s, convert(fieldtype(LinearScan, s), value))
        update_pixel_position!(sca)
    elseif s ∈ propertynames(sca.scan)
        setproperty!(sca.scan, s, value)
    elseif s ∈ propertynames(sca)
        error("Property $s is read-only")
    else
        error("No property $s in LinearScan")
    end
end

function update_pixel_position!(sca::LinearScan)
    # Define pixel mesh
    sca.xyz = hcat(
        (ones(length(sca.z_axis))'.*sca.x_axis)[:],
        zeros(length(sca.x_axis) * length(sca.z_axis)),
        (sca.z_axis'.*ones(length(sca.x_axis)))[:],
    )
end


