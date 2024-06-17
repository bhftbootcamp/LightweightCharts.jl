# charts/line
# https://LightweightCharts.github.io/lightweight-charts/docs/api/interfaces/LineStyleOptions

struct LineChartSettings <: AbstractChartSettings
    price_scale_id::LWC_PRICE_SCALE_ID
    title::String
    visible::Bool
    precision::Int64
    color::String
    line_style::LWC_LINE_STYLES
    line_width::Int64
    line_type::LWC_LINE_TYPES
    line_visible::Bool
    point_markers_visible::Bool
    point_markers_radius::Float64
    crosshair_marker_visible::Bool
    crosshair_marker_radius::Float64
    crosshair_marker_border_color::String
    crosshair_marker_background_color::String
    crosshair_marker_border_width::Float64
end

"""
    lwc_line([, timestamps], values::Vector{Real}; kw...) -> LWCChart
    lwc_line(Vector{LWCSimpleChartData}; kw...) -> LWCChart
    lwc_line(timearray::Vector; kw...) -> LWCChart

Creates a [`LWCChart`](@ref) object that contains line chart information.
The `timestamps` can be passed as `Vector{Integer}` of Unix time or `Vector{TimeType}`.
You can also use type [`LWCSimpleChartData`](@ref) for more flexible color settings.

Wrapper function for [`Line`](https://tradingview.github.io/lightweight-charts/docs/series-types#line).

!!! note
    You can use a `timearray` with custom type elements for which a [conversion method](https://docs.julialang.org/en/v1/base/base/#Base.convert) to types `Tuple{Real,Real}` or `Tuple{TimeType,Real}` is defined.

## Keyword arguments
| Name::Type | Default (Posible values) | Description |
|:-----------|:-------------------------|:------------|
| `price_scale_id::LWC_PRICE_SCALE_ID` | `LWC_LEFT` (`LWC_RIGHT`)| Y-axis display side. |
| `label_name::String` | `""` | Chart name. |
| `visible::Bool` | `true` | Chart visibility. |
| `precision::Int64` | `2` | Number of decimal places for y-axis values. |
| `line_color::String` | Random color | Line color. |
| `line_style::LWC_LINE_STYLES` | `LWC_SOLID` (`LWC_DOTTED`, `LWC_DASHED`, `LWC_LARGE_DASHED`, `LWC_SPARSE_DOTTED`) | Line style. |
| `line_width::Int64` | `1` | Line width. |
| `line_type::LWC_LINE_TYPES` | `LWC_SIMPLE` (`LWC_STEP`, `LWC_CURVED`) | Line type. |
| `line_visible::Bool` | `true` | Line visibility. |
| `point_markers_visible::Bool` | `false` | Displaying markers on line nodes. |
| `point_markers_radius::Float64` | `4.0` | Size of markers. |
| `crosshair_marker_visible::Bool` | `true` | Cursor crosshair visibility. |
| `crosshair_marker_radius::Float64` | `4.0` | Size of crosshair. |
| `crosshair_marker_border_color::String` | `"#758696"` | Border color of crosshair. |
| `crosshair_marker_background_color::String` | `"#4c525e"` | Background color of crosshair. |
| `crosshair_marker_border_width::Float64` | `2.0` | Border width of the crosshair. |
| `plugins::Vector{LWCPlugin}` | `LWCPlugin[]` | Additional plugins. |
"""
function lwc_line end

function lwc_line(
    data::AbstractVector{<:AbstractChartData};
    price_scale_id::LWC_PRICE_SCALE_ID = LWC_LEFT,
    label_name::String = "",
    visible::Bool = true,
    precision::Int64 = 2,
    line_color::String = randcolor(),
    line_style::LWC_LINE_STYLES = LWC_SOLID,
    line_width::Int64 = 1,
    line_type::LWC_LINE_TYPES = LWC_SIMPLE,
    line_visible::Bool = true,
    point_markers_visible::Bool = false,
    point_markers_radius::Float64 = 4.0,
    crosshair_marker_visible::Bool = true,
    crosshair_marker_radius::Float64 = 4.0,
    crosshair_marker_border_color::String = "",
    crosshair_marker_background_color::String = "",
    crosshair_marker_border_width::Float64 = 2.0,
    plugins::Vector{LWCPlugin} = Vector{LWCPlugin}(),
)::LWCChart
    settings = LineChartSettings(
        price_scale_id,
        label_name,
        visible,
        precision,
        line_color,
        line_style,
        line_width,
        line_type,
        line_visible,
        point_markers_visible,
        point_markers_radius,
        crosshair_marker_visible,
        crosshair_marker_radius,
        crosshair_marker_border_color,
        crosshair_marker_background_color,
        crosshair_marker_border_width,
    )

    return LWCChart(
        id = LWC_CHART_ID[] += 1,
        label_name = label_name,
        label_color = line_color,
        type = "addLineSeries",
        settings = settings,
        data = data,
        plugins = plugins,
    )
end

function lwc_line(
    timestamps::AbstractVector{D},
    values::AbstractVector{T};
    kw...
)::LWCChart where {D<:Union{Real,TimeType},T<:Real}
    data = prepare_data(timestamps, values)
    return lwc_line(data; kw...)
end

function lwc_line(
    values::AbstractVector{T};
    kw...
)::LWCChart where {T<:Real}
    data = prepare_data(values)
    return lwc_line(data; kw...)
end

function lwc_line(
    timearray::AbstractVector;
    kw...
)::LWCChart
    data = lwc_convert_data(timearray)
    return lwc_line(data; kw...)
end
