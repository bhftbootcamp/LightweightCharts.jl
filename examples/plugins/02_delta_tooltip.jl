# examples/plugins/02_delta_tooltip
#
# Run from the project root with the command
# julia --project=. examples/plugins/02_delta_tooltip.jl

using Dates
using NanoDates
using LightweightCharts
using TimeArrays

timearray = TimeArray{NanoDate,Float64}()

open(joinpath(@__DIR__, "..", "samples", "btcusdt.csv"), "r") do file
    for line in eachline(file)
        dt, v = split(line, "    ")
        push!(timearray, (NanoDate(dt), parse(Float64, v)))
    end
end

plt = lwc_layout(
    lwc_panel(
        lwc_line(
            timearray;
            label_name = "BTCUSDT",
            line_type = LWC_STEP,
            plugins = [lwc_delta_tooltip()],
        ),
    ),
    sync = false,
)

lwc_show(plt)
