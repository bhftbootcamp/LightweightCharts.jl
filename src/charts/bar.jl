# charts/bar
# https://LightweightCharts.github.io/lightweight-charts/docs/api/interfaces/BarStyleOptions

struct BarChartSettings <: AbstractChartSettings
    price_scale_id::LWC_PRICE_SCALE_ID
    title::String
    visible::Bool
    precision::Int64
    up_color::String
    down_color::String
    open_visible::Bool
    thin_bars::Bool
end

"""
    wc_bar(data::Vector{LWCCandle}; kw...) -> LWCChart

Creates a [`LWCChart`](@ref) object that contains candlesticks chart information.

Wrapper function for [`Bar`](https://tradingview.github.io/lightweight-charts/docs/series-types#bar).

## Keyword arguments
| Name::Type | Default (Posible values) | Description |
|:-----------|:-------------------------|:------------|
| `price_scale_id::LWC_PRICE_SCALE_ID` | `LWC_LEFT` (`LWC_RIGHT`) | Y-axis display side. |
| `label_name::String` | `""` | Chart name. |
| `visible::Bool` | `true` | Chart visibility. |
| `precision::Int64` | `2` | Number of decimal places for y-axis values. |
| `up_color::String` | `"#26a69a"` | Color of bullish candle (increasing). |
| `down_color::String` | `"#ef5350"` | Color of bearish candle (decreasing). |
| `open_visible::Bool` | `true` | Open tick visibility. |
| `thin_bars::Bool` | `true` | Thin bars. |
| `plugins::Vector{LWCPlugin}` | `LWCPlugin[]` | Additional plugins.  |
"""
function lwc_bar(
    data::AbstractVector{LWCCandle};
    price_scale_id::LWC_PRICE_SCALE_ID = LWC_LEFT,
    label_name::String = "",
    visible::Bool = true,
    precision::Int64 = 2,
    up_color::String = randcolor(),
    down_color::String = randcolor(),
    open_visible::Bool = true,
    thin_bars::Bool = true,
    plugins::Vector{LWCPlugin} = Vector{LWCPlugin}(),
)::LWCChart

    settings = BarChartSettings(
        price_scale_id,
        label_name,
        visible,
        precision,
        up_color,
        down_color,
        open_visible,
        thin_bars,
    )

    return LWCChart(
        id = LWC_CHART_ID[] += 1,
        label_name = label_name,
        label_color = up_color,
        type = "addBarSeries",
        settings = settings,
        data = data,
        plugins = plugins,
    )
end

"""
    wc_bar(data::Vector{Tuple{D,O,H,L,C}}; kw...) -> LWCChart

Takes a single vector with tuples containing the corresponding candlestick values.
Here `D` is a `Real` or `TimeType` and `O,H,L,C` are `Real`s.
"""
function lwc_bar(
    data::AbstractVector{Tuple{D,O,H,L,C}};
    kw...
)::LWCChart where {D<:Union{Real,TimeType},O<:Real,H<:Real,L<:Real,C<:Real}
    return lwc_bar(wrap_data(data); kw...)
end

"""
    lwc_bar(arg...; kw...) -> LWCChart

Takes as input individual vectors with the corresponding candlestick values.

## Arguments
- `timestamps::Vector{Union{Real,TimeType}}`
- `open::Vector{Real}`
- `high::Vector{Real}`
- `low::Vector{Real}`
- `close::Vector{Real}`
"""
function lwc_bar(
    timestamps::Vector{D},
    open::Vector{O},
    high::Vector{H},
    low::Vector{L},
    close::Vector{C};
    kw...
)::LWCChart where {D<:Union{Real,TimeType},O<:Real,H<:Real,L<:Real,C<:Real}
    data = normalize_data(timestamps, open, high, low, close)
    return lwc_bar(wrap_data(data); kw...)
end
