# plugins/delta_tooltip

struct DeltaTooltipSettings <: AbstractPluginSettings
    line_color::String
    show_time::Bool
    top_offset::Int64
end

"""
    lwc_vert_line(; kw...) -> LWCPlugin

Adds a dynamic tooltip to the chart following the cursor and displaying the values (and their change, while holding down the mouse button).

## Keyword arguments
| Name::Type | Default (Possible values) | Description |
|:-----------|:-------------------------|:------------|
| `line_color::String` | `"rgba(0, 0, 0, 0.2)"` | Line color. |
| `show_time::Bool` | `false` | Detailed time display. |
| `top_offset::Int64` | `20` | Vertical offset for tooltip. |
"""
function lwc_delta_tooltip(;
    line_color::String = "rgba(0, 0, 0, 0.2)",
    show_time::Bool = false,
    top_offset::Int64 = 20,
)::LWCPlugin
    settings = DeltaTooltipSettings(
        line_color,
        show_time,
        top_offset
    )

    return LWCPlugin(
        "addDeltaTooltip",
        settings
    )
end
