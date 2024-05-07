using Dates
using NanoDates
using Documenter
using LightweightCharts

DocMeta.setdocmeta!(LightweightCharts, :DocTestSetup, :(using LightweightCharts); recursive = true)

makedocs(
    modules = [LightweightCharts],
    sitename = "LightweightCharts.jl",
    format = Documenter.HTML(;
        repolink = "https://github.com/bhftbootcamp/LightweightCharts.jl",
        canonical = "https://bhftbootcamp.github.io/LightweightCharts.jl",
        edit_link = "master",
        assets = ["assets/favicon.ico"],
        sidebar_sitename = true,  # Set to 'false' if the package logo already contain its name
    ),
    pages = [
        "Home"    => "index.md",
        "API Reference" => [
            "pages/charts.md",
            "pages/plugins.md",
            "pages/layout.md",
            "pages/utils.md",
        ],
    ],
    warnonly = [:doctest, :missing_docs],
)

deploydocs(;
    repo = "github.com/bhftbootcamp/LightweightCharts.jl",
    devbranch = "master",
    push_preview = true,
)
