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
import ..prepare_data

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

include("charts/line.jl")
include("charts/baseline.jl")
include("charts/area.jl")
include("charts/histogram.jl")
include("charts/candlestick.jl")
include("charts/bar.jl")

end
