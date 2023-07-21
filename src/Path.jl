module Path

function error_missing(pa)

    if !ispath(pa)

        error("$pa is missing.")

    end

end

function error_extension_difference(pa, ex2)

    ex = splitext(pa)[2][2:end]

    if ex != ex2

        error("Extensions differ. $ex != $ex2.")

    end

end

function make_absolute(pa)

    rstrip(abspath(expanduser(pa)), '/')

end

function clean(pa)

    replace(lowercase(pa), r"[^/_.0-9a-z]" => '_')

end

function wait(pa; sl = 1, li = 4)

    se = 0

    while se <= li && !ispath(pa)

        sleep(sl)

        se += sl

        @info "Waiting for $pa ($se/$li)"

    end

end

function open(pa)

    try

        run(`open --background $pa`)

    catch

        @warn "Could not open $pa."

    end

end

function read(di; join = false, ig_ = (r"^\.",), ke_ = ())

    pa_ = Vector{String}()

    for pa in readdir(di; join)

        ba = basename(pa)

        # TODO: Benchmark with map(ig->).
        if !any(contains(ba, ig) for ig in ig_) &&
           (isempty(ke_) || any(contains(ba, ke) for ke in ke_))

            push!(pa_, pa)

        end

    end

    pa_

end

function _split(na)

    rsplit(na, '.'; limit = 3)

end

function make_directory(di)

    if isdir(di)

        @warn "$di already exists."

    else

        mkdir(di)

    end

    di

end

function rank(di)

    na_ = readdir(di)

    for (id, na) in enumerate(sort!(na_; by = na -> parse(Float64, _split(na)[1])))

        su = join(_split(na)[2:end], '.')

        na2 = "$id.$su"

        if na != na2

            mv(joinpath(di, na), joinpath(di, na2))

        end

    end

end

function rename(di, pa_)

    for (be, af) in pa_

        run(pipeline(`find $di -print0`, `xargs -0 rename --subst-all $be $af`))

    end

end

function sed(di, pa_)

    for (be, af) in pa_

        run(pipeline(`find $di -type f -print0`, `xargs -0 sed -i "" "s/$be/$af/g"`))

    end

end

end
