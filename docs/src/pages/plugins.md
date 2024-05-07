# [Plugins](@id plugins)

You can add auxiliary elements to your [`chart`](@ref charts) using plugins (via the `plugins` keyword).

```@docs
LWCPlugin
```

## Vertical line

```@docs
lwc_vert_line
```

### Examples

```@example
using LightweightCharts

t_values = round(Int64, time()) .+ collect(0:300)
x_values = map(x -> 1/(x - 250), 0:300)

chart = lwc_line(
    t_values,
    x_values;
    line_color = "#7678ed",
    label_name = "hyperbola",
    price_scale_id = LWC_RIGHT,
    plugins = [
        lwc_vert_line(
            250;
            color = "#f18701",
            label_background_color = "#f35b04",
            show_label = true,
            label_text = "lwc_vert_line",
        ),
    ],
)

lwc_save("vert_line_example.html", chart)
nothing # hide
```

```@raw html
    <iframe src="../vert_line_example.html" style="height:500px;width:100%;"></iframe>
```

## Tooltip

```@docs
lwc_tooltip
```

### Examples

```@example
using LightweightCharts

t_values = round(Int64, time()) .+ collect(1:300)
x_values = map(x -> cos(x / 10), 1:300)

chart = lwc_line(
    t_values,
    x_values;
    line_color = "#0fa3b1",
    label_name = "cos",
    line_type = LWC_STEP,
    line_width = 2,
    price_scale_id = LWC_RIGHT,
    plugins = [
        lwc_tooltip(;
            line_color = "#7400b8",
            follow_mode = LWC_TOOLTIP_TRACK,
        ),
    ],
)

lwc_save("tooltip_example.html", chart)
nothing # hide
```

```@raw html
    <iframe src="../tooltip_example.html" style="height:500px;width:100%;"></iframe>
```

## Delta tooltip

```@docs
lwc_delta_tooltip
```

### Examples

```@example
using LightweightCharts

t_values = round(Int64, time()) .+ collect(1:300)
x_values = map(x -> sin(x / 10), 1:300)

chart = lwc_line(
    t_values,
    x_values;
    line_color = "#90be6d",
    label_name = "sin",
    line_width = 2,
    price_scale_id = LWC_RIGHT,
    plugins = [
        lwc_delta_tooltip(;
            show_time = true,
            top_offset = 10,
        ),
    ],
)

lwc_save("delta_tooltip_example.html", chart)
nothing # hide
```

```@raw html
    <iframe src="../delta_tooltip_example.html" style="height:500px;width:100%;"></iframe>
```

## Trend line

```@docs
lwc_trend_line
```

### Examples

```@example
using LightweightCharts

t_values = round(Int64, time()) .+ collect(1:300)
x_values = map(x -> cos(x / 10), 1:300)

chart = lwc_line(
    t_values,
    x_values;
    line_color = "#c77dff",
    label_name = "cos",
    price_scale_id = LWC_RIGHT,
    plugins = [
        lwc_trend_line(
            220,
            -0.7,
            250,
            1.3;
            line_color = "#ff6700",
        ),
    ],
)

lwc_save("trend_line_example.html", chart)
nothing # hide
```

```@raw html
    <iframe src="../trend_line_example.html" style="height:500px;width:100%;"></iframe>
```

## Crosshair bar

```@docs
lwc_crosshair_highlight_bar
```

### Examples

```@example
using LightweightCharts

t_values = round(Int64, time()) .+ collect(1:300)
x_values = map(x -> cos(x / 10), 1:300)

chart = lwc_line(
    t_values,
    x_values;
    line_color = "#0a9396",
    label_name = "cos",
    price_scale_id = LWC_RIGHT,
    plugins = [
        lwc_crosshair_highlight_bar(;
            color = "#94d2bd",
        ),
    ],
)

lwc_save("crosshair_bar_example.html", chart)
nothing # hide
```

```@raw html
    <iframe src="../crosshair_bar_example.html" style="height:500px;width:100%;"></iframe>
```
