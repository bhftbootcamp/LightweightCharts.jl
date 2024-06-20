# charts/baseline
# https://LightweightCharts.github.io/lightweight-charts/docs/api/interfaces/BaselineStyleOptions

struct LWCBaseValue
    type::String
    price::Float64
end

struct BaseLineChartSettings <: AbstractChartSettings
    price_scale_id::LWC_PRICE_SCALE_ID
    title::String
    visible::Bool
    precision::Int64
    base_value::LWCBaseValue
    top_fill_color1::String
    top_fill_color2::String
    top_line_color::String
    bottom_fill_color1::String
    bottom_fill_color2::String
    bottom_line_color::String
    line_width::Int64
    line_style::LWC_LINE_STYLES
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
    lwc_baseline(Vector{LWCSimpleChartItem}; kw...) -> LWCChart

Creates a [`LWCChart`](@ref) object that contains line chart information.
A general method that allows you to customize each chart node using [`LWCSimpleChartItem`](@ref).

Wrapper function for [`Baseline`](https://tradingview.github.io/lightweight-charts/docs/series-types#baseline).

## Keyword arguments
| Name::Type | Default (Possible values) | Description |
|:-----------|:-------------------------|:------------|
| `price_scale_id::LWC_PRICE_SCALE_ID` | `LWC_LEFT` (`LWC_RIGHT`) | Y-axis display side. |
| `label_name::String` | `""` | Chart name. |
| `visible::Bool` | `true` | Chart visibility. |
| `precision::Int64` | `2` | Number of decimal places for y-axis values. |
| `base_value::LWCBaseValue` | `LWCBaseValue("price", 0.0)` | The value relative to which larger or smaller values will be colored in the appropriate color. |
| `top_fill_color1::String` | `"rgba(38, 166, 154, 0.28)"` | The first color of the upper area. |
| `top_fill_color2::String` | `"rgba(38, 166, 154, 0.05)"` | The second color of the upper area. |
| `top_line_color::String` | `"rgba(38, 166, 154, 1)"` | Color of the upper area line. |
| `bottom_fill_color1::String` | `"rgba(239, 83, 80, 0.05)"` | The first color of the lower area. |
| `bottom_fill_color2::String` | `"rgba(239, 83, 80, 0.28)"` | The second color of the lower area. |
| `bottom_line_color::String` | `"rgba(239, 83, 80, 1)"` | Color of the lower area line. |
| `line_width::Int64` | `1` | Line width. |
| `line_style::LWC_LINE_STYLES` | `LWC_SOLID` (`LWC_DOTTED`, `LWC_DASHED`, `LWC_LARGE_DASHED`, `LWC_SPARSE_DOTTED`) | Line style. |
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
function lwc_baseline(
    data::AbstractVector{LWCSimpleChartItem};
    price_scale_id::LWC_PRICE_SCALE_ID = LWC_LEFT,
    label_name::String = "",
    visible::Bool = true,
    precision::Int64 = 2,
    base_value::LWCBaseValue = LWCBaseValue("price", 0.0),
    top_fill_color1::String = "rgba(38, 166, 154, 0.28)",
    top_fill_color2::String = "rgba(38, 166, 154, 0.05)",
    top_line_color::String = "rgba(38, 166, 154, 1)",
    bottom_fill_color1::String = "rgba(239, 83, 80, 0.05)",
    bottom_fill_color2::String = "rgba(239, 83, 80, 0.28)",
    bottom_line_color::String = "rgba(239, 83, 80, 1)",
    line_width::Int64 = 1,
    line_style::LWC_LINE_STYLES = LWC_SOLID,
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
    settings = BaseLineChartSettings(
        price_scale_id,
        label_name,
        visible,
        precision,
        base_value,
        top_fill_color1,
        top_fill_color2,
        top_line_color,
        bottom_fill_color1,
        bottom_fill_color2,
        bottom_line_color,
        line_width,
        line_style,
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
        label_color = top_fill_color1,
        type = "addBaselineSeries",
        settings = settings,
        data = data,
        plugins = plugins,
    )
end

"""
    lwc_baseline(timestamps::Vector{TimeType}, values::Vector{Real}; kw...) -> LWCChart
    lwc_baseline(timestamps::Vector{Real}, values::Vector{Real}; kw...) -> LWCChart
    
Creates a [`LWCChart`](@ref) from the passed `timestamps` and `values`.
"""
function lwc_baseline(
    timestamps::AbstractVector{<:Union{Real,TimeType}},
    values::AbstractVector{<:Real};
    kw...,
)::LWCChart
    return lwc_baseline(to_lwc_data(LWCSimpleChartItem, timestamps, values); kw...)
end

"""
    lwc_baseline(data::Vector{Tuple{TimeType,Real}}; kw...) -> LWCChart
    lwc_baseline(data::Vector{Tuple{Real,Real}}; kw...) -> LWCChart

Creates a [`LWCChart`](@ref) from the passed `data` that describes a vector of timestamps and values.
"""
function lwc_baseline(
    data::AbstractVector{Tuple{<:Union{Real,TimeType},<:Real}};
    kw...,
)::LWCChart
    return lwc_baseline(to_lwc_data(LWCSimpleChartItem, data); kw...)
end

"""
    lwc_baseline(values::Vector{Real}; kw...) -> LWCChart

Creates a [`LWCChart`](@ref) from the passed `values` (timestamps begin from `1970-01-01`).
"""
function lwc_baseline(values::AbstractVector{<:Real}; kw...)::LWCChart
    return lwc_baseline(to_lwc_data(LWCSimpleChartItem, values); kw...)
end

"""
    lwc_baseline(custom_data::Vector{Any}; kw...) -> LWCChart

Creates a [`LWCChart`](@ref) from the passed `custom_data`.

For more information see [Custom data](@ref custom_data) section.
"""
function lwc_baseline(data::AbstractVector; kw...)::LWCChart
    return lwc_baseline(to_lwc_data(LWCSimpleChartItem, data); kw...)
end