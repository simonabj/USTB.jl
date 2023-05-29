import EnumX: @enumx

export Wavefront

"""
    Wavefront

Enumeration for wave types. 
Exported through USTB.UFF submodule.
Available options are 


See also WAVE
# TODO: Cross link WAVE
"""
@enumx Wavefront begin 
    "Wavefront instance describing a plane wave"
    Plane=0
    "Wavefront instance describing a spherical wave"
    Spherical=1
    "Wavefront instance describing a photoacustic wave"
    Photoacustic=2
end
