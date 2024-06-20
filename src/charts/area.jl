# charts/area
# https://LightweightCharts.github.io/lightweight-charts/docs/api/interfaces/AreaStyleOptions

struct AreaChartSettings <: AbstractChartSettings
    price_scale_id::LWC_PRICE_SCALE_ID
    title::String
    visible::Bool
    precision::Int64
    top_color::String
    bottom_color::String
    invert_filled_area::Bool
    line_color::String
    line_style::LWC_LINE_STYLES
    line_width::Int64
    line_type::LWC_LINE_TYPES
    point_markers_visible::Bool
    point_markers_radius::Float64
    crosshair_marker_visible::Bool
    crosshair_marker_radius::Float64
    crosshair_marker_border_color::String
    crosshair_marker_background_color::String
    crosshair_marker_border_width::Float64
end

"""
    lwc_area(Vector{LWCSimpleChartItem}; kw...) -> LWCChart

Creates a [`LWCChart`](@ref) object that contains line chart information.
A general method that allows you to customize each chart node using [`LWCSimpleChartItem`](@ref).

Wrapper function for [`Area`](https://tradingview.github.io/lightweight-charts/docs/series-types#area).

## Keyword arguments
| Name::Type | Default (Possible values) | Description |
|:-----------|:-------------------------|:------------|
| `price_scale_id::LWC_PRICE_SCALE_ID` | `LWC_LEFT` (`LWC_RIGHT`) | Y-axis display side. |
| `label_name::String` | `""` | Chart name. |
| `visible::Bool` | `true` | Chart visibility. |
| `precision::Int64` | `2` | Number of decimal places for y-axis values. |
| `top_color::String` | `"rgba(46, 220, 135, 0.4)"` | Color of the upper part of the area. |
| `bottom_color::String` | `"rgba(40, 221, 100, 0)"` | Color of the lower part of the area. |
| `invert_filled_area::Bool` | `false` | Inverted display of colors. |
| `line_color::String` | Random color | Line color. |
| `line_style::LWC_LINE_STYLES` | `LWC_SOLID` (`LWC_DOTTED`, `LWC_DASHED`, `LWC_LARGE_DASHED`, `LWC_SPARSE_DOTTED`) | Line style. |
| `line_width::Int64` | `1` | Line width. |
| `line_type::LWC_LINE_TYPES` | `LWC_SIMPLE` (`LWC_SIMPLE`, `LWC_STEP`, `LWC_CURVED`) | Line type. |
| `point_markers_visible::Bool` | `false` | Displaying markers on line nodes. |
| `point_markers_radius::Float64` | `4.0` | Size of markers. |
| `crosshair_marker_visible::Bool` | `true` | Cursor crosshair visibility. |
| `crosshair_marker_radius::Float64` | `4.0` | Size of crosshair. |
| `crosshair_marker_border_color::String` | `"#758696"` | Border color of crosshair. |
| `crosshair_marker_background_color::String` | `"#4c525e"` | Background color of crosshair. |
| `crosshair_marker_border_width::Float64` | `2.0` | Border width of the crosshair. |
| `plugins::Vector{LWCPlugin}` | `LWCPlugin[]` | Additional plugins. |
"""
function lwc_area(
    data::AbstractVector{LWCSimpleChartItem};
    price_scale_id::LWC_PRICE_SCALE_ID = LWC_LEFT,
    label_name::String = "",
    visible::Bool = true,
    precision::Int64 = 2,
    top_color::String = "rgba(46, 220, 135, 0.4)",
    bottom_color::String = "rgba(40, 221, 100, 0)",
    invert_filled_area::Bool = false,
    line_color::String = randcolor(),
    line_style::LWC_LINE_STYLES = LWC_SOLID,
    line_width::Int64 = 1,
    line_type::LWC_LINE_TYPES = LWC_SIMPLE,
    point_markers_visible::Bool = false,
    point_markers_radius::Float64 = 4.0,
    crosshair_marker_visible::Bool = true,
    crosshair_marker_radius::Float64 = 4.0,
    crosshair_marker_border_color::String = "",
    crosshair_marker_background_color::String = "",
    crosshair_marker_border_width::Float64 = 2.0,
    plugins::Vector{LWCPlugin} = Vector{LWCPlugin}(),
)::LWCChart
    settings = AreaChartSettings(
        price_scale_id,
        label_name,
        visible,
        precision,
        top_color,
        bottom_color,
        invert_filled_area,
        line_color,
        line_style,
        line_width,
        line_type,
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
        type = "addAreaSeries",
        settings = settings,
        data = data,
        plugins = plugins,
    )
end

"""
    lwc_area(timestamps::Vector{TimeType}, values::Vector{Real}; kw...) -> LWCChart
    lwc_area(timestamps::Vector{Real}, values::Vector{Real}; kw...) -> LWCChart
    
Creates a [`LWCChart`](@ref) from the passed `timestamps` and `values`.
"""
function lwc_area(
    timestamps::AbstractVector{<:Union{Real,TimeType}},
    values::AbstractVector{<:Real};
    kw...,
)::LWCChart
    return lwc_area(to_lwc_data(LWCSimpleChartItem, timestamps, values); kw...)
end

"""
    lwc_area(data::Vector{Tuple{TimeType,Real}}; kw...) -> LWCChart
    lwc_area(data::Vector{Tuple{Real,Real}}; kw...) -> LWCChart

Creates a [`LWCChart`](@ref) from the passed `data` that describes a vector of timestamps and values.
"""
function lwc_area(
    data::AbstractVector{Tuple{<:Union{Real,TimeType},<:Real}};
    kw...,
)::LWCChart
    return lwc_area(to_lwc_data(LWCSimpleChartItem, data); kw...)
end

"""
    lwc_area(values::Vector{Real}; kw...) -> LWCChart

Creates a [`LWCChart`](@ref) from the passed `values` (timestamps begin from `1970-01-01`).
"""
function lwc_area(values::AbstractVector{<:Real}; kw...)::LWCChart
    return lwc_area(to_lwc_data(LWCSimpleChartItem, values); kw...)
end

"""
    lwc_area(custom_data::Vector{Any}; kw...) -> LWCChart

Creates a [`LWCChart`](@ref) from the passed `custom_data`.

For more information see [Custom data](@ref custom_data) section.
"""
function lwc_area(data::AbstractVector; kw...)::LWCChart
    return lwc_area(to_lwc_data(LWCSimpleChartItem, data); kw...)
end