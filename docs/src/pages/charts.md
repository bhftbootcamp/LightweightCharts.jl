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
LWCCandle
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
    LWCCandle.(
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
    LWCCandle.(
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
LWCSimpleChartData
```

### Example

```@example
using Dates
using LightweightCharts
import LightweightCharts: randcolor

t_range = 1:500

chart = lwc_baseline(
    map(
        x -> LWCSimpleChartData(
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

## Custom data

Vectors with custom data types can also be visualized.
To do this, they must have a [conversion method](https://docs.julialang.org/en/v1/base/base/#Base.convert) to type `Tuple` with two elements: `timestamp::Union{TimeType,Real}` and `value::Real`.

```@example
using Dates
using LightweightCharts

struct Point
    timestamp::DateTime
    value::Float64
end

Base.convert(::Type{Tuple}, x::Point) = (x.timestamp, x.value)

points = [Point(now() + Second(x), sin(x / 10.0)) for x in 1:500]

chart = lwc_line(
    points;
    label_name = "custom points",
    line_color = "#a8dadc",
    line_width = 3,
)

lwc_save("custom_type_example.html", chart)
nothing # hide
```

```@raw html
    <iframe src="../custom_type_example.html" style="height:500px;width:100%;"></iframe>
```
