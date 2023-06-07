using USTB.UFF
using GLMakie
import ColorSchemes

function GLMakie.plot!(scanplot::ScanPlot{Tuple{<:Scan}})
    # Get scan observable
    sca = scanplot[:scan][];

    scatter!(scanplot, sca.xyz.*1e3, markersize=scanplot[:markersize][])

    return scanplot
end

function GLMakie.plot(p::Scan; fig=nothing, axis=nothing, subplot=[1, 1], kwargs...)
    if isnothing(fig)
        fig = Figure(resolution=(600, 400))
    end

    if isnothing(axis)
        axis = Axis3(
            fig[subplot...],
            ztickformat=(values) -> ["$(-v)" for v ∈ values],
            aspect=:data,
            viewmode=:fitzoom,
            xlabel="x [mm]", ylabel="y [mm]", zlabel="z [mm]",
            kwargs...
        )
    end

    scanplot!(axis, p)

    return fig
end;

GLMakie.plot(p::AbstractScan; kwargs...) = GLMakie.plot(p.scan; kwargs...);
