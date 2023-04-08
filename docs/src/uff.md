# `UFF` - Ultrasound File Format

## Points

```@docs
USTB.UFF.Point
USTB.UFF.PointFromCartesian
USTB.UFF.CartesianFromPoint
```
---
## Probe
```@docs
USTB.UFF.Probe
Base.length(p::USTB.UFF.Probe)
```
### Interfaces
`Probe` implements the `Instance Properties` interface from `Base`
allowing to access specific properties of `Probe` easily, through the
`.` operator.
```@docs
Base.propertynames(::USTB.UFF.Probe, private::Bool=false)
Base.getproperty(p::USTB.UFF.Probe, s::Symbol)
Base.setproperty!(p::USTB.UFF.Probe, s::Symbol, value) 
```
#### Property Interface Example
```@repl
using USTB.UFF # hide
a = Probe(Point([2,0,4]), rand(3,7));
a[:,1:3] = [1 2 3; 4 5 6; 7 8 9];
a.x
a.y = [10, 11, 12];
a.geometry
```
### Method delegations

`Probe` also forwards `Base.size` and `Base.getindex` to `Probe.geometry`,
meaning `size(p::Probe)` and `getindex(p::Probe,...)` work as they do for
matrices, but operate on `Probe.geometry`.
```@docs
Base.size(p::USTB.UFF.Probe, args...; kwargs...)
Base.getindex(p::USTB.UFF.Probe, args...; kwargs...) 
Base.setindex!(p::USTB.UFF.Probe, args...; kwargs...) 
```

## Linear Array

```@docs
```

---
## Wavefronts

```@docs
USTB.UFF.Wavefront.WavefrontType
```

---
## Windows

```@docs
USTB.UFF.Window.WindowType
```