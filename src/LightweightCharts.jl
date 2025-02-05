module LightweightCharts

export lwc_panel,
    lwc_layout,
    lwc_save,
    lwc_show

export lwc_line,
    lwc_baseline,
    lwc_histogram,
    lwc_area,
    lwc_candlestick,
    lwc_bar

export lwc_vert_line,
    lwc_delta_tooltip,
    lwc_trend_line,
    lwc_crosshair_highlight_bar,
    lwc_tooltip

export lwc_time,
    lwc_value,
    lwc_open,
    lwc_high,
    lwc_close,
    lwc_low

export AbstractChartItem,
    AbstractChartSettings,
    AbstractPluginSettings

export LWCChartData,
    LWCSimpleChartItem,
    LWCCandleChartItem,
    LWCChart,
    LWCPlugin,
    LWCPanel,
    LWCLayout,
    LWCBaseValue

export LWC_CHART_ID

export LWC_SIMPLE,
    LWC_STEP,
    LWC_CURVED

export LWC_SOLID,
    LWC_DOTTED,
    LWC_DASHED,
    LWC_LARGE_DASHED,
    LWC_SPARSE_DOTTED

export LWC_RIGHT,
    LWC_LEFT

export LWC_TOOLTIP_TYPE,
    LWC_TOOLTIP_TOP,
    LWC_TOOLTIP_TRACK

export LWC_NORMAL,
    LWC_LOGARITHMIC,
    LWC_PERCENTAGE,
    LWC_INDEXED_TO_100

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

using Dates
using NanoDates
using Serde

abstract type AbstractChartItem end
abstract type AbstractChartSettings end
abstract type AbstractPluginSettings end

const LWC_CHART_ID = Ref{Int64}(0)

include("color_utils.jl")

include("chart_data.jl")
using .ChartData

include("crosshair.jl")
using .Crosshair

"""
    LWCPlugin

Type containing information about chart active plugins.

See also: [`plugins`](@ref).
"""
Base.@kwdef struct LWCPlugin <: AbstractPluginSettings
    type::String
    settings::P where {P<:AbstractPluginSettings}
end

"""
    LWCChart

The base type that contains the necessary information for visualizing a single chart (and its [`plugins`](@ref)).

See also: [`lwc_show`](@ref), [`lwc_save`](@ref).
"""
Base.@kwdef struct LWCChart <: AbstractChartSettings
    id::Int64
    label_name::String
    label_color::String
    type::String
    settings::S where {S<:AbstractChartSettings}
    data::LWCChartData
    plugins::Vector{LWCPlugin}
end

function Base.show(io::IO, x::LWCChart)
    return println(io, "LightweightCharts.LWCChart($(x.label_name))")
end

function Base.show(io::IO, m::MIME"text/html", x::LWCChart)
    return write(io, string(x))
end

include("charts.jl")
using .Charts

include("plugins.jl")
using .Plugins

"""
    LWCPanel

A type that allows you to combine multiple charts for visualization.

See also: [`lwc_panel`](@ref).
"""
mutable struct LWCPanel <: AbstractChartSettings
    x::Int64
    y::Int64
    h::Float64
    name::String
    min_y::Union{Real,Nothing}
    left_min_y::Union{Real,Nothing}
    right_min_y::Union{Real,Nothing}
    max_y::Union{Real,Nothing}
    left_max_y::Union{Real,Nothing}
    right_max_y::Union{Real,Nothing}
    seconds_visible::Bool
    bar_spacing::Real
    min_bar_spacing::Real
    min_charts_for_search::Int64
    tooltip::Bool
    tooltip_format::String
    mode::LWC_PRICE_SCALE_MODE
    charts::Tuple{Vararg{LWCChart}}
    crosshair_settings::CrosshairOptions
    cursor::LWC_CURSOR
    last_value_visible::Bool
    title_visible::Bool
    default_labels_visible::Bool
end

function Base.show(io::IO, x::LWCPanel)
    return println(io, "LightweightCharts.LWCPanel($(x.name))")
end

function Base.show(io::IO, m::MIME"text/html", x::LWCPanel)
    return write(io, string(x))
end

"""
    lwc_panel(charts::LWCChart...; kw...) -> LWCPanel

Creates a panel combining several [`charts`](@ref charts).

## Keyword arguments
| Name::Type | Default/Possible values | Description |
|:-----------|:-----------------------|:------------|
| `x::Int64` | `-999` | Panel's horizontal coordinates |
| `y::Int64` | `-999` | Panel's vertical coordinates |
| `h::Float64` | `0.5` | Panel’s height as a fraction of the window height. |
| `name::String` |` ""` | Panel name (will be displayed in the browser tab title). |
| `min_y::Union{Real,Nothing}` | `nothing` | Lower bound on the y-axis. |
| `left_min_y::Union{Real,Nothing}` | `nothing` | Lower bound on the left y-axis. |
| `right_min_y::Union{Real,Nothing}` | `nothing` | Lower bound on the right y-axis. |
| `max_y::Union{Real,Nothing}` | `nothing` | Upper bound on the y-axis. |
| `left_max_y::Union{Real,Nothing}` | `nothing` | Upper bound on the left y-axis. |
| `right_max_y::Union{Real,Nothing}` | `nothing` | Upper bound on the right y-axis. |
| `seconds_visible::Bool` | `false` | Seconds visibility on the x-axis. |
| `bar_spacing::Real` | `6` | Distance between the stripes in pixels. |
| `min_bar_spacing::Real` | `0.5` | Minimum distance between the stripes in pixels. |
| `tooltip::Bool` | true | Enables tooltip for points. |
| `tooltip_format::String` | `"\${label_name}: (\${time}, \${value})"` | String formatting of tooltip text. Display the variables "title", "time" and "value" in the desired format. |
| `min_charts_for_search` | `10` | Minimum number of charts to search. |
| `mode::LWC_PRICE_SCALE_MODE` | `0` | Price scale mode. |
| `crosshair_settings::CrosshairOptions` | `CrosshairOptions()` | Structure describing crosshair options. |
| `cursor::LWC_CURSOR` | `LWC_CURSOR_DEFAUL` | Cursor type. |
| `last_value_visible::Bool` | `false` | Shows the latest price label on the price scale. |
| `title_visible::Bool` | `false` | Shows the chart name next to the latest price label. |
| `default_legend_visible::Bool` | `true` | Shows the legend box with data charts names and colors. |
"""
function lwc_panel(
    charts::LWCChart...;
    x::Int64 = -999,
    y::Int64 = -999,
    h::Float64 = 0.5,
    name::String = "",
    min_y::Union{Real,Nothing} = nothing,
    left_min_y::Union{Real,Nothing} = nothing,
    right_min_y::Union{Real,Nothing} = nothing,
    max_y::Union{Real,Nothing} = nothing,
    left_max_y::Union{Real,Nothing} = nothing,
    right_max_y::Union{Real,Nothing} = nothing,
    seconds_visible::Bool = false,
    bar_spacing::Real = 6,
    min_bar_spacing::Real = 0.5,
    tooltip::Bool = true,
    tooltip_format::String = "\${label_name}: (\${time}, \${value})",
    min_charts_for_search::Int64 = 10,
    mode::LWC_PRICE_SCALE_MODE = LWC_NORMAL,
    crosshair_settings::CrosshairOptions = CrosshairOptions(),
    cursor::LWC_CURSOR = LWC_CURSOR_DEFAULT,
    last_value_visible::Bool = false,
    title_visible::Bool = false,
    default_legend_visible::Bool = true,
)
    return LWCPanel(
        x,
        y,
        h,
        name,
        min_y,
        left_min_y,
        right_min_y,
        max_y,
        left_max_y,
        right_max_y,
        seconds_visible,
        bar_spacing,
        min_bar_spacing,
        min_charts_for_search,
        tooltip,
        tooltip_format,
        mode,
        charts,
        crosshair_settings,
        cursor,
        last_value_visible,
        title_visible,
        default_legend_visible
    )
end

"""
    LWCLayout

Type describing the layout for arranging multiple panels.

See also: [`lwc_layout`](@ref).
"""
mutable struct LWCLayout <: AbstractChartSettings
    name::String
    sync::Bool
    min_height::Integer
    resizable::Bool
    panels::Dict{String,LWCPanel}
end

function Base.show(io::IO, x::LWCLayout)
    return println(io, "LightweightCharts.LWCLayout($(x.name))")
end

function Base.show(io::IO, m::MIME"text/html", x::LWCLayout)
    return write(io, string(x))
end

function update_not_set_coords!(panels::Tuple{Vararg{LWCPanel}})
    prev_y = 0
    for panel in panels
        if panel.y < 0
            panel.y = prev_y + 1
        end
        if panel.x < 0
            panel.x = max(map(p -> p.x, filter(p -> (p.y == panel.y), panels))..., 0) + 1
        end
        prev_y = panel.y
    end
    xy = map(p -> (p.x, p.y), panels)
    @assert length(Set(xy)) === length(xy) "has duplicate panel"
end

"""
    lwc_layout(panels::LWCPanel...; kw...) -> LWCLayout

Combines multiple `panels` into a common layout.

## Keyword arguments
| Name::Type | Default (Possible) values | Description |
|:-----------|:-----------------------|:------------|
| `name::String` | `"LightweightCharts ❤️ Julia"` | Layout name (will be displayed in the browser tab title). |
| `sync::Bool` | `true` | Synchronization of chart scrolling. |
| `min_height::Integer` | `300` | Minimum of layout height in px. |
| `resizable::Bool` | true | Enables resize mode of panels.  |
"""
function lwc_layout(
    panels::LWCPanel...;
    name::String = "LightweightCharts ❤️ Julia",
    sync::Bool = true,
    min_height::Integer = 300,
    resizable::Bool = true,
)
    update_not_set_coords!(panels)

    setX = Set(map(panel -> panel.x, panels))
    setY = Set(map(panel -> panel.y, panels))

    @assert setX == Set(minimum(setX):maximum(setX)) "incorrect order of the X-axis numbers"
    @assert setY == Set(minimum(setY):maximum(setY)) "incorrect order of the Y-axis numbers"

    maxX = lcm(setX...)
    maxY = length(setY)

    areas = Matrix{String}(undef, maxY, maxX)
    grids = Dict{String,LWCPanel}()

    for (column, row) in enumerate(eachrow(areas))
        cols::Int64 = count(panel -> panel.y == column, panels)
        step::Int64 = maxX ÷ cols
        iden::Int64 = 1

        for index = 1:maxX
            cell = string("cell", iden, column)
            row[index] = cell

            panel = findfirst(panel -> panel.x == iden && panel.y == column, panels)
            grids[cell] = panels[panel]

            if index % step == 0
                iden += 1
            end
        end
    end

    return LWCLayout(name, sync, min_height, resizable, grids)
end

function Base.string(chart::LWCChart)
    return string(lwc_layout(lwc_panel(chart, h = 1.0), name = chart.label_name))
end

function Base.string(panel::LWCPanel)
    return string(lwc_layout(panel, name = panel.name))
end

function Base.string(layout::LWCLayout)
    html   = read(joinpath(@__DIR__, "..", "frontend", "dist", "lightweightcharts.html"), String)
    bundle = read(joinpath(@__DIR__, "..", "frontend", "dist", "index_boundle.js"), String)
    return replace(
        html,
        Regex("{{\\s*(bundle)\\s*}}") => bundle,
        Regex("{{\\s*(layout)\\s*}}") => "\'$(Serde.to_json(layout))\'",
    )
end

function to_camelcase(x::String)
    w = split(x, "_")
    return if length(w) > 1
        w[1] * join(titlecase.(w[2:end]))
    else
        x
    end
end

function to_camelcase(x::Symbol)
    return Symbol(to_camelcase(string(x)))
end

function Base.propertynames(x::AbstractChartSettings)
    n = fieldnames(typeof(x))
    return to_camelcase.(n)
end

function Serde.SerJson.ser_name(::Type{A}, ::Val{T}) where {A<:AbstractChartItem,T}
    return to_camelcase(T)
end

function Serde.SerJson.ser_name(::Type{A}, ::Val{T}) where {A<:AbstractChartSettings,T}
    return to_camelcase(T)
end

function Serde.SerJson.ser_name(::Type{A}, ::Val{T}) where {A<:AbstractPluginSettings,T}
    return to_camelcase(T)
end

function is_wsl()
    Sys.islinux() &&
    isfile("/proc/sys/kernel/osrelease") &&
    occursin(r"Microsoft|WSL"i, read("/proc/sys/kernel/osrelease", String))
end

function open_browser(url::String)
    if Sys.isapple()
        Base.run(`open $url`)
        true
    elseif is_wsl()
        path_for_wsl = chomp(read(`wslpath -w $url`, String))
        run(`wslview $path_for_wsl`)
        true
    elseif Sys.islinux()
        Base.run(`xdg-open $url`)
        true
    elseif Sys.iswindows()
        Base.run(`powershell.exe Start "'$url'"`)
        true
    else
        false
    end
end

"""
    lwc_save(filepath::String, plt)

Saves a chart `plt` by the `filepath` (the preferred saved file extension is `html`).

See also [`lwc_show`](@ref).
"""
function lwc_save(filepath::String, plt)
    write(filepath, string(plt))
    return filepath
end

"""
    lwc_show(plt; filepath = joinpath(homedir(), "lightweightcharts.html"))

Saves a chart `plt` by the `filepath` and then displays it in the browser.

See also [`lwc_save`](@ref).
"""
function lwc_show(plt; filepath = joinpath(homedir(), "lightweightcharts.html"))
    return open_browser(lwc_save(filepath, plt))
end

end