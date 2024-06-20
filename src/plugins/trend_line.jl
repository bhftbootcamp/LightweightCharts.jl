# plugins/trend_line

struct TrendPoint <: AbstractPluginSettings
    index::Int64
    price::Float64
end

struct TrendLineSettings <: AbstractPluginSettings
    point1::TrendPoint
    point2::TrendPoint
    line_color::String
    width::Int64
    show_labels::Bool
    label_background_color::String
    label_text_color::String
end

"""
    lwc_trend_line(start_index, start_price, end_index, end_price; kw...) -> LWCPlugin

Adds a trend line to the chart starting with `start_index` and `start_price` and ending with `end_index` and `end_price`.

## Keyword arguments
| Name::Type | Default (Possible values) | Description |
|:-----------|:-------------------------|:------------|
| `line_color::String` | Random color | Line color. |
| `width::Int64` | `6` | Line width. |
| `show_labels::Bool` |  `true` | Labels visibility. |
| `label_background_color::String` | `"rgba(255, 255, 255, 0.85)"` |  Label background color. |
| `label_text_color::String` | `"rgb(0, 0, 0)"` | Label text color. |
"""
function lwc_trend_line(
    start_index::Int64,
    start_price::Float64,
    end_index::Int64,
    end_price::Float64;
    line_color::String = randcolor(),
    width::Int64 = 6,
    show_labels::Bool =  true,
    label_background_color::String = "rgba(255, 255, 255, 0.85)",
    label_text_color::String = "rgb(0, 0, 0)",
)::LWCPlugin
    settings = TrendLineSettings(
        TrendPoint(start_index, start_price),
        TrendPoint(end_index, end_price),
        line_color,
        width,
        show_labels,
        label_background_color,
        label_text_color,
    )

    return LWCPlugin(
        "addTrendLine",
        settings
    )
end
