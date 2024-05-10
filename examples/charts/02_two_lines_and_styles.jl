#  examples/charts/02_two_lines_and_styles
#
# Run from the project root with the command
# julia --project=. examples/charts/02_two_lines_and_styles.jl

using Dates
using LightweightCharts
import LightweightCharts: randcolor

RANGE = 1:300

plt = lwc_layout(
    lwc_panel(
        lwc_line(
            [LWCSimpleChartData(now() + Second(i), sin(i / 5), color = randcolor()) for i in RANGE];
            label_name = "sin",
            line_style = LWC_DOTTED,  # LWC_SOLID, LWC_DOTTED, LWC_DASHED, LWC_LARGE_DASHED, LWC_SPARSE_DOTTED
            line_width = 5,
            line_color = "blue",
        ),
        lwc_line(
            now() + Second.(RANGE),
            10 * cos.(RANGE / 10);
            label_name = "cos",
            line_type = LWC_STEP, # LWC_SIMPLE LWC_STEP LWC_CURVED
            price_scale_id = LWC_RIGHT, # LWC_LEFT LWC_RIGHT
        ),
    ),
)

lwc_show(plt)
