export Window

module Window

export WindowType

"""
    WindowType(x::Integer)

Enumeration for window types. 
Available options are 

| Window Type | Value |
|-------------|-------|
| None        |   0   |
| Boxcar      |   1   |
| Flat        |   1   |
| Rectangular |   1   |
| Hanning     |   2   |
| Hamming     |   3   |
| Tukey25     |   4   |
| Tukey50     |   5   |
| Tukey75     |   6   |
| Tukey80     |   7   |
| Sta         |   7   |
| Scanline    |   8   |

See also PULSE, BEAM, PHANTOM, PROBE
# TODO: Link up PULSE
# TODO: Link up BEAM
# TODO: Link up PHANTOM
# TODO: Link up PROBE
"""
@enum WindowType begin
    None=0
    Boxcar
    Hanning
    Hamming
    Tukey25
    Tukey50
    Tukey75
    Tukey80
    Scanline
end

# Assign alias to some windows
const Rectangular = Boxcar
const Flat = Boxcar
const Sta = Tukey80

end