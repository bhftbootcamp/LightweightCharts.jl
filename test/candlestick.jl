# test/candlestick

@testset "Candlestick" begin
    candlestick_chart = lwc_candlestick(
        Vector{DateTime}([
            DateTime("2023-03-29T10:42:50.373"),
            DateTime("2023-03-29T10:42:51.373"),
            DateTime("2023-03-29T10:42:52.373"),
            DateTime("2023-03-29T10:42:53.373"),
            DateTime("2023-03-29T10:42:54.373"),
        ]),
        Vector{Real}([1, 5, 2, 3, 4]),
        Vector{Real}([1, 5, 2, 3, 4]),
        Vector{Real}([1, 5, 2, 3, 4]),
        Vector{Real}([1, 5, 2, 3, 4]);
        label_name = "OK.ICX-USDT",
        price_scale_id = LWC_LEFT,
        visible = true,
        precision = 5,
        up_color = "#26a69a",
        down_color = "#ef5350",
        wick_visible = true,
        border_visible = true,
        border_color = "#378658",
        border_up_color = "#26a69a",
        border_down_color = "#ef5350",
        wick_color = "#737375",
        wick_up_color = "#26a69a",
        wick_down_color = "#ef5350",
        plugins = [
            lwc_trend_line(
                20,
                0.5,
                120,
                0.7;
                line_color = "red",
            ),
        ],
    )

    result = LWCChart(;
        id = candlestick_chart.id,
        label_name = "OK.ICX-USDT",
        label_color = "#378658",
        type = "addCandlestickSeries",
        settings = LightweightCharts.Charts.CandlestickChartSettings(
            LWC_LEFT,
            "OK.ICX-USDT",
            true,
            5,
            "#26a69a",
            "#ef5350",
            true,
            true,
            "#378658",
            "#26a69a",
            "#ef5350",
            "#737375",
            "#26a69a",
            "#ef5350",
        ),
        data = LWCChartData([
            LWCCandle(1680086570373_000000, 1, 1, 1, 1),
            LWCCandle(1680086571373_000000, 5, 5, 5, 5),
            LWCCandle(1680086572373_000000, 2, 2, 2, 2),
            LWCCandle(1680086573373_000000, 3, 3, 3, 3),
            LWCCandle(1680086574373_000000, 4, 4, 4, 4),
        ]),
        plugins = Vector{LWCPlugin}([
            LWCPlugin(
                "addTrendLine",
                LightweightCharts.Plugins.TrendLineSettings(
                    LightweightCharts.Plugins.TrendPoint(20, 0.5),
                    LightweightCharts.Plugins.TrendPoint(120, 0.7),
                    "red",
                    6,
                    true,
                    "rgba(255, 255, 255, 0.85)",
                    "rgb(0, 0, 0)",
                )
            )
        ]),
    )

    @test candlestick_chart == result
end

@testset "Candlestick2" begin
    candlestick_chart = lwc_candlestick(
        Vector{Tuple{DateTime,Real,Real,Real,Real}}([
            (DateTime("2023-03-29T10:42:50.373"), 1, 1, 1, 1),
            (DateTime("2023-03-29T10:42:51.373"), 5, 5, 5, 5),
            (DateTime("2023-03-29T10:42:52.373"), 2, 2, 2, 2),
            (DateTime("2023-03-29T10:42:53.373"), 3, 3, 3, 3),
            (DateTime("2023-03-29T10:42:54.373"), 4, 4, 4, 4),
        ]);
        label_name = "OK.ICX-USDT",
        price_scale_id = LWC_LEFT,
        visible = true,
        precision = 5,
        up_color = "#26a69a",
        down_color = "#ef5350",
        wick_visible = true,
        border_visible = true,
        border_color = "#378658",
        border_up_color = "#26a69a",
        border_down_color = "#ef5350",
        wick_color = "#737375",
        wick_up_color = "#26a69a",
        wick_down_color = "#ef5350",
        plugins = [
            lwc_trend_line(
                20,
                0.5,
                120,
                0.7;
                line_color = "red",
            ),
        ],
    )

    result = LWCChart(;
        id = candlestick_chart.id,
        label_name = "OK.ICX-USDT",
        label_color = "#378658",
        type = "addCandlestickSeries",
        settings = LightweightCharts.Charts.CandlestickChartSettings(
            LWC_LEFT,
            "OK.ICX-USDT",
            true,
            5,
            "#26a69a",
            "#ef5350",
            true,
            true,
            "#378658",
            "#26a69a",
            "#ef5350",
            "#737375",
            "#26a69a",
            "#ef5350",
        ),
        data = LWCChartData([
            LWCCandle(1680086570373_000000, 1, 1, 1, 1),
            LWCCandle(1680086571373_000000, 5, 5, 5, 5),
            LWCCandle(1680086572373_000000, 2, 2, 2, 2),
            LWCCandle(1680086573373_000000, 3, 3, 3, 3),
            LWCCandle(1680086574373_000000, 4, 4, 4, 4),
        ]),
        plugins = Vector{LWCPlugin}([
            LWCPlugin(
                "addTrendLine",
                LightweightCharts.Plugins.TrendLineSettings(
                    LightweightCharts.Plugins.TrendPoint(20, 0.5),
                    LightweightCharts.Plugins.TrendPoint(120, 0.7),
                    "red",
                    6,
                    true,
                    "rgba(255, 255, 255, 0.85)",
                    "rgb(0, 0, 0)",
                )
            )
        ]),
    )

    @test candlestick_chart == result
end