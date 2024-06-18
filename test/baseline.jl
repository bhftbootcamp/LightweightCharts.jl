# test/baseline

@testset "LWCSimpleChartData(::Int64, ::Real)" begin
    @test LWCSimpleChartData(1680086570373_000000, 1.0) ==
          LWCSimpleChartData(1680086570373_000000, 1.0)
end

@testset "BaseLine" begin
    baseline_chart = lwc_baseline(
        Vector{DateTime}([
            DateTime("2023-03-29T10:42:50.373"),
            DateTime("2023-03-29T10:42:51.373"),
            DateTime("2023-03-29T10:42:52.373"),
            DateTime("2023-03-29T10:42:53.373"),
            DateTime("2023-03-29T10:42:54.373"),
        ]),
        Vector{Real}([1, 5, 2, 3, 4]);
        label_name = "baseline",
        price_scale_id = LWC_RIGHT,
        visible = true,
        base_value = LWCBaseValue("price", 0),
        top_fill_color1 = "rgba(38, 166, 154, 0.28)",
        top_fill_color2 = "rgba(38, 166, 154, 0.05)",
        top_line_color = "rgba(38, 166, 154, 1)",
        bottom_fill_color1 = "rgba(239, 83, 80, 0.05)",
        bottom_fill_color2 = "rgba(239, 83, 80, 0.28)",
        bottom_line_color = "rgba(239, 83, 80, 1)",
        line_style = LWC_LARGE_DASHED,
        line_width = 3,
        precision = 3,
        crosshair_marker_visible = false,
        crosshair_marker_radius = 2.0,
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
        id = baseline_chart.id,
        label_name = "baseline",
        label_color = "rgba(38, 166, 154, 0.28)",
        type = "addBaselineSeries",
        settings = LightweightCharts.Charts.BaseLineChartSettings(
            LWC_RIGHT,
            "baseline",
            true,
            3,
            LWCBaseValue("price", 0),
            "rgba(38, 166, 154, 0.28)",
            "rgba(38, 166, 154, 0.05)",
            "rgba(38, 166, 154, 1)",
            "rgba(239, 83, 80, 0.05)",
            "rgba(239, 83, 80, 0.28)",
            "rgba(239, 83, 80, 1)",
            3,
            LWC_LARGE_DASHED,
            LWC_SIMPLE,
            true,
            false,
            4.0,
            false,
            2.0,
            "",
            "",
            2.0,
        ),
        data = LWCChartData([
            LWCSimpleChartData(1680086570373_000000, 1.0),
            LWCSimpleChartData(1680086571373_000000, 5.0),
            LWCSimpleChartData(1680086572373_000000, 2.0),
            LWCSimpleChartData(1680086573373_000000, 3.0),
            LWCSimpleChartData(1680086574373_000000, 4.0),
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
                )
            )
        ]),
    )

    @test baseline_chart == result
end

@testset "BaseLine2" begin
    baseline_chart = lwc_baseline(
        Vector{Tuple{DateTime,Real}}([
            (DateTime("2023-03-29T10:42:50.373"), 1),
            (DateTime("2023-03-29T10:42:51.373"), 5),
            (DateTime("2023-03-29T10:42:52.373"), 2),
            (DateTime("2023-03-29T10:42:53.373"), 3),
            (DateTime("2023-03-29T10:42:54.373"), 4),
        ]);
        label_name = "baseline",
        price_scale_id = LWC_RIGHT,
        visible = true,
        base_value = LWCBaseValue("price", 0),
        top_fill_color1 = "rgba(38, 166, 154, 0.28)",
        top_fill_color2 = "rgba(38, 166, 154, 0.05)",
        top_line_color = "rgba(38, 166, 154, 1)",
        bottom_fill_color1 = "rgba(239, 83, 80, 0.05)",
        bottom_fill_color2 = "rgba(239, 83, 80, 0.28)",
        bottom_line_color = "rgba(239, 83, 80, 1)",
        line_style = LWC_LARGE_DASHED,
        line_width = 3,
        precision = 3,
        crosshair_marker_visible = false,
        crosshair_marker_radius = 2.0,
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
        id = baseline_chart.id,
        label_name = "baseline",
        label_color = "rgba(38, 166, 154, 0.28)",
        type = "addBaselineSeries",
        settings = LightweightCharts.Charts.BaseLineChartSettings(
            LWC_RIGHT,
            "baseline",
            true,
            3,
            LWCBaseValue("price", 0),
            "rgba(38, 166, 154, 0.28)",
            "rgba(38, 166, 154, 0.05)",
            "rgba(38, 166, 154, 1)",
            "rgba(239, 83, 80, 0.05)",
            "rgba(239, 83, 80, 0.28)",
            "rgba(239, 83, 80, 1)",
            3,
            LWC_LARGE_DASHED,
            LWC_SIMPLE,
            true,
            false,
            4.0,
            false,
            2.0,
            "",
            "",
            2.0,
        ),
        data = LWCChartData([
            LWCSimpleChartData(1680086570373_000000, 1.0),
            LWCSimpleChartData(1680086571373_000000, 5.0),
            LWCSimpleChartData(1680086572373_000000, 2.0),
            LWCSimpleChartData(1680086573373_000000, 3.0),
            LWCSimpleChartData(1680086574373_000000, 4.0),
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
                )
            )
        ]),
    )

    @test baseline_chart == result
end
