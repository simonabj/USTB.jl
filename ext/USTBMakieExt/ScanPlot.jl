using USTB.UFF
using GLMakie
import ColorSchemes

function GLMakie.plot!(scanplot::ScanPlot{Tuple{<:Scan}})
    # Get scan observable
    sca = scanplot[:scan][]

    scatter!(scanplot, sca.xyz .* 1e3, markersize=scanplot[:markersize][])

    return scanplot
end

function GLMakie.plot(p::Scan; kwargs...)
    fig = Figure(resolution=(600, 400))

    ax, plt = GLMakie.plot(fig[1, 1], p; kwargs...)

    return Makie.FigureAxisPlot(fig, ax, plt)
end;


function GLMakie.plot(gpos::Makie.GridPosition, p::Scan; kwargs...)
    ax = Axis3(
        gpos,
        ztickformat=(values) -> ["$(-v)" for v ∈ values],
        aspect=:data,
        # viewmode=:fitzoom,
        xlabel="x [mm]", ylabel="y [mm]", zlabel="z [mm]",
        kwargs...
    )

    plt = scanplot!(ax, p)

    return Makie.AxisPlot(ax, plt)
end

GLMakie.plot(p::AbstractScan; kwargs...) = GLMakie.plot(p.scan; kwargs...);
GLMakie.plot(gpos::Makie.GridPosition, p::AbstractScan; kwargs...) = GLMakie.plot(gpos, p.scan; kwargs...)
