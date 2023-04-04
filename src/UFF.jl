module UFF

import USTB
import ContentHashes: hash, SHA

export Uff, save_hash!, check_hash!

version = v"1.2.0"

Base.@kwdef mutable struct Uff
    name::String            = ""
    reference::String       = ""
    author::Vector{String}  = []
    info::String            = ""

    last_hash::Base.SHA1    = hash("")
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

include("uff/Window.jl")
include("uff/Wavefront.jl")

end