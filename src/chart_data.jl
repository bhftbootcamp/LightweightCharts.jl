module LWCChartData

export lwc_time,
    lwc_value,
    lwc_open,
    lwc_high,
    lwc_close,
    lwc_low,
    lwc_convert_data,
    lwc_convert_data!

export LWCSimpleChartData,
    LWCCandle

using Dates
using Serde
using NanoDates

using ..LightweightCharts

mutable struct LWCSimpleChartData <: AbstractChartData
    time::Int64
    value::Float64
end

Serde.SerJson.ser_value(::Type{<:AbstractChartData}, ::Val{:time}, x::Int64) = string(x)

lwc_time(x::LWCSimpleChartData) = x.time
lwc_value(x::LWCSimpleChartData) = x.value

function Base.:(==)(left::LWCSimpleChartData, right::LWCSimpleChartData)
    return isequal(lwc_time(left), lwc_time(right)) &&
           isequal(lwc_value(left), lwc_value(right))
end

"""
    LWCCandle(time::Real, open::Real, high::Real, low::Real, close::Real)
    LWCCandle(time::TimeType, open::Real, high::Real, low::Real, close::Real)

Representation of candlestick data for [`lwc_candlestick`](@ref) and [`lwc_bar`](@ref) methods.

## Fields
- `time::Int64`
- `open::Float64`
- `high::Float64`
- `low::Float64`
- `close::Float64`
"""
mutable struct LWCCandle <: AbstractChartData
    time::Int64
    open::Float64
    high::Float64
    low::Float64
    close::Float64

    function LWCCandle(time::Real, open::Real, high::Real, low::Real, close::Real)
        return new(time, open, high, low, close)
    end

    function LWCCandle(time::TimeType, open::Real, high::Real, low::Real, close::Real)
        return LWCCandle(datetime2epochns(time), open, high, low, close)
    end
end

lwc_time(x::LWCCandle) = x.time
lwc_open(x::LWCCandle) = x.open
lwc_high(x::LWCCandle) = x.high
lwc_low(x::LWCCandle) = x.low
lwc_close(x::LWCCandle) = x.close

function Base.:(==)(left::LWCCandle, right::LWCCandle)
    return (
        isequal(lwc_time(left), lwc_time(right)) &&
        isequal(lwc_open(left), lwc_open(right)) &&
        isequal(lwc_high(left), lwc_high(right)) &&
        isequal(lwc_low(left), lwc_low(right))   &&
        isequal(lwc_close(left), lwc_close(right))
    )
end

const UNIXEPOCH_NS::Int128 = Dates.UNIXEPOCH * Int128(1_000_000)

datetime2epochns(x::DateTime)::Int64 = (Dates.value(x) - Dates.UNIXEPOCH) * 1_000_000
datetime2epochns(x::Date)::Int64     = datetime2epochns(DateTime(x))
datetime2epochns(x::NanoDate)::Int64 = Dates.value(x) - UNIXEPOCH_NS
datetime2epochns(x::Real)::Int64     = x * 1_000_000_000

function lwc_convert_data!(data::T)::T where {T<:AbstractVector{<:AbstractChartData}}
    sort!(data, by = lwc_time)
    unique!(lwc_time, data)
    return data
end

function lwc_convert_data(
    timearray::AbstractVector{Tuple{D,T}},
)::Vector{LWCSimpleChartData} where {D<:Union{Real,TimeType},T<:Real}
    data::Vector{LWCSimpleChartData} = [
        LWCSimpleChartData(datetime2epochns(datetime), value) for (datetime, value) in timearray
    ]
    return lwc_convert_data!(data)
end

function lwc_convert_data(
    timearray::AbstractVector{Tuple{D,O,H,L,C}},
)::Vector{LWCCandle} where {D<:Union{Real,TimeType},O<:Real,H<:Real,L<:Real,C<:Real}
    data::Vector{LWCCandle} = [
        LWCCandle(datetime2epochns(datetime), open, high, low, close) for (datetime, open, high, low, close) in timearray
    ]
    return lwc_convert_data!(data)
end

function lwc_convert_data(time::D)::Int64 where {D<:Union{Real,TimeType}}
    return datetime2epochns(time)
end

end
