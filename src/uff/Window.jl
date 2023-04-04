export Window

module Window

# Define the default enum for windows
@enum WindowEnum begin
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