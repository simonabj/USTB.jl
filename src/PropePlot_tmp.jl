using Revise

import Makie: @recipe, plot!
import Lazy: @dotimes
using ColorSchemes
using GLMakie, USTB.UFF

@recipe(ProbePlot) do scene
    Theme()
end

const ConcreteProbePlot = ProbePlot{Tuple{<:Probe}}
argument_names(::Type{<: ProbePlot}) = (:probe,)

function plot!(plot::ConcreteProbePlot)
    p = plot[1][] # Get probe thing
    x = [(p.x - p.w ./ 2)'; (p.x + p.w ./ 2)'; (p.x + p.w ./ 2)'; (p.x - p.w ./ 2)']
    y = [(p.y - p.h ./ 2)'; (p.y - p.h ./ 2)'; (p.y + p.h ./ 2)'; (p.y - p.h ./ 2)']
    z = [(p.z)'; (p.z)'; (p.z)'; (p.z)']

    poly!(plot, x, y, z)
    # scatter!(plot, plot[1][][:,1:3])
    plot
end

function plot(p::Probe, resolution=(600,400))
    f = Figure(resolution=resolution)
    ax = Axis3(f[1,1], title="Probe")
    probeplot!(ax, p)
    f
end

prb = CurvilinearArray();
prb.N = 128; prb.pitch = 500e-6; prb.radius = 70e-3;
p = prb.probe
x = vec([
    (p.x - p.w ./ 2 .* cos.(p.θ))';
    (p.x - p.w ./ 2 .* cos.(p.θ))'; 
    (p.x + p.w ./ 2 .* cos.(p.θ))'; 
    (p.x + p.w ./ 2 .* cos.(p.θ))'
])

y = vec([
    (p.y - p.h ./ 2 .* cos.(p.ϕ))'; 
    (p.y + p.h ./ 2 .* cos.(p.ϕ))'; 
    (p.y - p.h ./ 2 .* cos.(p.ϕ))'; 
    (p.y + p.h ./ 2 .* cos.(p.ϕ))'
])
z = vec([
    (p.z + p.w./2.0.*sin.(p.θ) + p.h./2.0.*sin.(p.ϕ))';
    (p.z + p.w./2.0.*sin.(p.θ) - p.h./2.0.*sin.(p.ϕ))';
    (p.z - p.w./2.0.*sin.(p.θ) + p.h./2.0.*sin.(p.ϕ))';
    (p.z - p.w./2.0.*sin.(p.θ) - p.h./2.0.*sin.(p.ϕ))';
])

vertices = [ x.*1e3 y.*1e3 -z.*1e3 ]

faces = reduce(vcat,[
    [(i:1:i+2)' 
    (i+3:-1:i+1)']
    for i = 1:4:prb.N*4
])

scheme = ColorSchemes.viridis
colors = collect(get(scheme, range(0.0, 1.0, prb.N)))
colors = vec(repeat(colors',4,1))

minuslabels(values) = ["$(-v)" for v ∈ values]

f = Figure(resolution=(600,400))
ax = Axis3(
    f[1,1], ztickformat = minuslabels,
    aspect=:data, viewmode=:fitzoom,
    xlabel="x [mm]", ylabel="y [mm]", zlabel="z [mm]"
)
mesh!(ax, vertices, faces, color=colors, shading=false, transparency=false)
scatter!(Point3f.(p.x*1e3, p.y*1e3, -p.z*1e3), marker=:cross, color=:black, markersize=6)

for i=1:4:prb.N*4
    lines!(ax,vertices[[i,i+1,i+3,i+2],:], color=:black, linewidth=3)
end