# plugins/vertical_line

struct VertLineSettings <: AbstractPluginSettings
    index::Int64
    color::String
    label_text::String
    width::Float64
    label_background_color::String
    label_text_color::String
    show_label::Bool
end

"""
    lwc_vert_line(index::Int64; kw...) -> LWCPlugin

Adds a vertical line based on `index` to the chart.

## Keyword arguments
| Name::Type | Default (Posible values) | Description |
|:-----------|:-------------------------|:------------|
| `label_text::String` | `""` | Vertical line label. |
| `width::Float64` | `3.0` | Vertical line width. |
| `color::String` | Random color | Color of the vertical line. |
| `label_background_color::String` | Random color | Label background color. |
| `label_text_color::String` | `"white"` | Label text color. |
| `show_label::Bool` | `false` |  Label visibility. |
"""
function lwc_vert_line(
    index::Int64;
    color::String = randcolor(),
    label_text::String = "",
    width::Float64 = 3.0,
    label_background_color::String = randcolor(),
    label_text_color::String = "white",
    show_label::Bool = false,
)::LWCPlugin
    settings = VertLineSettings(
        index,
        color,
        label_text,
        width,
        label_background_color,
        label_text_color,
        show_label
    )

    return LWCPlugin(
        "addVertLine",
        settings
    )
end
