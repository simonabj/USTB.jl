import DSP: filtfilt

export Apodization, apply_window

Base.@kwdef mutable struct Apodization
    probe::AbstractProbeArray = LinearArray()
    focus::AbstractScan = LinearScan()
    sequence::Vector{AbstractWave} = []

    f_number::Vector{Float64} = [1, 1]
    window::Window.WindowType = Window.None
    mla::Integer = 1
    mla_overlap::Integer = 0

    tilt::Vector{Float64} = [0, 0]
    minimum_aperture::Vector{Float64} = [1e-3, 1e-3]
    maximum_aperture::Vector{Float64} = [10, 10]

    apodization_vector::Vector{Float64} = []
    origin::Union{Point,Nothing} = nothing

    _data_backup::Nothing = nothing

    # Allow struct to be hashable
    last_hash::Base.SHA1 = hash("") 
end

Base.propertynames(::Apodization, private::Bool=false) = union(fieldnames(Apodization), [:data, :N_elements])

function Base.setproperty!(apo::Apodization, s::Symbol, value)
    if s == :f_number && length(value) == 1
        setfield!(apo, s, [value, value])
    elseif s == :tilt && length(value) == 1
        setfield!(apo, s, [value, 0])
    elseif s == :minimum_aperture && length(value) == 1
        setfield!(apo, s, [value, value])
    elseif s == :maximum_aperture && length(value) == 1
        setfield!(apo, s, [value, value])
    else
        setfield!(apo, s, convert(fieldtype(Apodization, s), value))
    end
end

function Base.getproperty(apo::Apodization, s::Symbol)
    if s == :data
        compute!(apo)
        return apo._data_backup
    elseif s == :N_elements
        # This is horrible... Why does it change behaviour based on state of a variable!?
        if isempty(apo.sequence)
            return apo.probe.N_elements
        else
            return length(apo.sequence)
        end
    else
        getfield(apo, s)
    end
end

boxcar_ratio(ratio) = Float32(ratio <= 0.5)
hanning_ratio(ratio) = Float32(ratio <= 0.5).*(0.5 + 0.5 * cos(2π*ratio))
hamming_ratio(ratio) = Float32(ratio <= 0.5).*(0.53836 + 0.46164*cos(2π*ratio))
tukey_ratio(ratio, roll) = Float32(ratio<=(1/2*(1-roll))) + (ratio>(1/2*(1-roll))).*(ratio<(1/2)).*0.5.*(1+cos(2*pi/roll*(ratio-roll/2-1/2)))

function apply_window(apo::Apodization, ratio_theta, ratio_phi)
    return (apo.window == Window.Boxcar) ? boxcar_ratio(ratio_theta) .* boxcar_ratio(ratio_phi) :
        (apo.window == Window.Hanning) ? hanning_ratio(ratio_theta).*hanning_ratio(ratio_phi) :
        (apo.window == Window.Hamming) ? hamming_ratio(ratio_theta).*hamming_ratio(ratio_phi) :
        (apo.window == Window.Tukey25) ? tukey_ratio(ratio_theta, 0.25).*tukey_ratio(ratio_phi, 0.25) :
        (apo.window == Window.Tukey50) ? tukey_ratio(ratio_theta, 0.50).*tukey_ratio(ratio_phi, 0.50) :
        (apo.window == Window.Tukey75) ? tukey_ratio(ratio_theta, 0.75).*tukey_ratio(ratio_phi, 0.75) :
        (apo.window == Window.Tukey80) ? tukey_ratio(ratio_theta, 0.80).*tukey_ratio(ratio_phi, 0.80) :
        error("Unknown apodization window $(apo.window)")
end

function compute!(apo::Apodization)
    if isempty(apo.sequence)
        compute_aperture_apodization!(apo)
    else
        compute_wave_apodization!(apo)
    end
end

function compute_aperture_apodization!(apo::Apodization)
    if !isempty(apo.apodization_vector)
        apo._data_backup = ones(apo.focus.N_pixels, 1)
        return;
    end

    # No apodization
    if apo.window == Window.None
        apo._data_backup = ones(apo.focus.N_pixels, apo.probe.N_elements)

    # Sta apodization (just use the element closest to user set origin)
    elseif apo.window == Window.Sta
        dist = norm(apo.probe.xyz - apo.origin.xyz)
        apo._data_backup = ones(apo.focus.N_pixels, 1) * Float64(dist == min(dist))
    else
        # Incidence
        tan_theta, tan_phi, _ = incidence_aperture(apo)

        # Ratios F*tan(angle)
        ratio_theta = abs(apo.f_number[1] * tan_theta)
        ratio_phi = abs(apo.f_number[2] * tan_phi)

        # Apodization window
        apo._data_backup = apply_window(apo, ratio_theta, ratio_phi)
    end

    save_hash!(apo)
end

function compute_wave_apodization!(apo::Apodization)
    N_waves = length(apo.sequence)

    if !isempty(apo.apodization_vector)
        apo._data_backup = ones(apo.focus.N_pixels,1) * apo.apodization_vector
        return
    end

    if apo.window == Window.None
        apo._data_backup = ones(apo.focus.N_pixels, N_waves)

    elseif apo.window == Window.Scanline
        major_axis,minor_axis = isa(apo.focus, LinearScan) ? (:N_x_axis,:N_z_axis) :
                                isa(apo.focus, SectorScan) ? (:N_azimuth_axis, :N_depth_axis) :
        error("UFF: Apodization: compute_wave_apodization does not support scanline based beamforming using scan type $(typeof(apo.focus)). This must be done manually, defining several scans and setting the apodization to Window.None")

        ACell = repeat(ones(apo.mla, 1), outer=(1, getproperty(apo.focus, major_axis)) ÷ apo.mla)
        if apo.mla_overlap > 0
            ABlock = filtfilt(vec(ones((1,apo.mla_overlap+1)) / (apo.mla_overlap+1)), cat(ACell[]..., dims=(1,2)))
        else
            ABlock = cat(ACell[]..., dims=(1,2))
        end
        apo._data_backup = kron(ABlock, ones(getproperty(apo.focus, minor_axis), 1))
    else
        tan_theta, tan_phi, _ = incidence_wave(apo)

        ratio_theta = abs(apo.f_number[1]*tan_theta)
        ratio_phi = abs(apo.f_number[2]*tan_phi)

        # Apodization window
        apo._data_backup = apply_window(apo, ratio_theta, ratio_ratio_phi)
    end

    save_hash!(apo)
end

function incidence_aperture(apo::Apodization)
    tan_theta = zeros((apo.focus.N_pixels, 1))
    tan_phi = zeros((apo.focus.N_pixels, 1))
    distance = zeros((apo.focus.N_pixels, 1))

    x = ones((apo.focus,:N_pixels, 1))*transpose(apo.probe.x)
    y = ones((apo.focus.N_pixels, 1))*transpose(apo.probe.y)
    z = ones((apo.focus.N_pixels, 1))*transpose(apo.probe.z)

    # if the apodization center has not been set by the user
    if isnothing(apo.origin)
        if isa(apo.probe, UFF.CurvilinearArray)
            apo.origin = Uff.Point()
            set!(apo.origin, :xyz, [0 0 -apo.probe.radius])
        elseif isa(apo.focus, UFF.SectorScan)
            apo.origin = apo.focus.apex
        end
    end

    # If we use a curvilinear array
    if isa(apo.probe, Uff.CurvilinearArray)
        element_azimuth = atan(x-apo.origin.x), z - apo.origin.z

        pixel_azimuth = atan(apo.focus.x - apo.origin.x, apo.focus.z - apo.origin.z)
        pixel_distance = norm([apo.focus.x - apo.origin.x, apo.focus.z - apo.origin.z])
      
        x_dist = apo.probe.radius * pixel_azimuth.-element_azimuth
        y_dist = apo.origin.y - y
        z_dist = pixel_distance * ones((1, apo.N_elements)) - apo.probe.radius

    # Sector scan
    elseif isa(apo.focus, UFF.SectorScan)
        pixel_distance = norm([apo.focus.x - apo.origin.x, apo.focus.z - apo.origin.z])

        x_dist = x - apo.origin.x
        y_dist = apo.origin.y - y
        z_dist = pixel_distance * ones((1, apo.N_elements))
    
    # Else, we have a flat probe and a linear scan. Set aperture center right on top
    else
        if isnothing(apo.origin)
            x_dist = apo.focus.x * ones((1, apo.probe.N_elements)) - x
            y_dist = apo.focus.y * ones((1, apo.probe.N_elements)) - y
            z_dist = apo.focus.z * ones((1, apo.probe.N_elements)) - z
        else
            x_dist = apo.origin.x - x
            y_dist = apo.origin.y - y
            z_dist = apo.origin.z - z
        end
    end

    #Apply tilt
    if any(abs(apo.tilt) > 0)
        x_dist, y_dist, z_dist = USTB.rotate_points(x_dist, y_dist, z_dist, apo.tile[1], apo.tilt[2])
    end

    # Minimum aperture
    z_dist[z_dist >= 0 & z_dist <  apo.minimum_aperture[1] / apo.f_number[1]] =  apo.minimum_aperture[1] / apo.f_number[1]
    z_dist[z_dist <  0 & z_dist > -apo.minimum_aperture[1] / apo.f_number[1]] = -apo.minimum_aperture[1] / apo.f_number[1]

    # Maximum aperture
    z_dist[z_dist >= 0 & z_dist <  apo.maximum_aperture[1] / apo.f_number[1]] =  apo.maximum_aperture[1] / apo.f_number[1]
    z_dist[z_dist <  0 & z_dist > -apo.maximum_aperture[1] / apo.f_number[1]] = -apo.maximum_aperture[1] / apo.f_number[1]
    
    # Azimuth and elevation tangents, including tilting overwrite
    tan_theta = x_dist ./ z_dist
    tan_phi = y_dist ./ z_dist    
    distance = z_dist

    return tan_theta, tan_phi, distance
end

function incidence_wave(apo::Apodization)
    return 1,2,3
end