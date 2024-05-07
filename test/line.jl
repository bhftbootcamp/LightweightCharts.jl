# test/line

@testset "LWCSimpleChartData(::Int64, ::Real)" begin
    @test LWCSimpleChartData(1680086570373_000000, 1.0) ==
          LWCSimpleChartData(1680086570373_000000, 1.0)
end

@testset "Line" begin
    line_chart = lwc_line(
        Vector{DateTime}([
            DateTime("2023-03-29T10:42:50.373"),
            DateTime("2023-03-29T10:42:51.373"),
            DateTime("2023-03-29T10:42:52.373"),
            DateTime("2023-03-29T10:42:53.373"),
            DateTime("2023-03-29T10:42:54.373"),
        ]),
        Vector{Real}([1, 5, 2, 3, 4]);
        label_name = "OK.ICX-USDT",
        price_scale_id = LWC_RIGHT,
        visible = true,
        line_color = "green",
        line_style = LWC_DOTTED,
        line_type = LWC_STEP,
        line_width = 1,
        precision = 5,
        crosshair_marker_visible = false,
        crosshair_marker_radius = 3.0,
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
        id = line_chart.id,
        label_name = "OK.ICX-USDT",
        label_color = "green",
        type = "addLineSeries",
        settings = LightweightCharts.LWCCharts.LineChartSettings(
            LWC_RIGHT,
            "OK.ICX-USDT",
            true,
            5,
            "green",
            LWC_DOTTED,
            1,
            LWC_STEP,
            true,
            false,
            4.0,
            false,
            3.0,
            "",
            "",
            2.0,
        ),
        data = Vector{LWCSimpleChartData}([
            LWCSimpleChartData(1680086570373_000000, 1.0),
            LWCSimpleChartData(1680086571373_000000, 5.0),
            LWCSimpleChartData(1680086572373_000000, 2.0),
            LWCSimpleChartData(1680086573373_000000, 3.0),
            LWCSimpleChartData(1680086574373_000000, 4.0),
        ]),
        plugins = Vector{LWCPlugin}([
            LWCPlugin(
                "addVertLine",
                LightweightCharts.LWCPlugins.VertLineSettings(
                    3,
                    "red",
                    "test",
                    1.5,
                    "green",
                    "white",
                    true,
                )
            )
        ]),
    )

    @test line_chart == result
end

@testset "Line2" begin
    line_chart = lwc_line(
        Vector{Tuple{DateTime,Real}}([
            (DateTime("2023-03-29T10:42:50.373"), 1),
            (DateTime("2023-03-29T10:42:51.373"), 5),
            (DateTime("2023-03-29T10:42:52.373"), 2),
            (DateTime("2023-03-29T10:42:53.373"), 3),
            (DateTime("2023-03-29T10:42:54.373"), 4),
        ]);
        label_name = "OK.ICX-USDT",
        price_scale_id = LWC_RIGHT,
        visible = true,
        line_color = "green",
        line_style = LWC_DOTTED,
        line_type = LWC_STEP,
        line_width = 1,
        precision = 5,
        crosshair_marker_visible = false,
        crosshair_marker_radius = 3.0,
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
        id = line_chart.id,
        label_name = "OK.ICX-USDT",
        label_color = "green",
        type = "addLineSeries",
        settings = LightweightCharts.LWCCharts.LineChartSettings(
            LWC_RIGHT,
            "OK.ICX-USDT",
            true,
            5,
            "green",
            LWC_DOTTED,
            1,
            LWC_STEP,
            true,
            false,
            4.0,
            false,
            3.0,
            "",
            "",
            2.0,
        ),
        data = Vector{LWCSimpleChartData}([
            LWCSimpleChartData(1680086570373_000000, 1.0),
            LWCSimpleChartData(1680086571373_000000, 5.0),
            LWCSimpleChartData(1680086572373_000000, 2.0),
            LWCSimpleChartData(1680086573373_000000, 3.0),
            LWCSimpleChartData(1680086574373_000000, 4.0),
        ]),
        plugins = Vector{LWCPlugin}([
            LWCPlugin(
                "addVertLine",
                LightweightCharts.LWCPlugins.VertLineSettings(
                    3,
                    "red",
                    "test",
                    1.5,
                    "green",
                    "white",
                    true,
                )
            )
        ]),
    )

    @test line_chart == result
end