# charts/histogram
# https://LightweightCharts.github.io/lightweight-charts/docs/api/interfaces/HistogramStyleOptions

struct HistogramChartSettings <: AbstractChartSettings
    price_scale_id::LWC_PRICE_SCALE_ID
    title::String
    visible::Bool
    precision::Int64
    color::String
    base::Real
end

"""
    lwc_histogram(Vector{LWCSimpleChartItem}; kw...) -> LWCChart

Creates a [`LWCChart`](@ref) object that contains line chart information.
A general method that allows you to customize each chart node using [`LWCSimpleChartItem`](@ref).

Wrapper function for [`Histogram`](https://tradingview.github.io/lightweight-charts/docs/series-types#histogram).

## Keyword arguments
| Name::Type | Default (Possible values) | Description |
|:-----------|:-------------------------|:------------|
| `price_scale_id::LWC_PRICE_SCALE_ID` | `LWC_LEFT` (`LWC_RIGHT`) | Y-axis display side. |
| `label_name::String` | `""` | Chart name. |
| `visible::Bool` | `true` | Chart visibility. |
| `precision::Int64` | `2` | Number of decimal places for y-axis values. |
| `color::String` | Random color | Histogram color. |
| `base::Real` | `0.0` | The value relative to which the larger or smaller histogram values will be located. |
| `plugins::Vector{LWCPlugin}` | `LWCPlugin[]` | Additional plugins. |
"""
function lwc_histogram(
    data::AbstractVector{LWCSimpleChartItem};
    price_scale_id::LWC_PRICE_SCALE_ID = LWC_LEFT,
    label_name::String = "",
    visible::Bool = true,
    precision::Int64 = 2,
    color::String = randcolor(),
    base::Real = 0.0,
    plugins::Vector{LWCPlugin} = Vector{LWCPlugin}(),
)::LWCChart
    settings = HistogramChartSettings(
        price_scale_id,
        label_name,
        visible,
        precision,
        color,
        base,
    )

    return LWCChart(
        id = LWC_CHART_ID[] += 1,
        label_name = label_name,
        label_color = color,
        type = "addHistogramSeries",
        settings = settings,
        data = data,
        plugins = plugins,
    )
end

"""
    lwc_histogram(timestamps::Vector{TimeType}, values::Vector{Real}; kw...) -> LWCChart
    lwc_histogram(timestamps::Vector{Real}, values::Vector{Real}; kw...) -> LWCChart
    
Creates a [`LWCChart`](@ref) from the passed `timestamps` and `values`.
"""
function lwc_histogram(
    timestamps::AbstractVector{<:Union{Real,TimeType}},
    values::AbstractVector{<:Real};
    kw...,
)::LWCChart
    return lwc_histogram(to_lwc_data(LWCSimpleChartItem, timestamps, values); kw...)
end

"""
    lwc_histogram(data::Vector{Tuple{TimeType,Real}}; kw...) -> LWCChart
    lwc_histogram(data::Vector{Tuple{Real,Real}}; kw...) -> LWCChart

Creates a [`LWCChart`](@ref) from the passed `data` that describes a vector of timestamps and values.
"""
function lwc_histogram(
    data::AbstractVector{Tuple{<:Union{Real,TimeType},<:Real}};
    kw...,
)::LWCChart
    return lwc_histogram(to_lwc_data(LWCSimpleChartItem, data); kw...)
end

"""
    lwc_histogram(values::Vector{Real}; kw...) -> LWCChart

Creates a [`LWCChart`](@ref) from the passed `values` (timestamps begin from `1970-01-01`).
"""
function lwc_histogram(values::AbstractVector{<:Real}; kw...)::LWCChart
    return lwc_histogram(to_lwc_data(LWCSimpleChartItem, values); kw...)
end

"""
    lwc_histogram(custom_data::Vector{Any}; kw...) -> LWCChart

Creates a [`LWCChart`](@ref) from the passed `custom_data`.

For more information see [Custom data](@ref custom_data) section.
"""
function lwc_histogram(data::AbstractVector; kw...)::LWCChart
    return lwc_histogram(to_lwc_data(LWCSimpleChartItem, data); kw...)
end
