module Charts

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

Serde.SerJson.ser_type(::Type{<:AbstractChartSettings}, x::LWC_LINE_TYPES) = Int64(x)

Serde.SerJson.ser_type(::Type{<:AbstractChartSettings}, x::LWC_LINE_STYLES) = Int64(x)

Serde.SerJson.ser_type(::Type{<:AbstractChartSettings}, x::LWC_PRICE_SCALE_ID) = x == LWC_RIGHT ? "right" : "left"

Serde.SerJson.ser_ignore_null(::Type{<:AbstractChartData}) = true

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
    return map(enumerate(values)) do i, value
        return (DateTime(1970) + Second(i - 1), value)
    end
end

function prepare_data(data::AbstractVector)
    return map(data) do item
        return convert(Tuple, item)
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

include("charts/line.jl")
include("charts/baseline.jl")
include("charts/area.jl")
include("charts/histogram.jl")
include("charts/candlestick.jl")
include("charts/bar.jl")

end
