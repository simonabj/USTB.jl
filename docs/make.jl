using USTB
using Documenter

DocMeta.setdocmeta!(USTB, :DocTestSetup, :(using USTB); recursive=true)

makedocs(;
    modules=[USTB],
    authors="Simon Andreas Bjørn",
    repo="https://github.com/Dainou01/USTB.jl/blob/{commit}{path}#{line}",
    sitename="USTB.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://Dainou01.github.io/USTB.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Ultrasound File Format" => "uff.md",
    ],
)

deploydocs(;
    repo="github.com/Dainou01/USTB.jl",
    devbranch="main",
)
