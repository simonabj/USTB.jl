using USTB.UFF
using GLMakie

function GLMakie.plot!(probeplot::ProbePlot)
    @extract probeplot (
        probe, cmap
    )
    p = probe[]
    scheme = cmap[]

    colors = collect(get(scheme, range(0.0, 1.0, length(p))))
    colors = vec(repeat(colors', 4, 1))

    x = vec([
        (p.x - p.w ./ 2 .* cos.(p.θ))'
        (p.x - p.w ./ 2 .* cos.(p.θ))'
        (p.x + p.w ./ 2 .* cos.(p.θ))'
        (p.x + p.w ./ 2 .* cos.(p.θ))'
    ])

    y = vec([
        (p.y - p.h ./ 2 .* cos.(p.ϕ))'
        (p.y + p.h ./ 2 .* cos.(p.ϕ))'
        (p.y - p.h ./ 2 .* cos.(p.ϕ))'
        (p.y + p.h ./ 2 .* cos.(p.ϕ))'
    ])

    z = vec([
        (p.z + p.w ./ 2.0 .* sin.(p.θ) + p.h ./ 2.0 .* sin.(p.ϕ))'
        (p.z + p.w ./ 2.0 .* sin.(p.θ) - p.h ./ 2.0 .* sin.(p.ϕ))'
        (p.z - p.w ./ 2.0 .* sin.(p.θ) + p.h ./ 2.0 .* sin.(p.ϕ))'
        (p.z - p.w ./ 2.0 .* sin.(p.θ) - p.h ./ 2.0 .* sin.(p.ϕ))'
    ])

    vertices = [x .* 1e3 y .* 1e3 -z .* 1e3]

    faces = reduce(vcat, [
        [(i:1:i+2)'
            (i+3:-1:i+1)']
        for i = 1:4:length(p)*4
    ])

    mesh!(probeplot, vertices, faces, color=colors, shading=false, transparency=false)
    scatter!(probeplot, p.x * 1e3, p.y * 1e3, -p.z * 1e3, marker=:cross, color=:black, markersize=6, overdraw=true)

    for i = 1:4:length(p)*4
        lines!(probeplot, vertices[[i, i + 1, i + 3, i + 2], :], color=:black, linewidth=1, overdraw=true)
    end

    return probeplot
end

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
