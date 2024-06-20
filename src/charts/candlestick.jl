# charts/candlestick
# https://LightweightCharts.github.io/lightweight-charts/docs/api/interfaces/CandlestickStyleOptions

struct CandlestickChartSettings <: AbstractChartSettings
    price_scale_id::LWC_PRICE_SCALE_ID
    title::String
    visible::Bool
    precision::Int64
    up_color::String
    down_color::String
    wick_visible::Bool
    border_visible::Bool
    border_color::String
    border_up_color::String
    border_down_color::String
    wick_color::String
    wick_up_color::String
    wick_down_color::String
end

"""
    lwc_candlestick(data::Vector{LWCCandleChartItem}; kw...) -> LWCChart

Creates a [`LWCChart`](@ref) object that contains candlesticks chart information.
A general method that allows you to customize each chart node using [`LWCCandleChartItem`](@ref).

Wrapper function for [`Candlestick`](https://tradingview.github.io/lightweight-charts/docs/series-types#candlestick).

## Keyword arguments
| Name::Type | Default (Possible values) | Description |
|:-----------|:-------------------------|:------------|
| `price_scale_id::LWC_PRICE_SCALE_ID` | `LWC_LEFT` (`LWC_RIGHT`) | Y-axis display side. |
| `label_name::String` | `""` | Chart name. |
| `visible::Bool` | `true` | Chart visibility. |
| `precision::Int64` | `2` | Number of decimal places for y-axis values. |
| `up_color::String` | `"#26a69a"` | Color of bullish candle (increasing). |
| `down_color::String` | `"#ef5350"` | Color of bearish candle (decreasing). |
| `wick_visible::Bool` | `true` | Wick visibility. |
| `border_visible::Bool` | `true` | Candle borders visibility. |
| `border_color::String` | `"#378658"` | Candle border color. |
| `border_up_color::String` | `"#26a69a"` | Boder color of bullish candle. |
| `border_down_color::String` | `"#ef5350"` | Boder color of bearish candle. |
| `wick_color::String` | `"#737375"` | Wick color. |
| `wick_up_color::String` | `"#26a69a"` | Wick color of bullish candle. |
| `wick_down_color::String` | `"#ef5350"` | Wick color of bearish candle. |
| `plugins::Vector{LWCPlugin}` | `LWCPlugin[]` | Additional plugins. |
"""
function lwc_candlestick(
    data::AbstractVector{LWCCandleChartItem};
    price_scale_id::LWC_PRICE_SCALE_ID = LWC_LEFT,
    label_name::String = "",
    visible::Bool = true,
    precision::Int64 = 2,
    up_color::String = "#26a69a",
    down_color::String = "#ef5350",
    wick_visible::Bool = true,
    border_visible::Bool = true,
    border_color::String = "#378658",
    border_up_color::String = "#26a69a",
    border_down_color::String = "#ef5350",
    wick_color::String = "#737375",
    wick_up_color::String = "#26a69a",
    wick_down_color::String = "#ef5350",
    plugins::Vector{LWCPlugin} = Vector{LWCPlugin}(),
)::LWCChart
    settings = CandlestickChartSettings(
        price_scale_id,
        label_name,
        visible,
        precision,
        up_color,
        down_color,
        wick_visible,
        border_visible,
        border_color,
        border_up_color,
        border_down_color,
        wick_color,
        wick_up_color,
        wick_down_color,
    )

    return LWCChart(
        id = LWC_CHART_ID[] += 1,
        label_name = label_name,
        label_color = border_color,
        type = "addCandlestickSeries",
        settings = settings,
        data = data,
        plugins = plugins,
    )
end

"""
    lwc_candlestick(arg...; kw...) -> LWCChart

Creates a [`LWCChart`](@ref) from the passed `arg` that describes the corresponding candlestick values.

## Arguments
- `timestamps::Vector{Union{Real,TimeType}}`
- `open::Vector{Real}`
- `high::Vector{Real}`
- `low::Vector{Real}`
- `close::Vector{Real}`
"""
function lwc_candlestick(
    timestamps::AbstractVector{<:Union{Real,TimeType}},
    open::AbstractVector{<:Real},
    high::AbstractVector{<:Real},
    low::AbstractVector{<:Real},
    close::AbstractVector{<:Real};
    kw...,
)::LWCChart
    return lwc_candlestick(
        to_lwc_data(LWCCandleChartItem, timestamps, open, high, low, close);
        kw...,
    )
end

"""
    lwc_candlestick(data::Vector{Tuple{D,O,H,L,C}}; kw...) -> LWCChart

Creates a [`LWCChart`](@ref) from the passed `data` that describes a vector of candles.
Here `D` is a `Real` or `TimeType` and `O,H,L,C` are `Real`s.
"""
function lwc_candlestick(
    data::AbstractVector{Tuple{D,O,H,L,C}};
    kw...,
)::LWCChart where {D<:Union{Real,TimeType},O<:Real,H<:Real,L<:Real,C<:Real}
    return lwc_candlestick(to_lwc_data(LWCCandleChartItem, data); kw...)
end

"""
    lwc_candlestick(custom_data::Vector{Any}; kw...) -> LWCChart

Creates a [`LWCChart`](@ref) from the passed `custom_data`.

For more information see [Custom data](@ref custom_data) section.
"""
function lwc_candlestick(data::AbstractVector; kw...)::LWCChart
    return lwc_candlestick(to_lwc_data(LWCCandleChartItem, data); kw...)
end
