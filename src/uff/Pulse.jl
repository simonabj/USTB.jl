export Pulse

Base.@kwdef mutable struct Pulse
    center_frequency::Float64 = 1.0      # center frequency [Hz]
    fractional_bandwidth::Float64 = 0.0  # probe fractional bandwidth [unitless]
    phase::Float64 = 0.0                 # initial phase [rad]
    waveform::Wavefront.WavefrontType = Wavefront.Plane # transmitted waveform (for example used for match filtering)
end

# Instead of having dedicated signal function, we use a functor on Pulse to allow direct signal calculation from instances
(p::Pulse)(time) = cos(2π * p.center_frequency * time + p.phase) .* exp(-1.7886 * (time * p.fractional_bandwidth * p.center_frequency) .^ 2)
