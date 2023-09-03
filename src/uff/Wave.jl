export Wave

Base.@kwdef mutable struct Wave
    wavefront::Wavefront.WavefrontType = Wavefront.Spherical
    source::Point = Point([0, 0, 0])
    origin::Point = source
    apodization::Nothing = nothing # Not implemented yet

    probe::Union{AbstractProbeArray,Nothing} = nothing
    event::Union{Integer,Nothing} = nothing
    delay::Integer = 0
    sound_speed::Integer = 1540
end

Base.propertynames(::Wave, private::Bool=false) = union(fieldnames(Wave), [
    :N_elements,
    :delay_values,
    :apodization_values,
    :t0_origin
])

function Base.setproperty!(wave::Wave, s::Symbol, value)
    if s in fieldnames(Wave)
        setfield!(wave, s, convert(fieldtype(Wave, s), value))
    else
        error("No field $s in Wave instance.")
    end
end

function Base.getproperty(wave::Wave, s::Symbol)
    if s == :t0_origin
        value = 0.0
        if wave.source.z < 0
            value = -hypot(wave.source.xyz...) + hypot((wave.source.xyz - wave.origin.xyz)...)
        else
            value = hypot(wave.source.xyz...) - hypot((wave.source.xyz - wave.origin.xyz)...)
        end
        return value / wave.sound_speed
    elseif s == :N_elements
        return wave.probe.N_elements
    elseif s == :delay_values
        # TODO: Fix code. Gives wrong answer
        source_origin_dist = hypot((wave.source.xyz - wave.origin.xyz)...)
        if source_origin_dist < Inf
            dst = mapslices(norm, wave.probe.xyz .- wave.source.xyz', dims=2)
            if wave.source.z < 0
                return dst / wave.sound_speed - abs(source_origin_dist / wave.sound_speed)
            else
                return (source_origin_dist .- dst) / wave.sound_speed
            end
        else
            return (wave.probe.x - wave.origin.x) * sin(wave.source.azimuth)   / wave.sound_speed +
                   (wave.probe.y - wave.origin.y) * sin(wave.source.elevation) / wave.sound_speed
        end
    elseif s == :apodization_values
        error("Not implemented yet")
        return nothing
    end

    return getfield(wave, s)
end