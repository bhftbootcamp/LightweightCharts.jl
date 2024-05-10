# examples/charts/05_tooltip
#
# Run from the project root with the command
# julia --project=. examples/charts/05_tooltip.jl

using Dates
using LightweightCharts

plt = lwc_layout(
    lwc_panel(
        lwc_line(
            time() .+ collect(1:100),
            map(x -> rand(1:100), collect(1:100));
            label_name = "BN.LUNA-BUSD",
            line_color = "blue",
            line_type = LWC_STEP,
            line_width = 1,
            precision = 3,
            plugins = [
                lwc_tooltip(
                    line_color = "green",
                    title = "My Own Tooltip",
                    follow_mode = LWC_TOOLTIP_TOP,
                ),
            ],
        ),
    ),
    name = "LightweightCharts ❤️ Julia",
    sync = true,
)

lwc_show(plt)
