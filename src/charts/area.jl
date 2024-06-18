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
    lwc_area(data::Vector{Tuple{Union{TimeType,Real},Real}}; kw...) -> LWCChart
    lwc_area([, timestamps], values::Vector{Real}; kw...) -> LWCChart
    lwc_area(Vector{LWCSimpleChartData}; kw...) -> LWCChart
    lwc_area(custom_data::Vector; kw...) -> LWCChart

Creates a [`LWCChart`](@ref) object that contains area chart information.
The `timestamps` can be passed as `Vector{Integer}` of Unix time or `Vector{TimeType}`.
You can also use type [`LWCSimpleChartData`](@ref) for more flexible color settings.

Wrapper function for [`Area`](https://tradingview.github.io/lightweight-charts/docs/series-types#area).

!!! note
    You can use a `custom_data` with custom type elements for which is defined a [conversion method](https://docs.julialang.org/en/v1/base/base/#Base.convert) to type `Tuple` with two elements: `timestamp::Union{TimeType,Real}` and `value::Real`.

## Keyword arguments
| Name::Type | Default (Posible values) | Description |
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
function lwc_area end

function lwc_area(
    data::AbstractVector{<:AbstractChartData};
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
        data = LWCChartData(data),
        plugins = plugins,
    )
end

function lwc_area(
    data::AbstractVector{Tuple{D,T}};
    kw...
)::LWCChart where {D<:Union{Real,TimeType},T<:Real}
    return lwc_area(convert(Vector{LWCSimpleChartData}, data); kw...)
end

function lwc_area(
    timestamps::AbstractVector{D},
    values::AbstractVector{T};
    kw...
)::LWCChart where {D<:Union{Real,TimeType},T<:Real}
    return lwc_area(prepare_data(timestamps, values); kw...)
end

function lwc_area(
    values::AbstractVector{T};
    kw...
)::LWCChart where {T<:Real}
    return lwc_area(prepare_data(values); kw...)
end

function lwc_area(
    custom_data::AbstractVector;
    kw...
)::LWCChart
    return lwc_area(prepare_data(custom_data); kw...)
end