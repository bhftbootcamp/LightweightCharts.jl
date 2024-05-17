# runtests

using Test
using Dates
using NanoDates
using LightweightCharts

function Base.:(==)(l::T, r::T) where {T<:Union{LWCChart,LWCPanel}}
    for field in fieldnames(typeof(l))
        if getfield(l, field) != getfield(r, field)
            return false
        end
    end
    return true
end

function lwc_show(plt; filepath = joinpath(homedir(), "lightweightcharts.html"))
    return "html"
end

const tests = String[
    "common",
    "area",
    "baseline",
    "histogram",
    "line",
    "bar",
    "candlestick",
    "panel",
]
const examples_charts = String[
    "01_one_line",
    "02_two_lines_and_styles",
    "03_line_baseline",
    "04_nanodates",
    "06_scatter_line",
    "07_bar",
]

const examples_plugins = String[
    "01_vert_line",
    "03_trend_line",
    "04_crosshair_highlight_bar",
    "05_tooltip",
]

@testset "LightweightCharts" begin
    @info("Running tests:")

    for test ∈ tests
        @info("\t * $test ...")
        include("$test.jl")
    end

    for example ∈ examples_charts
        @info "\t * examples/charts/$example ..."
        @testset "$example" begin
            @test_nowarn include("../examples/charts/$example.jl")
        end
    end

    for example ∈ examples_plugins
        @info "\t * examples/plugins/$example ..."
        @testset "$example" begin
            @test_nowarn include("../examples/plugins/$example.jl")
        end
    end
end