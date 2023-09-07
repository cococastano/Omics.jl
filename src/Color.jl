module Color

using ColorSchemes: ColorScheme, bwr, plasma

using Colors: Colorant, coloralpha, hex

using ..BioLab

function _make_color_scheme(he_)

    ColorScheme([parse(Colorant{Float64}, he) for he in he_])

end

const COBWR = bwr

const COPLA = plasma

const COPL3 = _make_color_scheme((
    "#0508b8",
    "#1910d8",
    "#3c19f0",
    "#6b1cfb",
    "#981cfd",
    "#bf1cfd",
    "#dd2bfd",
    "#f246fe",
    "#fc67fd",
    "#fe88fc",
    "#fea5fd",
    "#febefe",
    "#fec3fe",
))

const COASP = _make_color_scheme((
    "#00936e",
    "#a4e2b4",
    "#e0f5e5",
    "#ffffff",
    "#fff8d1",
    "#ffec9f",
    "#ffd96a",
))

const COPLO = _make_color_scheme((
    "#636efa",
    "#ef553b",
    "#00cc96",
    "#ab63fa",
    "#ffa15a",
    "#19d3f3",
    "#ff6692",
    "#b6e880",
    "#ff97ff",
    "#fecb52",
))

const COBIN = _make_color_scheme(("#006442", "#ffb61e"))

const COHUM = _make_color_scheme(("#4b3c39", "#ffddca"))

const COSTA = _make_color_scheme(("#8c1515", "#175e54"))

const COMON = _make_color_scheme(("#fbb92d",))

function _make_hex(rg)

    "#$(lowercase(hex(rg)))"

end

function add_alpha(he, al)

    _make_hex(coloralpha(parse(Colorant, he), al))

end

function pick_color_scheme(::AbstractArray{Float64})

    COBWR

end

function pick_color_scheme(it::AbstractArray{Int})

    n = length(unique(it))

    if n in (0, 1)

        COMON

    elseif n == 2

        COBIN

    else

        COPLO

    end

end

function color(nu::Real, co)

    _make_hex(co[nu])

end

function color(nu_::AbstractVector{<:Real}, co = pick_color_scheme(nu_))

    n = length(nu_)

    if isone(length(unique(nu_)))

        return fill(color(0.5, co), n)

    end

    fl_ = Vector{Float64}(undef, n)

    copy!(fl_, nu_)

    BioLab.Normalization.normalize_with_01!(fl_)

    (nu -> color(nu, co)).(fl_)

end

function map_fraction(co)

    collect(zip(range(0, 1, length(co)), _make_hex(rg) for rg in co))

end

end
