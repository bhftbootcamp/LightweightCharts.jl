# examples/charts/08_bar
#
# Run from the project root with the command
# julia --project=. examples/charts/08_bar.jl

using Dates
using LightweightCharts

BARS_MIDDLE = map(x -> rand(1400:1600), 1:100)

plt = lwc_layout(
    lwc_panel(
        lwc_bar(
            time() .+ collect(1:100),
            BARS_MIDDLE,
            max(BARS_MIDDLE, [BARS_MIDDLE[2:end]..., 1500]) .+ 100 * rand(100),
            min(BARS_MIDDLE, [BARS_MIDDLE[2:end]..., 1500]) .- 100 * rand(100),
            [BARS_MIDDLE[2:end]..., 1500];
            label_name = "bar",
            up_color = "blue",
            down_color = "orange",
        ),
    ),
)

lwc_show(plt)
