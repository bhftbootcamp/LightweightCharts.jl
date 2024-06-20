# plugins/tooltip

struct TooltipSubSettings <: AbstractPluginSettings
    title::String
    follow_mode::LWC_TOOLTIP_TYPE
    horizontal_deadzone_width::Int64
    vertical_deadzone_height::Int64
    vertical_spacing::Int64
    top_offset::Int64
end

struct TooltipSettings <: AbstractPluginSettings
    line_color::String
    tooltip::TooltipSubSettings
end

"""
    lwc_vert_line(; kw...) -> LWCPlugin

Adds a dynamic tooltip to the chart following the cursor and displaying the values.

## Keyword arguments
| Name::Type | Default (Possible values) | Description |
|:-----------|:-------------------------|:------------|
| `line_color::String` | `"rgba(0, 0, 0, 0.2)"` | Tooltip line color. |
| `title::String` | `""` | Tooltip title. |
| `follow_mode::LWC_TOOLTIP_TYPE` | `LWC_TOOLTIP_TOP` (`LWC_TOOLTIP_TRACK`) | Tooltip Location. |
| `horizontal_deadzone_width::Int64` | `45` |  |
| `vertical_deadzone_height::Int64` | `100` | Horizontal deadzone height. |
| `vertical_spacing::Int64` | `20` | Vertical spacing. |
| `top_offset::Int64` | `20` | Vertical offset for tooltip. |
"""
function lwc_tooltip(;
    line_color::String = "rgba(0, 0, 0, 0.2)",
    title::String = "",
    follow_mode::LWC_TOOLTIP_TYPE = LWC_TOOLTIP_TOP,
    horizontal_deadzone_width::Int64 = 45,
    vertical_deadzone_height::Int64 = 100,
    vertical_spacing::Int64 = 20,
    top_offset::Int64 = 20,
)::LWCPlugin
    settings = TooltipSettings(
        line_color,
        TooltipSubSettings(
            title,
            follow_mode,
            horizontal_deadzone_width,
            vertical_deadzone_height,
            vertical_spacing,
            top_offset,
        )
    )

    return LWCPlugin(
        "addTooltip",
        settings
    )
end
