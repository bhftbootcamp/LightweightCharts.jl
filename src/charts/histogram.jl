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
    lwc_histogram(data::Vector{Tuple{Union{TimeType,Real},Real}}; kw...) -> LWCChart
    lwc_histogram([, timestamps], values::Vector{Real}; kw...) -> LWCChart
    lwc_histogram(Vector{LWCSimpleChartData}; kw...) -> LWCChart
    lwc_histogram(custom_data::Vector; kw...) -> LWCChart

Creates a [`LWCChart`](@ref) object that contains histogram chart information.
The `timestamps` can be passed as `Vector{Integer}` of Unix time or `Vector{TimeType}`.
You can also use type [`LWCSimpleChartData`](@ref) for more flexible color settings.

Wrapper function for [`Histogram`](https://tradingview.github.io/lightweight-charts/docs/series-types#histogram).

!!! note
    You can use a `custom_data` with custom type elements for which is defined a [conversion method](https://docs.julialang.org/en/v1/base/base/#Base.convert) to type `Tuple` with two elements: `timestamp::Union{TimeType,Real}` and `value::Real`.

## Keyword arguments
| Name::Type | Default (Posible values) | Description |
|:-----------|:-------------------------|:------------|
| `price_scale_id::LWC_PRICE_SCALE_ID` | `LWC_LEFT` (`LWC_RIGHT`) | Y-axis display side. |
| `label_name::String` | `""` | Chart name. |
| `visible::Bool` | `true` | Chart visibility. |
| `precision::Int64` | `2` | Number of decimal places for y-axis values. |
| `color::String` | Random color | Histogram color. |
| `base::Real` | `0.0` | The value relative to which the larger or smaller histogram values will be located. |
| `plugins::Vector{LWCPlugin}` | `LWCPlugin[]` | Additional plugins. |
"""
function lwc_histogram end

function lwc_histogram(
    data::AbstractVector{<:AbstractChartData};
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
        data = LWCChartData(data),
        plugins = plugins,
    )
end

function lwc_histogram(
    data::AbstractVector{Tuple{D,T}};
    kw...
)::LWCChart where {D<:Union{Real,TimeType},T<:Real}
    return lwc_histogram(convert(Vector{LWCSimpleChartData}, data); kw...)
end

function lwc_histogram(
    timestamps::AbstractVector{D},
    values::AbstractVector{T};
    kw...
)::LWCChart where {D<:Union{Real,TimeType},T<:Real}
    return lwc_histogram(prepare_data(timestamps, values); kw...)
end

function lwc_histogram(
    values::AbstractVector{T};
    kw...
)::LWCChart where {T<:Real}
    return lwc_histogram(prepare_data(values); kw...)
end

function lwc_histogram(
    custom_data::AbstractVector;
    kw...
)::LWCChart
    return lwc_histogram(prepare_data(custom_data); kw...)
end
