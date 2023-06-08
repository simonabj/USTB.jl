import Statistics: mean
import DocStringExtensions: TYPEDEF, TYPEDFIELDS
export SectorScan

"""
$(TYPEDEF)

A SectorScan defines a scan with pixel positions along the depth and azimuth axis and populates a wrapped scan.

**Fields**
---
$(TYPEDFIELDS)

**Example**
```
sca = SectorScan()
sca.x_axis=range(-20e-3,20e-3,256);
sca.z_axis=range(0e-3,40e-3,256);
```
#TODO: Link up Scan, SectorScan
"""
Base.@kwdef mutable struct SectorScan <: AbstractScan
    """Wrapped scan type"""
    scan::Scan = Scan()
    """Vector containing the distance coordinates [m]"""
    depth_axis::Vector{Float64} = [0]
    """Vector containing the azimuth coordinates [rad]"""
    azimuth_axis::Vector{Float64} = [0]
    """Origin of sector scan"""
    origin::Point = Point()
end

Base.propertynames(::SectorScan, private::Bool=false) = union(
    fieldnames(SectorScan),
    propertynames(Scan()),
    [:N_azimuth_axis, :N_depth_axis, :N_origins, :depth_step, :reference_distance]
)

function Base.getproperty(sca::SectorScan, s::Symbol)
    s ∈ fieldnames(SectorScan) ? getfield(sca, s) :
    s ∈ propertynames(sca.scan) ? getproperty(sca.scan, s) :
    s == :reference_distance ? getfield(sca.scan, :z) :
    error("No property :$s in SectorScan")
end

function Base.setproperty!(sca::SectorScan, s::Symbol, value)
    if s ∈ fieldnames(SectorScan)
        setfield!(sca, s, convert(fieldtype(SectorScan, s), value))
        update_pixel_position!(sca)
    elseif s ∈ propertynames(sca.scan)
        setproperty!(sca.scan, s, value)
    elseif s ∈ propertynames(sca)
        error("Property $s is read-only")
    else
        error("No property $s in SectorScan")
    end
end

function update_pixel_position!(sca::SectorScan)
    # Define pixel mesh
end


