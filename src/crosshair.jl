module Crosshair

export LWC_CROSSHAIR_NORMAL,
    LWC_CROSSHAIR_MAGNET,
    LWC_CROSSHAIR_HIDDEN

export LWC_CROSSHAIR_SOLID,
    LWC_CROSSHAIR_DOTTED,
    LWC_CROSSHAIR_DASHED,
    LWC_CROSSHAIR_LARGE_DASHED,
    LWC_CROSSHAIR_SPARSE_DOTTED

export LWC_CURSOR,
    LWC_CURSOR_DEFAULT,
    LWC_CURSOR_CROSSHAIR

export CrosshairOptions,
    CrosshairLineOptions

using Serde

using ..LightweightCharts

@enum LWC_CROSSHAIR_MODE begin
    LWC_CROSSHAIR_NORMAL = 0
    LWC_CROSSHAIR_MAGNET = 1
    LWC_CROSSHAIR_HIDDEN = 2
end

@enum LWC_CROSSHAIR_LINE_STYLE begin
    LWC_CROSSHAIR_SOLID = 0
    LWC_CROSSHAIR_DOTTED = 1
    LWC_CROSSHAIR_DASHED = 2
    LWC_CROSSHAIR_LARGE_DASHED = 3
    LWC_CROSSHAIR_SPARSE_DOTTED = 4
end

@enum LWC_CURSOR begin
    LWC_CURSOR_DEFAULT = 0
    LWC_CURSOR_CROSSHAIR = 1
end

Serde.SerJson.ser_type(::Type{<:AbstractChartSettings}, x::LWC_CROSSHAIR_MODE) = Int64(x)
Serde.SerJson.ser_type(::Type{<:AbstractChartSettings}, x::LWC_CROSSHAIR_LINE_STYLE) = Int64(x)
Serde.SerJson.ser_type(::Type{<:AbstractChartSettings}, x::LWC_CURSOR) = x == LWC_CURSOR_DEFAULT ? "default" : "crosshair"

"""
    CrosshairLineOptions(; kw...)

Structure describing a crosshair line (vertical or horizontal).

## Keyword arguments
| Name::Type | Default (Possible values) | Description |
|:-----------|:-------------------------|:------------|
| `color::String` | `'#758696'` | Crosshair line color. |
| `width::Int64` | `1` | Crosshair line width. |
| `style::LWC_CROSSHAIR_LINE_STYLE` | `LWC_CROSSHAIR_LARGE_DASHED` | Crosshair line style. |
| `visible::Bool` | `true` | Display the crosshair line. |
| `label_visible::Bool` | `true` | Display the crosshair label on the relevant scale. |
| `label_background_color::String` | `'#4c525e'` | Crosshair label background color. |
"""
struct CrosshairLineOptions <: AbstractChartSettings
    color::String
    width::Int64 
    style::LWC_CROSSHAIR_LINE_STYLE
    visible::Bool
    label_visible::Bool 
    label_background_color::String 

    function CrosshairLineOptions(;
        color::String = "#758696",
        width::Int64 = 1,
        style::LWC_CROSSHAIR_LINE_STYLE = LWC_CROSSHAIR_LARGE_DASHED,
        visible::Bool = true,
        label_visible::Bool = true,
        label_background_color::String = "#4c525e",
    )
        return new(
            color,
            width,
            style,
            visible,
            label_visible,
            label_background_color,
        )
    end
end

"""
    CrosshairOptions(; kw...)

Structure describing crosshair options.

## Keyword arguments
| Name::Type | Default (Possible values) | Description |
|:-----------|:-------------------------|:------------|
| `mode::LWC_CROSSHAIR_MODE` | `LWC_CROSSHAIR_MAGNET` | Crosshair mode. |
| `vert_line::CrosshairLineOptions` | `CrosshairLineOptions()` | Vertical line options. |
| `horz_line::CrosshairLineOptions` | `CrosshairLineOptions()` | Horizontal line options. |
"""
struct CrosshairOptions <: AbstractChartSettings
    mode::LWC_CROSSHAIR_MODE
    vert_line::CrosshairLineOptions 
    horz_line::CrosshairLineOptions 
    
    function CrosshairOptions(;
        mode::LWC_CROSSHAIR_MODE = LWC_CROSSHAIR_MAGNET,
        vert_line::CrosshairLineOptions = CrosshairLineOptions(),
        horz_line::CrosshairLineOptions = CrosshairLineOptions(),
    )
        return new(
            mode,
            vert_line,
            horz_line,
        )
    end
end

end