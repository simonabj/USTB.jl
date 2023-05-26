using Revise

import Makie: @recipe, plot!
import Lazy: @dotimes
import ColorSchemes: viridis 
using GLMakie, USTB.UFF

GLMakie.activate!(framerate=60, vsync=true)

"""
# @recipe(ProbePlot) do scene
#     Theme()
# end
#
# const ConcreteProbePlot = ProbePlot{Tuple{<:Probe}}
# argument_names(::Type{<: ProbePlot}) = (:probe,)
#
# function plot!(plot::ConcreteProbePlot)
#     p = plot[1][] # Get probe thing
#
#     scheme = viridis;
#     colors = collect(get(scheme, range(0.0, 1.0, prb.N)));
#     colors = vec(repeat(colors',4,1));
#
#     x = vec([
#         (p.x - p.w ./ 2 .* cos.(p.θ))';
#         (p.x - p.w ./ 2 .* cos.(p.θ))'; 
#         (p.x + p.w ./ 2 .* cos.(p.θ))'; 
#         (p.x + p.w ./ 2 .* cos.(p.θ))'
#     ]);
#
#     y = vec([
#         (p.y - p.h ./ 2 .* cos.(p.ϕ))'; 
#         (p.y + p.h ./ 2 .* cos.(p.ϕ))'; 
#         (p.y - p.h ./ 2 .* cos.(p.ϕ))'; 
#         (p.y + p.h ./ 2 .* cos.(p.ϕ))'
#     ]);
#
#     z = vec([
#         (p.z + p.w./2.0.*sin.(p.θ) + p.h./2.0.*sin.(p.ϕ))';
#         (p.z + p.w./2.0.*sin.(p.θ) - p.h./2.0.*sin.(p.ϕ))';
#         (p.z - p.w./2.0.*sin.(p.θ) + p.h./2.0.*sin.(p.ϕ))';
#         (p.z - p.w./2.0.*sin.(p.θ) - p.h./2.0.*sin.(p.ϕ))';
#     ]);
#
#     vertices = [ x.*1e3 y.*1e3 -z.*1e3 ];
#
#     faces = reduce(vcat,[
#         [(i:1:i+2)' 
#         (i+3:-1:i+1)']
#         for i = 1:4:prb.N*4
#     ]);
#
#     mesh!(plot, vertices, faces, color=colors, shading=false, transparency=false)
#     scatter!(plot, p.x*1e3, p.y*1e3, -p.z*1e3, marker=:cross, color=:black, markersize=6)
#
#     for i=1:4:prb.N*4
#         lines!(plot,vertices[[i,i+1,i+3,i+2],:], color=:black, linewidth=1, overdraw=true)
#     end
#
#     plot
# end
"""

function plot(p::Probe, resolution=(600,400))
    f = Figure(resolution=resolution)

    ax = Axis3(
        f[1,1], 
        ztickformat = (values) -> ["$(-v)" for v ∈ values],
        aspect=:data, 
        viewmode=:fitzoom,
        xlabel="x [mm]", ylabel="y [mm]", zlabel="z [mm]",
        xticklabelpad = -5, yticklabelpad = -5, zticklabelpad = -5
    )

    probeplot!(ax, p)

    f
end

prb = CurvilinearArray();
prb.N = 128; prb.pitch = 500e-6; prb.radius = 70e-3;

plot(prb.probe)
display(f)