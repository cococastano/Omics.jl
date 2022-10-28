module Plot

using ColorSchemes: ColorScheme

using Colors: Colorant, hex

using DataFrames: DataFrame

using JSON3: write

using ..OnePiece

NA_CA = Dict(
    "Plasma" => [
        [0.0, "#0d0887"],
        [0.1111111111111111, "#46039f"],
        [0.2222222222222222, "#7201a8"],
        [0.3333333333333333, "#9c179e"],
        [0.4444444444444444, "#bd3786"],
        [0.5555555555555556, "#d8576b"],
        [0.6666666666666666, "#ed7953"],
        [0.7777777777777777, "#fb9f3a"],
        [0.8888888888888888, "#fdca26"],
        [1.0, "#f0f921"],
    ],
    "Plotly3" => [
        [0.0, "#0508b8"],
        [0.08333333333333333, "#1910d8"],
        [0.16666666666666666, "#3c19f0"],
        [0.25, "#6b1cfb"],
        [0.3333333333333333, "#981cfd"],
        [0.41666666666666663, "#bf1cfd"],
        [0.5, "#dd2bfd"],
        [0.5833333333333333, "#f246fe"],
        [0.6666666666666666, "#fc67fd"],
        [0.75, "#fe88fc"],
        [0.8333333333333333, "#fea5fd"],
        [0.9166666666666666, "#febefe"],
        [1.0, "#fec3fe"],
    ],
    "Plotly" => [
        [0.0, "#636EFA"],
        [0.1111111111111111, "#EF553B"],
        [0.2222222222222222, "#00CC96"],
        [0.3333333333333333, "#AB63FA"],
        [0.4444444444444444, "#FFA15A"],
        [0.5555555555555556, "#19D3F3"],
        [0.6666666666666666, "#FF6692"],
        [0.7777777777777777, "#B6E880"],
        [0.8888888888888888, "#FF97FF"],
        [1.0, "#FECB52"],
    ],
    "binary" => [[0.0, "#006442"], [0.5, "#ffffff"], [1.0, "#ffb61e"]],
    "aspen" => [
        [0.0, "#00936e"],
        [0.2, "#a4e2b4"],
        [0.4, "#e0f5e5"],
        [0.5, "#ffffff"],
        [0.6, "#fff8d1"],
        [0.8, "#ffec9f"],
        [1.0, "#ffd96a"],
    ],
    "human" => [[0.0, "#4b3c39"], [0.5, "#ffffff"], [1.0, "#ffddca"]],
    "stanford" => [[0.0, "#ffffff"], [1.0, "#8c1515"]],
)

NA_CH = Dict()

for (na, fr_) in NA_CA

    NA_CH[na] = ColorScheme([parse(Colorant, fr[2]) for fr in fr_])

end

include("../_include.jl")

@_include()

end
