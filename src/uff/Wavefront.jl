export Wavefront

module Wavefront

export WavefrontType

"""
    WavefrontType(x::Integer)

Enumeration for wave types. 
Exported through USTB.UFF submodule.
Available options are Plane, Spherical and Photoacustic

See also [Wave](@ref wave_docs)
"""
@enum WavefrontType Plane=0 Spherical=1 Photoacustic=2

end
