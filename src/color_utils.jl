# color_utils

const COLORS = [
    "#eb3f3f",
    "#52f452",
    "#bf4545",
    "#00ff00",
    "#3b3bff",
    "#eded5c",
    "#ffa500",
    "#800080",
    "#ffc0cb",
    "#4ef8f8",
    "#000000",
    "#61f7ac",
    "#5bfa5b",
    "#800000",
    "#8a2be2",
    "#00008b",
    "#ffd700",
    "#808080",
    "#a52a2a",
    "#808000",
    "#800080",
    "#4b0082",
    "#abfeac",
    "#b9d5d2",
    "#ade4f6",
    "#b1e2f6",
    "#d8cba8",
    "#82fba8",
    "#a9c79f",
    "#d3cacb",
    "#a6efef",
    "#96cdc0",
    "#83bda7",
    "#82d8f2",
    "#e1b887",
    "#e39486",
    "#e199d0",
    "#c58ce2",
    "#efb8ce",
    "#939ec8",
    "#f2a9ad",
    "#f0838e",
    "#8ee5aa",
    "#8bd5bb",
    "#fda0ee",
    "#b68685",
    "#f7b4cb",
    "#dddab6",
    "#b4f7d7",
    "#fda095",
    "#c4eeb7",
    "#cd978b",
    "#9eaf84",
]

const STATE_COLOR = Ref{Int64}(0)

function randcolor()::String
    number = STATE_COLOR[] % length(COLORS)
    number += 1
    STATE_COLOR[] += 1
    return COLORS[number]
end
