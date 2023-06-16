import GLMakie: @recipe, plot!, lines!, mesh!, scatter!, Theme 
import ColorSchemes

@recipe(ProbePlot, probe) do scene
    attr = merge!(
        Attributes(;
            default_theme(scene)...,
            cmap=ColorSchemes.viridis
        )
    )
    attr
end

@recipe(ScanPlot, scan) do scene
    Attributes(;
        default_theme(scene)...,
        markersize = 0.7
    )
end