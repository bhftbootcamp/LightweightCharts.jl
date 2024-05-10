# examples/charts/01_one_line
#
# Run from the project root with the command
# julia --project=. examples/charts/01_one_line.jl

using Dates
using LightweightCharts
import LightweightCharts: randcolor

RANGE = 1:300

plt = lwc_layout(
    lwc_panel(
        lwc_line(
            now() + Second.(RANGE),
            sin.(RANGE / 10);
            label_name = "sin3",
            line_width = 3,
            price_scale_id = LWC_LEFT,
        ),
        lwc_line(
            time() .+ collect(RANGE),
            sin.(RANGE / 10);
            label_name = "sin2",
            line_width = 4,
            price_scale_id = LWC_RIGHT,
        ),
        lwc_line(
            sin.(RANGE / 10);
            label_name = "sin1",
            line_width = 5,
            price_scale_id = LWC_LEFT,
        ),
        x = 1,
        y = 1,
    ),
    lwc_panel(
        lwc_line(
            now() + Second.(RANGE),
            sin.(RANGE / 10);
            label_name = "sin3",
            line_width = 3,
            price_scale_id = LWC_LEFT,
        ),
        x = 2,
        y = 1,
    ),
    lwc_panel(
        lwc_line(
            now() + Second.(RANGE),
            sin.(RANGE / 10);
            label_name = "sin3",
            line_width = 3,
            price_scale_id = LWC_LEFT,
        ),
        lwc_line(
            [LWCSimpleChartData(now() + Second(i), sin(i / 5), color = randcolor()) for i in RANGE];
            label_name = "sin4",
            line_width = 3,
            price_scale_id = LWC_LEFT,
        ),
        x = 3,
        y = 1,
    ),
)

lwc_show(plt)
