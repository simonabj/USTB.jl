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
    depth_axis::Vector{Float64} = []
    """Vector containing the azimuth coordinates [rad]"""
    azimuth_axis::Vector{Float64} = []
    """Origin of sector scan"""
    origin::Point = Point(0, 0, 0)
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
    s == :N_azimuth_axis ? length(sca.azimuth_axis) :
    s == :N_depth_axis ? length(sca.depth_axis) :
    s == :N_origins ? length(sca.origin) :
    s == :depth_step ? mean(diff(sca.depth_axis)) :
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
    if isempty(sca.azimuth_axis) || isempty(sca.depth_axis)
        return
    end

    # Define pixel grid
    grid = [[ρ, θ] for ρ = sca.depth_axis, θ = sca.azimuth_axis]
    ρ, θ = first.(grid), last.(grid)

    N_pixels = reduce(*, size(grid))

    # Define origins
    x0, y0, z0 = CartesianFromPoint()(sca.origin)
    println(x0)

    # Position of pixels 
    sca.scan.x = (ρ.*sin.(θ).+x0)[:]
    sca.scan.y = (zeros(N_pixels).+y0)[:]
    sca.scan.z = (ρ.*cos.(θ).+z0)[:]
end

