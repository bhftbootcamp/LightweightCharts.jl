# test/area

@testset "LWCSimpleChartItem(::Int64, ::Real)" begin
    @test LWCSimpleChartItem(1680086570373_000000, 1.0) ==
          LWCSimpleChartItem(1680086570373_000000, 1.0)
end

@testset "Area" begin
    area_chart = lwc_area(
        Vector{DateTime}([
            DateTime("2023-03-29T10:42:50.373"),
            DateTime("2023-03-29T10:42:51.373"),
            DateTime("2023-03-29T10:42:52.373"),
            DateTime("2023-03-29T10:42:53.373"),
            DateTime("2023-03-29T10:42:54.373"),
        ]),
        Vector{Real}([1, 5, 2, 3, 4]);
        label_name = "area1",
        price_scale_id = LWC_LEFT,
        visible = false,
        top_color = "rgba(46, 220, 135, 0.4)",
        bottom_color = "rgba(40, 221, 100, 0)",
        line_color = "red",
        line_style = LWC_DASHED,
        line_type = LWC_SIMPLE,
        line_width = 2,
        precision = 4,
        point_markers_visible = false,
        point_markers_radius = 4.0,
        crosshair_marker_visible = true,
        crosshair_marker_radius = 5.0,
        crosshair_marker_border_color = "",
        crosshair_marker_background_color = "",
        plugins = [
            lwc_vert_line(
                3;
                color = "red",
                label_text = "test",
                width = 1.5,
                label_background_color = "green",
                label_text_color = "white",
                show_label = true,
            ),
        ],
    )

    result = LWCChart(;
        id = area_chart.id,
        label_name = "area1",
        label_color = "red",
        type = "addAreaSeries",
        settings = LightweightCharts.Charts.AreaChartSettings(
            LWC_LEFT,
            "area1",
            false,
            4,
            "rgba(46, 220, 135, 0.4)",
            "rgba(40, 221, 100, 0)",
            false,
            "red",
            LWC_DASHED,
            2,
            LWC_SIMPLE,
            false,
            4.0,
            true,
            5.0,
            "",
            "",
            2.0,
        ),
        data = LWCChartData([
            LWCSimpleChartItem(1680086570373_000000, 1.0),
            LWCSimpleChartItem(1680086571373_000000, 5.0),
            LWCSimpleChartItem(1680086572373_000000, 2.0),
            LWCSimpleChartItem(1680086573373_000000, 3.0),
            LWCSimpleChartItem(1680086574373_000000, 4.0),
        ]),
        plugins = Vector{LWCPlugin}([
            LWCPlugin(
                "addVertLine",
                LightweightCharts.Plugins.VertLineSettings(
                    3,
                    "red",
                    "test",
                    1.5,
                    "green",
                    "white",
                    true,
                ),
            ),
        ]),
    )

    @test area_chart == result
end

@testset "Area2" begin
    area_chart = lwc_area(
        Vector{Tuple{DateTime,Real}}([
            (DateTime("2023-03-29T10:42:50.373"), 1),
            (DateTime("2023-03-29T10:42:51.373"), 5),
            (DateTime("2023-03-29T10:42:52.373"), 2),
            (DateTime("2023-03-29T10:42:53.373"), 3),
            (DateTime("2023-03-29T10:42:54.373"), 4),
        ]);
        label_name = "area2",
        price_scale_id = LWC_LEFT,
        visible = false,
        top_color = "rgba(46, 220, 135, 0.4)",
        bottom_color = "rgba(40, 221, 100, 0)",
        line_color = "red",
        line_style = LWC_DASHED,
        line_type = LWC_SIMPLE,
        line_width = 2,
        precision = 4,
        crosshair_marker_visible = true,
        crosshair_marker_radius = 5.0,
        crosshair_marker_border_color = "",
        crosshair_marker_background_color = "",
        plugins = [
            lwc_vert_line(
                3;
                color = "red",
                label_text = "test",
                width = 1.5,
                label_background_color = "green",
                label_text_color = "white",
                show_label = true,
            ),
        ],
    )

    result = LWCChart(;
        id = area_chart.id,
        label_name = "area2",
        label_color = "red",
        type = "addAreaSeries",
        settings = LightweightCharts.Charts.AreaChartSettings(
            LWC_LEFT,
            "area2",
            false,
            4,
            "rgba(46, 220, 135, 0.4)",
            "rgba(40, 221, 100, 0)",
            false,
            "red",
            LWC_DASHED,
            2,
            LWC_SIMPLE,
            false,
            4.0,
            true,
            5.0,
            "",
            "",
            2.0,
        ),
        data = LWCChartData([
            LWCSimpleChartItem(1680086570373_000000, 1.0),
            LWCSimpleChartItem(1680086571373_000000, 5.0),
            LWCSimpleChartItem(1680086572373_000000, 2.0),
            LWCSimpleChartItem(1680086573373_000000, 3.0),
            LWCSimpleChartItem(1680086574373_000000, 4.0),
        ]),
        plugins = Vector{LWCPlugin}([
            LWCPlugin(
                "addVertLine",
                LightweightCharts.Plugins.VertLineSettings(
                    3,
                    "red",
                    "test",
                    1.5,
                    "green",
                    "white",
                    true,
                ),
            ),
        ]),
    )

    @test area_chart == result
end
