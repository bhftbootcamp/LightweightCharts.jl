# examples/plugins/04_crosshair_highlight_bar
#
# Run from the project root with the command
# julia --project=. examples/plugins/04_crosshair_highlight_bar.jl

using Dates
using LightweightCharts

RANGE = 1:3000

plt = lwc_layout(
    lwc_panel(
        lwc_line(
            now() + Second.(RANGE),
            sin.(RANGE / 10);
            label_name = "sin",
            plugins = [
                lwc_vert_line(rand(RANGE); show_label = true, label_text = "check"),
                lwc_crosshair_highlight_bar(color = "red"),
            ],
        ),
    ),
)

lwc_show(plt)