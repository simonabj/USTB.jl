using USTB.UFF
using GLMakie
import ColorSchemes


function GLMakie.plot(p::Probe; fig=nothing, axis=nothing, subplot=[1, 1], kwargs...)

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

    probeplot!(axis, p)

    return fig
end

GLMakie.plot(p::AbstractProbeArray; kwargs...) = GLMakie.plot(p.probe; kwargs...)
