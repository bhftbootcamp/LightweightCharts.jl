# examples/charts/06_candlesticks
#
# Run from the project root with the command
# julia --project=. examples/charts/06_candlesticks.jl

using Dates
using CryptoAPIs
using LightweightCharts
import LightweightCharts: randcolor

ohlc = CryptoAPIs.Binance.Spot.candle(;
    symbol = "ETHUSDT",
    interval = CryptoAPIs.Binance.Spot.Candle.d1,
    startTime = DateTime("2021-01-01"),
    endTime = DateTime("2023-09-27"),
    limit = 1000,
)

panel = lwc_panel(
    lwc_candlestick(
        map(
            x -> LWCCandle(
                x.openTime,
                x.openPrice,
                x.highPrice,
                x.lowPrice,
                x.closePrice;
                color = randcolor(),
                border_color = randcolor(),
                wick_color = randcolor(),
            ),
            ohlc.result,
        ),
        label_name = "lwc_candlestick",
        up_color = "#52a49a",
        down_color = "#de5e57",
        border_visible = false,
        price_scale_id = LWC_LEFT,
        plugins = [lwc_delta_tooltip()],
    ),
    lwc_histogram(
        map(x -> x.openTime, ohlc.result),
        map(x -> x.volume, ohlc.result);
        label_name = "lwc_histogram",
        base = -100.0,
        color = "rgba(47, 112, 181, 0.5)",
        price_scale_id = LWC_RIGHT,
    ),
    name = "ETHUSDT | Binance Spot",
)

lwc_show(panel)