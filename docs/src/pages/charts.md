# [Charts](@id charts)

```@docs
LWCChart
```

## Line

```@docs
lwc_line
```

### Example

```@example
using LightweightCharts

t_values = round(Int64, time()) .+ collect(1:500)
x_values = map(x -> sin(x / 10), 1:500)

chart = lwc_line(
    t_values,
    x_values;
    label_name = "lwc_line",
    line_color = "#02c39a",
    line_width = 4,
    line_style = LWC_SOLID,
    line_type = LWC_CURVED,
    price_scale_id = LWC_RIGHT,
)

lwc_save("line_example.html", chart)
nothing # hide
```

```@raw html
    <iframe src="../line_example.html" style="height:500px;width:100%;"></iframe>
```

## Baseline

```@docs
lwc_baseline
```

### Example

```@example
using LightweightCharts

t_values = round(Int64, time()) .+ collect(1:500)
x_values = map(x -> sin(x / 10) + cos(x / 5), 1:500)

chart = lwc_baseline(
    t_values,
    x_values;
    label_name = "lwc_baseline",
    base_value = LWCBaseValue("price", 0.0),
    line_style = LWC_SOLID,
    line_type = LWC_CURVED,
    line_width = 3,
    precision = 4,
    price_scale_id = LWC_RIGHT,
)

lwc_save("baseline_example.html", chart)
nothing # hide
```

```@raw html
    <iframe src="../baseline_example.html" style="height:500px;width:100%;"></iframe>
```

## Area

```@docs
lwc_area
```

### Example

```@example
using Dates
using LightweightCharts

t_values = round(Int64, time()) .+ collect(1:500)
x_values = map(x -> x % 20, 1:500)

chart = lwc_area(
    t_values,
    x_values;
    label_name = "lwc_area",
    line_color = "#00b4d8",
    top_color = "#90e0ef",
    bottom_color = "rgba(133, 242, 240, 0)",
    line_style = LWC_SOLID,
    line_type = LWC_STEP,
    line_width = 2,
    precision = 3,
    price_scale_id = LWC_RIGHT,
)

lwc_save("area_example.html", chart)
nothing # hide
```

```@raw html
    <iframe src="../area_example.html" style="height:500px;width:100%;"></iframe>
```

## Histogram

```@docs
lwc_histogram
```

### Example

```@example
using LightweightCharts

t_values = round(Int64, time()) .+ collect(1:500)
x_values = map(x -> x * cos(x / 10), 1:500)

chart = lwc_histogram(
    t_values,
    x_values;
    label_name = "lwc_histogram",
    base = 0.0,
    color = "rgba(240, 113, 103, 0.5)",
    price_scale_id = LWC_RIGHT,
)

lwc_save("histogram_example.html", chart)
nothing # hide
```

```@raw html
    <iframe src="../histogram_example.html" style="height:500px;width:100%;"></iframe>
```

# OHLC Candles

```@docs
LWCCandleChartItem
```

## Candlestick

```@docs
lwc_candlestick
```

### Example

```@example
using Dates
using LightweightCharts

open_time = now() .+ Second.(1:500)
x_values = map(x -> sin(2rand() + x / 10), 1:500)

chart = lwc_candlestick(
    LWCCandleChartItem.(
        open_time,
        x_values,
        x_values .+ rand(500),
        x_values .- rand(500),
        [x_values[2:end]..., x_values[begin]],
    );
    label_name = "lwc_candlestick",
    up_color = "#52a49a",
    down_color = "#de5e57",
    border_visible = false,
    price_scale_id = LWC_RIGHT,
)

lwc_save("candlestick_example.html", chart)
nothing # hide
```

```@raw html
    <iframe src="../candlestick_example.html" style="height:500px;width:100%;"></iframe>
```

## Bar

```@docs
lwc_bar
```

### Example

```@example
using Dates
using LightweightCharts

open_time = now() .+ Second.(1:500)
x_values = map(x -> sin(2rand() + x / 10), 1:500)

chart = lwc_bar(
    LWCCandleChartItem.(
        open_time,
        x_values,
        x_values .+ rand(500),
        x_values .- rand(500),
        [x_values[2:end]..., x_values[begin]],
    );
    label_name = "lwc_bar",
    up_color = "#52a49a",
    down_color = "#de5e57",
    price_scale_id = LWC_RIGHT,
)

lwc_save("bar_example.html", chart)
nothing # hide
```

```@raw html
    <iframe src="../bar_example.html" style="height:500px;width:100%;"></iframe>
```

## Multi-colors

```@docs
LWCSimpleChartItem
```

### Example

```@example
using Dates
using LightweightCharts
import LightweightCharts: randcolor

t_range = 1:500

chart = lwc_baseline(
    map(
        x -> LWCSimpleChartItem(
            now() + Second(x),
            cos.(x / 10);
            color = randcolor(),
            top_line_color = randcolor(),
            top_fill_color_1 = randcolor(),
            bottom_line_color = randcolor(),
            bottom_fill_color_2 = randcolor(),
        ),
        t_range,
    );
    label_name = "lwc_baseline",
    line_type = LWC_STEP,
    price_scale_id = LWC_RIGHT,
    line_width = 4,
)

lwc_save("colors_example.html", chart)
nothing # hide
```

```@raw html
    <iframe src="../colors_example.html" style="height:500px;width:100%;"></iframe>
```

## [Custom data](@id custom_data)

Vectors with custom data types can also be visualized.

The simplest way to add visualization support to your custom type is to define a new [conversion method](https://docs.julialang.org/en/v1/base/base/#Base.convert) from `CustomType` to `Tuple` with the following signature:

For simple charts (e.g [lwc_line](@ref), [lwc_area](@ref), ...)
```julia
Base.convert(::Type{Tuple}, x::CustomType)::Tuple{TimeType,Real} = ...
# OR
Base.convert(::Type{Tuple}, x::CustomType)::Tuple{Real,Real} = ...
```

For candle charts (e.g [lwc_candlestick](@ref), [lwc_bar](@ref))
```julia
Base.convert(::Type{Tuple}, x::CustomType)::Tuple{TimeType,Real,Real,Real,Real} = ...
# OR
Base.convert(::Type{Tuple}, x::CustomType)::Tuple{Real,Real,Real,Real,Real} = ...
```

If such a conversion method is already defined for other purposes, then you can define another conversion methods that allows you to create objects `LWCSimpleChartItem` or `LWCCandleChartItem` (this method provides more flexible customization options).
```julia
Base.convert(::Type{LWCSimpleChartItem}, x::CustomType) = LWCSimpleChartItem(...)
# OR / AND
Base.convert(::Type{LWCCandleChartItem}, x::CustomType) = LWCCandleChartItem(...)
```

### Examples

```@example
using Dates
using LightweightCharts

struct Point
    timestamp::DateTime
    value::Float64
end

Base.convert(::Type{Tuple}, x::Point) = (x.timestamp, x.value)
# OR
function Base.convert(::Type{LWCSimpleChartItem}, x::Point)
    return LWCSimpleChartItem(x.timestamp, x.value)
end

points = [Point(now() + Second(x), sin(x / 10.0)) for x in 1:500]

chart = lwc_line(
    points;
    label_name = "custom points",
    line_color = "#a8dadc",
    line_width = 3,
)

lwc_save("custom_simple_type_example.html", chart)
nothing # hide
```

```@raw html
    <iframe src="../custom_simple_type_example.html" style="height:500px;width:100%;"></iframe>
```

```@example
using Dates
using LightweightCharts

struct OHLC
    timestamp::DateTime
    open::Float64
    high::Float64
    low::Float64
    close::Float64
end

Base.convert(::Type{Tuple}, x::OHLC) = (x.timestamp, x.open, x.high, x.low, x.close)
# OR
function Base.convert(::Type{LWCCandleChartItem}, x::OHLC)
    return LWCCandleChartItem(x.timestamp, x.open, x.high, x.low, x.close)
end

candles = [OHLC(now() + Second(x), rand(), rand(), rand(), rand()) for x in 1:500]

chart = lwc_candlestick(
    candles;
    label_name = "custom candles",
)

lwc_save("custom_candle_type_example.html", chart)
nothing # hide
```

```@raw html
    <iframe src="../custom_candle_type_example.html" style="height:500px;width:100%;"></iframe>
```
