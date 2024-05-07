module LWCCharts

export lwc_line,
    lwc_baseline,
    lwc_histogram,
    lwc_area,
    lwc_candlestick,
    lwc_bar

export LWCBaseValue

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

export LWC_DISABLED,
    LWC_CONTINUOUS,
    LWC_UPDATE

using Serde
using Dates

using ..LightweightCharts
import ..randcolor

@enum LWC_LINE_TYPES begin
    LWC_SIMPLE = 0
    LWC_STEP = 1
    LWC_CURVED = 2
end

@enum LWC_LINE_STYLES begin
    LWC_SOLID = 0
    LWC_DOTTED = 1
    LWC_DASHED = 2
    LWC_LARGE_DASHED = 3
    LWC_SPARSE_DOTTED = 4
end

@enum LWC_PRICE_SCALE_ID begin
    LWC_RIGHT = 0
    LWC_LEFT = 1
end

@enum LWC_LAST_PRICE_ANIMATION_MODE begin
    LWC_DISABLED = 0
    LWC_CONTINUOUS = 1
    LWC_UPDATE = 2
end

Serde.SerJson.ser_type(::Type{A}, x::LWC_LINE_TYPES) where {A<:AbstractChartSettings} = Int64(x)

Serde.SerJson.ser_type(::Type{A}, x::LWC_LINE_STYLES) where {A<:AbstractChartSettings} = Int64(x)

Serde.SerJson.ser_type(::Type{A}, x::LWC_PRICE_SCALE_ID) where {A<:AbstractChartSettings} = x == LWC_RIGHT ? "right" : "left"

function prepare_data(
    timestamps::Vector{D},
    values::Vector{T};
)::Vector{Tuple{D,T}} where {D<:Union{Real,TimeType},T<:Real}
    @assert length(timestamps) === length(values) "length(timestamps) != length(values)"
    return collect(zip(timestamps, values))
end

function prepare_data(
    timestamps::Vector{D},
    open::Vector{O},
    high::Vector{H},
    low::Vector{L},
    close::Vector{C}
)::Vector{Tuple{D,O,H,L,C}} where {D<:Union{Real,TimeType},O<:Real,H<:Real,L<:Real,C<:Real}
    @assert length(timestamps) === length(open) == length(high) == length(low) == length(close) "length(timestamps) != length(open) != length(high) != length(low) != (close)"
    return collect(zip(timestamps, open, high, low, close))
end

function prepare_data(
    values::Vector{T};
)::Vector{Tuple{Union{Real,TimeType},T}} where {T<:Real}
    timestamps = [d + Second(1) for d in DateTime(1970):Second(1):DateTime(1970) + Second(length(values) - 1)]
    return prepare_data(timestamps, values)
end

include("charts/line.jl")
include("charts/baseline.jl")
include("charts/area.jl")
include("charts/histogram.jl")
include("charts/candlestick.jl")
include("charts/bar.jl")

end
