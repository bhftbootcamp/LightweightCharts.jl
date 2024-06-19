module ChartData

export lwc_time,
    lwc_value,
    lwc_open,
    lwc_high,
    lwc_close,
    lwc_low

export LWCChartData,
    LWCSimpleChartItem,
    LWCCandleChartItem

export to_lwc_data,
    prepare_data

using Dates
using Serde
using NanoDates

using ..LightweightCharts

"""
    LWCSimpleChartItem(time::Int64, value::Real; kw...)
    LWCSimpleChartItem(time::TimeType, value::Real; kw...)

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
mutable struct LWCSimpleChartItem <: AbstractChartData
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

    function LWCSimpleChartItem(
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

    function LWCSimpleChartItem(
        time::TimeType,
        value::Real;
        kw...
    )
        return LWCSimpleChartItem(
            datetime2epochns(time),
            value;
            kw...
        )
    end
end

lwc_time(x::LWCSimpleChartItem) = x.time
lwc_value(x::LWCSimpleChartItem) = x.value
lwc_line_color(x::LWCSimpleChartItem) = x.line_color
lwc_top_color(x::LWCSimpleChartItem) = x.top_color
lwc_bottom_color(x::LWCSimpleChartItem) = x.bottom_color
lwc_top_fill_color_1(x::LWCSimpleChartItem) = x.top_fill_color_1
lwc_top_fill_color_2(x::LWCSimpleChartItem) = x.top_fill_color_2
lwc_top_line_color(x::LWCSimpleChartItem) = x.top_line_color
lwc_bottom_fill_color_1(x::LWCSimpleChartItem) = x.bottom_fill_color_1
lwc_bottom_fill_color_2(x::LWCSimpleChartItem) = x.bottom_fill_color_2
lwc_bottom_line_color(x::LWCSimpleChartItem) = x.bottom_line_color
lwc_color(x::LWCSimpleChartItem) = x.color

Serde.SerJson.ser_value(::Type{<:AbstractChartData}, ::Val{:time}, x::Int64) = string(x)

function Base.:(==)(left::LWCSimpleChartItem, right::LWCSimpleChartItem)
    return isequal(lwc_time(left), lwc_time(right)) &&
           isequal(lwc_value(left), lwc_value(right))
end

"""
    LWCCandleChartItem(time::Int64, open::Real, high::Real, low::Real, close::Real; kw...)
    LWCCandleChartItem(time::TimeType, open::Real, high::Real, low::Real, close::Real; kw...)

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
mutable struct LWCCandleChartItem <: AbstractChartData
    time::Int64
    open::Float64
    high::Float64
    low::Float64
    close::Float64
    color::Union{String,Nothing}
    border_color::Union{String,Nothing}
    wick_color::Union{String,Nothing}

    function LWCCandleChartItem(
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

    function LWCCandleChartItem(
        time::TimeType,
        open::Real,
        high::Real,
        low::Real,
        close::Real;
        kw...
    )
        return LWCCandleChartItem(
            datetime2epochns(time),
            open,
            high,
            low,
            close;
            kw...
        )
    end
end

lwc_time(x::LWCCandleChartItem) = x.time
lwc_open(x::LWCCandleChartItem) = x.open
lwc_high(x::LWCCandleChartItem) = x.high
lwc_low(x::LWCCandleChartItem) = x.low
lwc_close(x::LWCCandleChartItem) = x.close
lwc_color(x::LWCCandleChartItem) = x.color
lwc_border_color(x::LWCCandleChartItem) = x.border_color
lwc_wick_color(x::LWCCandleChartItem) = x.wick_color

function Base.:(==)(left::LWCCandleChartItem, right::LWCCandleChartItem)
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

to_lwc_data(::Type{LWCSimpleChartItem}, x::Any) = convert(Tuple, x)
to_lwc_data(::Type{LWCCandleChartItem}, x::Any) = convert(Tuple, x)

struct LWCChartData{T<:AbstractChartData} <: AbstractVector{T}
    data::Vector{T}

    function LWCChartData(data::AbstractVector{T}) where {T<:AbstractChartData}
        unique!(lwc_time, data)
        sort!(data; by = lwc_time)
        return new{T}(data)
    end
end

Base.size(x::LWCChartData) = size(x.data)
Base.length(x::LWCChartData) = length(x.data)
Base.getindex(x::LWCChartData, i::Integer) = getindex(x.data, i)

function Base.convert(::Type{LWCChartData{T}}, data::LWCChartData{T}) where {T<:AbstractChartData}
    return data
end

function Base.convert(::Type{LWCChartData{T}}, data::AbstractVector{T}) where {T<:AbstractChartData}
    return LWCChartData(data)
end

function Base.convert(::Type{T}, x::T) where {T<:AbstractChartData}
    return x
end

function Base.convert(::Type{T}, x::Any) where {T<:AbstractChartData}
    return convert(T, to_lwc_data(T, x))
end

function Base.convert(::Type{T}, x::Tuple) where {T<:AbstractChartData}
    throw(ErrorException("Incorrect conversion from custom type object to Tuple."))
end

function Base.convert(
    ::Type{LWCSimpleChartItem},
    x::Tuple{D,T},
) where {D<:Union{TimeType,Real},T<:Real}
    timestamp, value = x
    return LWCSimpleChartItem(timestamp, value)
end

function Base.convert(
    ::Type{LWCCandleChartItem},
    x::Tuple{D,O,H,L,C},
) where {D<:Union{Real,TimeType},O<:Real,H<:Real,L<:Real,C<:Real}
    timestamp, open, high, low, close = x
    return LWCCandleChartItem(timestamp, open, high, low, close)
end

function Base.convert(::Type{LWCChartData{T}}, data::AbstractVector) where {T<:AbstractChartData}
    return LWCChartData(map(item -> convert(T, item), data))
end

function prepare_data(data::AbstractVector)
    return data
end

function prepare_data(
    timestamps::AbstractVector{D},
    values::AbstractVector{T},
) where {D<:Union{Real,TimeType},T<:Real}
    @assert length(timestamps) === length(values) "length(timestamps) ≠ length(values)"
    return map(timestamps, values) do timestamp, value
        return (timestamp, value)
    end
end

function prepare_data(values::AbstractVector{<:Real})
    return map(enumerate(values)) do item
        i, value = item
        return (DateTime(1970) + Second(i), value)
    end
end

function prepare_data(
    timestamps::AbstractVector{<:Union{Real,TimeType}},
    open::AbstractVector{<:Real},
    high::AbstractVector{<:Real},
    low::AbstractVector{<:Real},
    close::AbstractVector{<:Real}
)
    @assert length(timestamps) === length(open)  "length(timestamps) ≠ length(open)"
    @assert length(timestamps) === length(high)  "length(timestamps) ≠ length(high)"
    @assert length(timestamps) === length(low)   "length(timestamps) ≠ length(low)"
    @assert length(timestamps) === length(close) "length(timestamps) ≠ length(close)"

    return map(timestamps, open, high, low, close) do t, o, h, l, c
        return (t, o, h, l, c)
    end
end

end
