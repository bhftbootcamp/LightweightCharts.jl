# test/histogram

@testset "LWCSimpleChartData(::Int64, ::Real)" begin
    @test LWCSimpleChartData(1680086570373_000000, 1.0) ==
          LWCSimpleChartData(1680086570373_000000, 1.0)
end

@testset "Histogram" begin
    histogram_chart = lwc_histogram(
        Vector{DateTime}([
            DateTime("2023-03-29T10:42:50.373"),
            DateTime("2023-03-29T10:42:51.373"),
            DateTime("2023-03-29T10:42:52.373"),
            DateTime("2023-03-29T10:42:53.373"),
            DateTime("2023-03-29T10:42:54.373"),
        ]),
        Vector{Real}([1, 5, 2, 3, 4]);
        label_name = "histogram",
        price_scale_id = LWC_LEFT,
        visible = true,
        color = "blue",
        precision = 2,
        base = 0.0,
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
        id = histogram_chart.id,
        label_name = "histogram",
        label_color = "blue",
        type = "addHistogramSeries",
        settings = LightweightCharts.Charts.HistogramChartSettings(
            LWC_LEFT,
            "histogram",
            true,
            2,
            "blue",
            0.0,
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

    @test histogram_chart == result
end

@testset "Histogram2" begin
    histogram_chart = lwc_histogram(
        Vector{Tuple{DateTime,Real}}([
            (DateTime("2023-03-29T10:42:50.373"), 1),
            (DateTime("2023-03-29T10:42:51.373"), 5),
            (DateTime("2023-03-29T10:42:52.373"), 2),
            (DateTime("2023-03-29T10:42:53.373"), 3),
            (DateTime("2023-03-29T10:42:54.373"), 4),
        ]);
        label_name = "histogram",
        price_scale_id = LWC_LEFT,
        visible = true,
        color = "blue",
        precision = 2,
        base = 0.0,
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
        id = histogram_chart.id,
        label_name = "histogram",
        label_color = "blue",
        type = "addHistogramSeries",
        settings = LightweightCharts.Charts.HistogramChartSettings(
            LWC_LEFT,
            "histogram",
            true,
            2,
            "blue",
            0.0,
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

    @test histogram_chart == result
end
