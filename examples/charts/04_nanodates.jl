# examples/charts/04_nanodates
#
# Run from the project root with the command
# julia --project=. examples/charts/04_nanodates.jl

using Dates
using NanoDates
using LightweightCharts

LEN = 300
timestamps = NanoDate("2023-01-01T12:00:00") + Second.(0:LEN)
area_values = cos.(rand(LEN + 1))

plt = lwc_layout(
    lwc_panel(lwc_area(timestamps, area_values; label_name = "1 s")),
    sync = false,
)

lwc_show(plt)
