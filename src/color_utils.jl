# color_utils

const COLORS = [
    "#eb3f3f",
    "#52f452",
    "#bf4545",
    "#00ff00",
    "#3b3bff",
    "#ffcc00",
    "#ffa500",
    "#800080",
    "#ff69b4",
    "#00ffff",
    "#000000", 
    "#32cd32",
    "#ff6347",
    "#8b0000",
    "#9400d3",
    "#0000ff",
    "#ffd700",
    "#ff00ff",
    "#a52a2a",
    "#006400",
    "#dc143c",
    "#00008b",
    "#00ced1",
    "#ff4500",
    "#8a2be2",
    "#9acd32",
    "#ff1493",
    "#4169e1",
    "#00fa9a",
    "#ff8c00",
    "#ff7f50",
    "#00bfff",
    "#ff00ff",
    "#4b0082",
    "#8fbc8f",
    "#9932cc",
    "#ff69b4",
    "#4682b4",
    "#7b68ee",
    "#6a5acd",
    "#ff6347",
    "#db7093",
    "#87ceeb",
    "#7fff00",
    "#dda0dd",
    "#6495ed",
    "#ffdab9",
    "#f0e68c",
]

const STATE_COLOR = Ref{Int64}(0)

function randcolor()
    number = STATE_COLOR[] % length(COLORS)
    number += 1
    STATE_COLOR[] += 1
    return COLORS[number]
end
