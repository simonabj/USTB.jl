export UFF
module UFF

import USTB
import ContentHashes: hash, SHA

export Uff, save_hash!, check_hash!

version = v"1.2.0"

Base.@kwdef mutable struct Uff
    name::String = ""
    reference::String = ""
    author::Vector{String} = []
    info::String = ""

    last_hash::Base.SHA1 = hash("")
end

function save_hash!(a)
    a.last_hash = hash("")
    a.last_hash = hash(a)
end

function check_hash!(a)
    prev_hash = a.last_hash
    a.last_hash = hash("")
    result = prev_hash == hash(a)
    a.last_hash = prev_hash
    return result
end

# Base types
include("Window.jl")
include("Wavefront.jl")
include("Point.jl")

# Scan
include("Scan.jl")
include("LinearScan.jl")
include("SectorScan.jl")

# Probes
include("Probe.jl")
include("LinearArray.jl")
include("CurvilinearArray.jl")

include("Pulse.jl")
include("Phantom.jl")

include("Wave.jl")

end
