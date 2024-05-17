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

@testset "LightweightCharts" begin
    @info("Running tests:")

    for test ∈ tests
        @info("\t * $test ...")
        include("$test.jl")
    end
end