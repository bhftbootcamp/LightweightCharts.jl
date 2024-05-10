# examples/charts/06_candlesticks
#
# Run from the project root with the command
# julia --project=. examples/charts/06_candlesticks.jl

using Dates
using NanoDates
using LightweightCharts
import LightweightCharts: randcolor

candlesticks = Vector{LWCCandle}()
times = Vector{NanoDate}()
volumes = Vector{Float64}()
tradesnumbes = Vector{Int64}()

open(joinpath(@__DIR__, "..", "samples", "btcusdt_candlesticks.csv"), "r") do file
    for line in eachline(file)
        symbol, opentime, openprice, highprice, lowprice, closeprice, volume, tradesnumber = split(line, "    ")
        push!(
            candlesticks,
            LWCCandle(
                NanoDate(opentime),
                parse(Float64, openprice),
                parse(Float64, highprice),
                parse(Float64, lowprice),
                parse(Float64, closeprice);
                color = randcolor(),
                border_color = randcolor(),
                wick_color = randcolor(),
            ),
        )
        push!(times, NanoDate(opentime))
        push!(volumes, parse(Float64, volume))
        push!(tradesnumbes, parse(Int64, tradesnumber))
    end
end

plt = lwc_layout(
    lwc_panel(lwc_candlestick(candlesticks; label_name = "candlestick")),
    sync = true,
)

lwc_show(plt)
