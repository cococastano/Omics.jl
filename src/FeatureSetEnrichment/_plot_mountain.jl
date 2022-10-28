function _plot_mountain(
    fe_,
    sc_,
    in_,
    en_,
    ex,
    ar;
    title_text = "Mountain Plot",
    fe = "Feature",
    ht = "",
)

    #
    width = 1000

    height = width / MathConstants.golden

    #
    yaxis1_domain = [0.0, 0.24]

    yaxis2_domain = [0.24, 0.32]

    yaxis3_domain = [0.32, 1.0]

    #
    title_font_size = 32

    statistic_font_size = 24

    axis_title_font_size = 16

    #
    annotation =
        Dict("xref" => "paper", "yref" => "paper", "yanchor" => "middle", "showarrow" => false)

    annotationy = merge(
        annotation,
        Dict("xanchor" => "right", "x" => -0.064, "font" => Dict("size" => axis_title_font_size)),
    )

    annotationx = merge(annotation, Dict("xanchor" => "center", "x" => 0.5))

    #
    n_ch = 32

    if n_ch < length(title_text)

        title_text = "$(title_text[1:n_ch])..."

    end

    #
    n_fe = length(fe_)

    layout = Dict(
        "height" => height,
        "width" => width,
        "margin" => Dict("t" => round(height * 0.17), "l" => round(width * 0.17)),
        "showlegend" => false,
        "yaxis" => Dict("domain" => yaxis1_domain, "showline" => true, "showgrid" => false),
        "yaxis2" =>
            Dict("domain" => yaxis2_domain, "showticklabels" => false, "showgrid" => false),
        "yaxis3" => Dict("domain" => yaxis3_domain, "showline" => true, "showgrid" => false),
        "xaxis" => Dict(
            "zeroline" => false,
            "showgrid" => false,
            "showspikes" => true,
            "spikethickness" => 1.08,
            "spikecolor" => "#ffb61e",
            "spikedash" => "solid",
            "spikemode" => "across",
        ),
        "annotations" => (
            merge(
                annotationx,
                Dict(
                    "y" => 1.16,
                    "text" => "<b>$title_text</b>",
                    "font" => Dict("size" => title_font_size, "color" => "#2b2028"),
                ),
            ),
            merge(
                annotationx,
                Dict(
                    "y" => 1.04,
                    "text" => "Extreme = <b>$(OnePiece.Number.format(ex))</b> and Area = <b>$(OnePiece.Number.format(ar))</b>",
                    "font" => Dict("size" => statistic_font_size, "color" => "#181b26"),
                    "bgcolor" => "#ebf6f7",
                    "bordercolor" => "#404ed8",
                    "borderpad" => 6.4,
                ),
            ),
            merge(annotationy, Dict("y" => mean(yaxis1_domain), "text" => "<b>Score</b>")),
            merge(annotationy, Dict("y" => mean(yaxis2_domain), "text" => "<b>Set</b>")),
            merge(annotationy, Dict("y" => mean(yaxis3_domain), "text" => "<b>Enrichment</b>")),
            merge(
                annotationx,
                Dict(
                    "y" => -0.088,
                    "text" => "<b>$fe (n=$n_fe)</b>",
                    "font" => Dict("size" => axis_title_font_size),
                ),
            ),
        ),
    )

    #
    x = 1:n_fe

    in_ = convert(BitVector, in_)

    trace_ = [
        Dict(
            "y" => sc_,
            "x" => x,
            "text" => fe_,
            "mode" => "lines",
            "line" => Dict("width" => 0),
            "fill" => "tozeroy",
            "fillcolor" => "#20d9ba",
            "hoverinfo" => "x+y+text",
        ),
        Dict(
            "yaxis" => "y2",
            "y" => fill(0, convert(Int, sum(in_))),
            "x" => x[in_],
            "text" => fe_[in_],
            "mode" => "markers",
            "marker" => Dict(
                "symbol" => "line-ns",
                "size" => height * diff(yaxis2_domain)[1] * 0.32,
                "line" => Dict("width" => 2.4, "color" => "#9017e6"),
            ),
            "hoverinfo" => "x+text",
        ),
    ]

    le_ = [en < 0.0 for en in en_]

    gr_ = [!le for le in le_]

    for (is_, fillcolor) in [[le_, "#1992ff"], [gr_, "#ff1993"]]

        push!(
            trace_,
            Dict(
                "yaxis" => "y3",
                "y" => [ifelse(is, en, 0.0) for (is, en) in zip(is_, en_)],
                "x" => x,
                "text" => fe_,
                "mode" => "lines",
                "line" => Dict("width" => 0),
                "fill" => "tozeroy",
                "fillcolor" => fillcolor,
                "hoverinfo" => "x+y+text",
            ),
        )

    end

    id_ = findall([en == ex for en in en_])

    push!(
        trace_,
        Dict(
            "yaxis" => "y3",
            "y" => en_[id_],
            "x" => x[id_],
            "mode" => "markers",
            "marker" => Dict(
                "symbol" => "circle",
                "size" => height * diff(yaxis3_domain)[1] * 0.04,
                "color" => "#ebf6f7",
                "opacity" => 0.72,
                "line" => Dict("width" => 2, "color" => "#404ed8", "opacity" => 1),
            ),
            "hoverinfo" => "y",
        ),
    )

    display(OnePiece.Plot.plot(trace_, layout, ht = ht))

end
