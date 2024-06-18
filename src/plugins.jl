module Plugins

export lwc_vert_line,
    lwc_delta_tooltip,
    lwc_trend_line,
    lwc_crosshair_highlight_bar,
    lwc_tooltip

export LWC_TOOLTIP_TYPE,
    LWC_TOOLTIP_TOP,
    LWC_TOOLTIP_TRACK

using Dates
using Serde

using ..LightweightCharts
import ..randcolor

@enum LWC_TOOLTIP_TYPE begin
    LWC_TOOLTIP_TOP = 0
    LWC_TOOLTIP_TRACK = 1
end

Serde.SerJson.ser_type(::Type{<:AbstractPluginSettings}, x::LWC_TOOLTIP_TYPE) = Int64(x)

include("plugins/vertical_line.jl")
include("plugins/delta_tooltip.jl")
include("plugins/trend_line.jl")
include("plugins/crosshair_highlight_bar.jl")
include("plugins/tooltip.jl")

end
