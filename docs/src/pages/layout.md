# Layouts

Here you can find various examples that show how a user can combine different charts, plugins and panels together.

## Panel

```@docs
LWCPanel
lwc_panel
```

### Example

```@example
using LightweightCharts

t_values = round(Int64, time()) .+ collect(1:500)
x_values = map(x -> rand(1:500), collect(1:500))

panel = lwc_panel(
    lwc_line(
        t_values,
        x_values .+ 500.0;
        label_name = "lwc_line",
        line_color = "#f35B04",
        line_visible = false,
        point_markers_visible = true,
        price_scale_id = LWC_RIGHT,
    ),
    lwc_histogram(
        t_values,
        x_values;
        label_name = "lwc_histogram",
        base = 250.0,
        color = "rgba(118, 120, 237, 0.5)",
        price_scale_id = LWC_RIGHT,
    );
    name = "Panel example",
)

lwc_save("panel_example.html", panel)
nothing # hide
```

```@raw html
    <iframe src="../panel_example.html" style="height:600px;width:100%;"></iframe>
```

## Layout

```@docs
LWCLayout
lwc_layout
```

### Example

```@example
using Dates, NanoDates
using LightweightCharts

layout = lwc_layout(
    lwc_panel(
        lwc_baseline(
            NanoDate("2024-01-01") .+ Second.(1:500),
            map(x -> rand(1:500), collect(1:500));
            label_name = "lwc_baseline",
            base_value = LWCBaseValue("price", 250),
            top_line_color = "#6a994e",
            top_fill_color1 = "#a7c957",
            bottom_line_color = "#e76f51",
            bottom_fill_color2 = "#f4a261",
            line_style = LWC_SOLID,
            line_type = LWC_CURVED,
            line_width = 3,
            precision = 4,
            price_scale_id = LWC_RIGHT,
        ),
        x = 1,
        y = 1,
    ),
    lwc_panel(
        lwc_area(
            NanoDate("2024-01-01") .+ Second.(1:500),
            map(x -> sin(x / 10), collect(1:500));
            label_name = "lwc_area",
            line_color = "#2ec4b6",
            top_color = "#cbf3f0",
            bottom_color = "rgba(133, 242, 240, 0)",
            line_style = LWC_SOLID,
            line_type = LWC_STEP,
            line_width = 2,
            precision = 3,
            price_scale_id = LWC_RIGHT,
        ),
        lwc_line(
            NanoDate("2024-01-01") .+ Second.(1:500),
            map(x -> cos(x / 10), collect(1:500));
            label_name = "lwc_line",
            line_color = "#ff7d00",
            line_style = LWC_SPARSE_DOTTED,
            line_type = LWC_SIMPLE,
            line_width = 3,
            price_scale_id = LWC_RIGHT,
        ),
        x = 1,
        y = 2,
    );
    name = "Layout example",
)

lwc_save("layout_example.html", layout)
nothing # hide
```

```@raw html
    <iframe src="../layout_example.html" style="height:700px;width:100%;"></iframe>
```
