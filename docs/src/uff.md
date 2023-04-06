# `UFF` - Ultrasound File Format

## Points

```@docs
USTB.UFF.Point
USTB.UFF.PointFromCartesian
USTB.UFF.CartesianFromPoint
```

## Probe
```@docs
USTB.UFF.Probe
Base.length(p::USTB.UFF.Probe)
```
`Probe` also forwards `Base.size` and `Base.getindex` to `Probe.geometry`,
meaning `size(p::Probe)` and `getindex(p::Probe,)` work as they do for
matrices, but operate on `Probe.geometry`.
```@docs
Base.size(p::USTB.UFF.Probe, args...; kwargs...)
Base.getindex(p::USTB.UFF.Probe, args...; kwargs...) 
Base.getindex(p::USTB.UFF.Probe, s::Symbol)
```

## Wavefronts

```@docs
USTB.UFF.Wavefront.WavefrontType
```

## Windows

```@docs
USTB.UFF.Window.WindowType
```