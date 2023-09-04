export Wavefront

module Wavefront

export WavefrontType, Plane, Spherical, Photoacustic

"""
    WavefrontType

Enumeration for wave types. 
Exported through USTB.UFF submodule.
Available options are 


|    WavefrontType    | Value |
|---------------------|-------|
| Plane               |   0   |
| Spherical           |   1   |
| Photoacustic        |   2   |

See also WAVE
# TODO: Cross link WAVE
"""
@enum WavefrontType begin
    Plane = 0
    Spherical = 1
    Photoacustic = 2
end

end
