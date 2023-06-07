module USTBMakieExt

# Define Makie recipes for USTB

include("recipes.jl")

include("ProbePlot.jl")
include("ScanPlot.jl")

export probeplot
export scanplot

end
