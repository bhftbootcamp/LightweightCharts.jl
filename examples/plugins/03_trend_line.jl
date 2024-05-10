#  examples/plugins/03_trend_line
#
# Run from the project root with the command
# julia --project=. examples/plugins.03_trend_line.jl

using Dates
using LightweightCharts

RANGE = 1:300

plt = lwc_layout(
    lwc_panel(
        lwc_line(
            now() + Second.(RANGE),
            sin.(RANGE / 10);
            label_name = "sin",
            line_style = LWC_DOTTED,
            line_width = 5,
            line_color = "blue",
            plugins = [
                lwc_trend_line(20, 0.5, 120, 0.7),
                lwc_trend_line(10, 0.12, 90, 0.89),
            ],
        ),
        lwc_line(
            now() + Second.(RANGE),
            10 * cos.(RANGE / 10);
            label_name = "cos",
            line_type = LWC_STEP,
            price_scale_id = LWC_RIGHT,
            plugins = [lwc_trend_line(50, 0.32, 144, 0.86)],
        ),
    ),
)

lwc_show(plt)
