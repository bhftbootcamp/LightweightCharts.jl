module LWCChartData

export lwc_time,
    lwc_value,
    lwc_open,
    lwc_high,
    lwc_close,
    lwc_low

export LWCSimpleChartData,
    LWCCandle

using Dates
using Serde
using NanoDates

using ..LightweightCharts

"""
    LWCSimpleChartData(time::Int64, value::Real; kw...)
    LWCSimpleChartData(time::TimeType, value::Real; kw...)

This data type allows you to customize the colors for each point of your chart.
Supported for [`lwc_line`](@ref), [`lwc_area`](@ref), [`lwc_baseline`](@ref) and [`lwc_histogram`](@ref) methods.

## Fields
- `time::Int64`: Data unix time.
- `value::Float64`: Data value.

## Keyword arguments
| Name::Type | Default (Posible values) | Description |
|:-----------|:-------------------------|:------------|
| `line_color::String` | `nothing` | Line color. |
| `top_color::String` | `nothing` | Top color. |
| `bottom_color::String` | `nothing` | Bottom color. |
| `top_fill_color_1::String` | `nothing` | Top fill color 1. |
| `top_fill_color_2::String` | `nothing` | Top fill color 2. |
| `top_line_color::String` | `nothing` | Top line color. |
| `bottom_fill_color_1::String` | `nothing` | Bottom fill color 1. |
| `bottom_fill_color_2::String` | `nothing` | Bottom fill color 2. |
| `bottom_line_color::String` | `nothing` | Bottom line color. |
| `color::String` | `nothing` | Color. |
"""
mutable struct LWCSimpleChartData <: AbstractChartData
    time::Int64
    value::Float64
    line_color::Union{String,Nothing}
    top_color::Union{String,Nothing}
    bottom_color::Union{String,Nothing}
    top_fill_color_1::Union{String,Nothing}
    top_fill_color_2::Union{String,Nothing}
    top_line_color::Union{String,Nothing}
    bottom_fill_color_1::Union{String,Nothing}
    bottom_fill_color_2::Union{String,Nothing}
    bottom_line_color::Union{String,Nothing}
    color::Union{String,Nothing}

    function LWCSimpleChartData(
        time::Int64,
        value::Real;
        line_color::Union{String,Nothing} = nothing,
        top_color::Union{String,Nothing} = nothing,
        bottom_color::Union{String,Nothing} = nothing,
        top_fill_color_1::Union{String,Nothing} = nothing,
        top_fill_color_2::Union{String,Nothing} = nothing,
        top_line_color::Union{String,Nothing} = nothing,
        bottom_fill_color_1::Union{String,Nothing} = nothing,
        bottom_fill_color_2::Union{String,Nothing} = nothing,
        bottom_line_color::Union{String,Nothing} = nothing,
        color::Union{String,Nothing} = nothing,
    )
        return new(
            time,
            value,
            line_color,
            top_color,
            bottom_color,
            top_fill_color_1,
            top_fill_color_2,
            top_line_color,
            bottom_fill_color_1,
            bottom_fill_color_2,
            bottom_line_color,
            color,
        )
    end

    function LWCSimpleChartData(
        time::TimeType,
        value::Real;
        kw...
    )
        return LWCSimpleChartData(
            datetime2epochns(time),
            value;
            kw...
        )
    end
end

Serde.SerJson.ser_value(::Type{<:AbstractChartData}, ::Val{:time}, x::Int64) = string(x)

lwc_time(x::LWCSimpleChartData) = x.time
lwc_value(x::LWCSimpleChartData) = x.value
lwc_line_color(x::LWCSimpleChartData) = x.line_color
lwc_top_color(x::LWCSimpleChartData) = x.top_color
lwc_bottom_color(x::LWCSimpleChartData) = x.bottom_color
lwc_top_fill_color_1(x::LWCSimpleChartData) = x.top_fill_color_1
lwc_top_fill_color_2(x::LWCSimpleChartData) = x.top_fill_color_2
lwc_top_line_color(x::LWCSimpleChartData) = x.top_line_color
lwc_bottom_fill_color_1(x::LWCSimpleChartData) = x.bottom_fill_color_1
lwc_bottom_fill_color_2(x::LWCSimpleChartData) = x.bottom_fill_color_2
lwc_bottom_line_color(x::LWCSimpleChartData) = x.bottom_line_color
lwc_color(x::LWCSimpleChartData) = x.color

function Base.:(==)(left::LWCSimpleChartData, right::LWCSimpleChartData)
    return isequal(lwc_time(left), lwc_time(right)) &&
        isequal(lwc_value(left), lwc_value(right))
end

"""
    LWCCandle(time::Int64, open::Real, high::Real, low::Real, close::Real; kw...)
    LWCCandle(time::TimeType, open::Real, high::Real, low::Real, close::Real; kw...)

Representation of candlestick data for [`lwc_candlestick`](@ref) and [`lwc_bar`](@ref) methods.

## Fields
- `time::Int64`
- `open::Float64`
- `high::Float64`
- `low::Float64`
- `close::Float64`

## Keyword arguments
| Name::Type | Default (Posible values) | Description |
|:-----------|:-------------------------|:------------|
| `color::String` | `nothing` | Candle color. |
| `border_color::String` | `nothing` | Border color. |
| `wick_color::String` | `nothing` | Wick color. |
"""
mutable struct LWCCandle <: AbstractChartData
    time::Int64
    open::Float64
    high::Float64
    low::Float64
    close::Float64
    color::Union{String,Nothing}
    border_color::Union{String,Nothing}
    wick_color::Union{String,Nothing}

    function LWCCandle(
        time::Int64,
        open::Real,
        high::Real,
        low::Real,
        close::Real;
        color::Union{String,Nothing} = nothing,
        border_color::Union{String,Nothing} = nothing,
        wick_color::Union{String,Nothing} = nothing,
    )
        return new(
            time,
            open,
            high,
            low,
            close,
            color,
            border_color,
            wick_color,
        )
    end

    function LWCCandle(
        time::TimeType,
        open::Real,
        high::Real,
        low::Real,
        close::Real;
        kw...
    )
        return LWCCandle(
            datetime2epochns(time),
            open,
            high,
            low,
            close;
            kw...
        )
    end
end

lwc_time(x::LWCCandle) = x.time
lwc_open(x::LWCCandle) = x.open
lwc_high(x::LWCCandle) = x.high
lwc_low(x::LWCCandle) = x.low
lwc_close(x::LWCCandle) = x.close
lwc_color(x::LWCCandle) = x.color
lwc_border_color(x::LWCCandle) = x.border_color
lwc_wick_color(x::LWCCandle) = x.wick_color

function Base.:(==)(left::LWCCandle, right::LWCCandle)
    return (
        isequal(lwc_time(left), lwc_time(right)) &&
        isequal(lwc_open(left), lwc_open(right)) &&
        isequal(lwc_high(left), lwc_high(right)) &&
        isequal(lwc_low(left), lwc_low(right))   &&
        isequal(lwc_close(left), lwc_close(right))
    )
end

const UNIXEPOCH_NS = Dates.UNIXEPOCH * Int128(1_000_000)

datetime2epochns(x::DateTime)::Int64 = (Dates.value(x) - Dates.UNIXEPOCH) * 1_000_000
datetime2epochns(x::Date)::Int64     = datetime2epochns(DateTime(x))
datetime2epochns(x::NanoDate)::Int64 = Dates.value(x) - UNIXEPOCH_NS
datetime2epochns(x::Real)::Int64     = x * 1_000_000_000

end
