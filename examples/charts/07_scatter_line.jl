# examples/charts/07_scatter_line
#
# Run from the project root with the command
# julia --project=. examples/charts/07_scatter_line.jl

using Dates, Random
using LightweightCharts

NUM_POINTS = 1000

plt = lwc_layout(
    lwc_panel(
        min_charts_for_search = 5,
        lwc_line(
            rand(NUM_POINTS);
            label_name = "scatter",
            point_markers_visible = true,
            line_visible = false,
        ),
        lwc_line(
            rand(NUM_POINTS);
            label_name = "scatter",
            point_markers_visible = true,
            line_visible = false,
        ),
        lwc_line(
            rand(NUM_POINTS);
            label_name = "scatter",
            point_markers_visible = true,
            line_visible = false,
        ),
        lwc_line(
            rand(NUM_POINTS);
            label_name = "scatter",
            point_markers_visible = true,
            line_visible = false,
        ),
        lwc_line(
            rand(NUM_POINTS);
            label_name = "scatter",
            point_markers_visible = true,
            line_visible = false,
        ),
        lwc_line(
            rand(NUM_POINTS);
            label_name = "scatter",
            point_markers_visible = true,
            line_visible = false,
        ),
        lwc_line(
            rand(NUM_POINTS);
            label_name = "scatter",
            point_markers_visible = true,
            line_visible = false,
        ),
        lwc_line(
            rand(NUM_POINTS);
            label_name = "scatter",
            point_markers_visible = true,
            line_visible = false,
        ),
        lwc_line(
            rand(NUM_POINTS);
            label_name = "scatter",
            point_markers_visible = true,
            line_visible = false,
        ),
        lwc_line(
            rand(NUM_POINTS);
            label_name = "scatter",
            point_markers_visible = true,
            line_visible = false,
        ),
        lwc_line(
            rand(NUM_POINTS);
            label_name = "scatter",
            point_markers_visible = true,
            line_visible = false,
        ),
        lwc_line(
            rand(NUM_POINTS);
            label_name = "scatter",
            point_markers_visible = true,
            line_visible = false,
        ),
        lwc_line(
            rand(NUM_POINTS);
            label_name = "scatter",
            point_markers_visible = true,
            line_visible = false,
        ),
        lwc_line(
            rand(NUM_POINTS);
            label_name = "scatter",
            point_markers_visible = true,
            line_visible = false,
        ),
        lwc_line(
            rand(NUM_POINTS);
            label_name = "scatter",
            point_markers_visible = true,
            line_visible = false,
        ),
        lwc_line(
            rand(NUM_POINTS);
            label_name = "scatter",
            point_markers_visible = true,
            line_visible = false,
        ),
        lwc_line(
            rand(NUM_POINTS);
            label_name = "scatter",
            point_markers_visible = true,
            line_visible = false,
        ),
        lwc_line(
            rand(NUM_POINTS);
            label_name = "scatter",
            point_markers_visible = true,
            line_visible = false,
        ),
        lwc_line(
            rand(NUM_POINTS);
            label_name = "scatter",
            point_markers_visible = true,
            line_visible = false,
        ),
        lwc_line(
            rand(NUM_POINTS);
            label_name = "scatter",
            point_markers_visible = true,
            line_visible = false,
        ),
        lwc_line(
            rand(NUM_POINTS);
            label_name = "scatter",
            point_markers_visible = true,
            line_visible = false,
        ),
        lwc_line(
            rand(NUM_POINTS);
            label_name = "scatter",
            point_markers_visible = true,
            line_visible = false,
        ),
    ),
)

lwc_show(plt)
