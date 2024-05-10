# examples/charts/05_from_csv
#
# Run from the project root with the command
# julia --project=. examples/charts/05_from_csv.jl

using Dates
using NanoDates
using TimeArrays
using LightweightCharts

timearray = Vector{LWCSimpleChartData}()

open(joinpath(@__DIR__, "..", "samples", "btcusdt.csv"), "r") do file
    for line in eachline(file)
        dt, v = split(line, "    ")
        color = parse(Float64, v) > 16544.40 ? "red" : "green"
        push!(timearray, LWCSimpleChartData(NanoDate(dt), parse(Float64, v),  color = color))
    end
end

plt = lwc_layout(
    lwc_panel(lwc_line(timearray; label_name = "BTCUSDT", line_type = LWC_STEP)),
    sync = false,
)

lwc_show(plt)
