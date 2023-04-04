export Wavefront

module Wavefront

export WavefrontType

"""
    WavefrontType(x::Integer)

Enumeration for wave types. 
Exported through USTB.UFF submodule.
Available options are 

|  Wavefront   | Value |
|--------------|-------|
| Plane        |   0   |
| Spherical    |   1   |
| Photoacustic |   2   |

See also WAVE
"""
@enum WavefrontType Plane=0 Spherical=1 Photoacustic=2

end
