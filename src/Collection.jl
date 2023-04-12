module Collection

function _error_bad(an, ba_)

    for ba in ba_

        if isequal(an, ba)

            error(ba)

        end

    end

end

function error_bad(co, ty)

    for an in co

        if !(an isa ty)

            error()

        end

        if ty <: Real

            ba_ = (-Inf, Inf, NaN)

        elseif ty <: AbstractString

            ba_ = ("",)

        else

            ba_ = ()

        end

        _error_bad(an, ba_)

    end

end

function get_extreme_id(an_, n_ex)

    if isempty(an_) || n_ex == 0

        return Vector{Int}()

    end

    n = length(an_)

    if n < n_ex

        n_ex = n

    end

    return sortperm(an_)[unique(vcat(collect(1:n_ex), collect((n - n_ex + 1):n)))]

end

function is_in(an_, an1_)

    n = length(an_)

    bo_ = Vector{Bool}(undef, n)

    for id in 1:n

        bo_[id] = an_[id] in an1_

    end

    return bo_

end

function is_in(an_id::AbstractDict, an1_)

    bo_ = fill(false, length(an_id))

    for an1 in an1_

        id = get(an_id, an1, nothing)

        if !isnothing(id)

            bo_[id] = true

        end

    end

    return bo_

end

function pair_index(an_)

    ty = eltype(an_)

    an_id = Dict{ty, Int}()

    id_an = Dict{Int, ty}()

    for (id, an) in enumerate(an_)

        an_id[an] = id

        id_an[id] = an

    end

    return an_id, id_an

end

function get_common_start(an___)

    le_ = [length(an_) for an_ in an___]

    mi = minimum(le_)

    sh = an___[findfirst(le == mi for le in le_)]

    id = 1

    while id <= mi

        an = sh[id]

        # TODO: Do not check the shortest one.
        if any(an_[id] != an for an_ in an___)

            break

        end

        id += 1

    end

    return sh[1:(id - 1)]

end

function sort_like(an___; ic = true)

    so_ = sortperm(an___[1]; rev = !ic)

    return [an_[so_] for an_ in an___]

end

function get_type(ar___...)

    return eltype(vcat(ar___...))

end

function sort_recursively(an)

    if an isa AbstractArray

        an = [sort_recursively(an2) for an2 in an]

    elseif an isa AbstractDict

        an = sort(Dict(ke => sort_recursively(va) for (ke, va) in an))

    else

        an = an

    end

    try

        sort!(an)

    catch

    end

    return an

end

end
