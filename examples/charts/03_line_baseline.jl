#  examples/charts/03_two_panels
#
# Run from the project root with the command
# julia --project=. examples/charts/03_line_baseline.jl

using Dates
using LightweightCharts

RANGE = 1:300

plt = lwc_layout(
    lwc_panel(
        lwc_line(
            now() + Second.(RANGE),
            sin.(RANGE / 10);
            label_name = "sin",
            line_style = LWC_DOTTED,  # LWC_SOLID, LWC_DOTTED, LWC_DASHED, LWC_LARGE_DASHED, LWC_SPARSE_DOTTED
            line_width = 5,
        ),
        lwc_baseline(
            now() + Second.(RANGE),
            3 * cos.(RANGE / 10);
            label_name = "baseline"
        ),
        lwc_baseline(
            [LWCSimpleChartData(
                now() + Second(i),
                0.5 * cos.(i / 5),
                top_fill_color_1 = randcolor(),
                top_fill_color_2 = randcolor(),
                top_line_color = randcolor(),
                bottom_fill_color_1 = randcolor(),
                bottom_fill_color_2 = randcolor(),
                bottom_line_color = randcolor(),
            ) for i in RANGE];
            label_name = "baseline"
        ),
    ),
    name = "LightweightCharts ❤️ Julia",
    sync = false,
)

lwc_show(plt)
