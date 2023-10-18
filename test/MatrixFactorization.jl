using Random: seed!

using Test: @test

using BioLab

# ---- #

function is_positive(ma)

    all(>=(0), ma)

end

# ---- #

for (n_ro, n_co, n_fa) in ((4, 3, 2), (8, 16, 3), (20, 2000, 10), (1000, 100, 10))

    seed!(20230928)

    ma = rand(n_ro, n_co)

    mw, mh = BioLab.MatrixFactorization.factorize(ma, n_fa)

    @test size(mw) === (n_ro, n_fa)

    @test size(mh) === (n_fa, n_co)

    @test is_positive(mw)

    @test is_positive(mh)

    di = joinpath(BioLab.TE, "$(n_ro)_$(n_co)_$(n_fa)")

    BioLab.Path.remake_directory(di)

    BioLab.MatrixFactorization.write(di, mw)

    BioLab.MatrixFactorization.write(di, mh)

    mh2 = BioLab.MatrixFactorization.solve_h(ma, mw)

    @test isapprox(mh, mh2; rtol = 1e-0)

    di = "$(di)_solved"

    BioLab.Path.remake_directory(di)

    BioLab.MatrixFactorization.write(di, mh2; naf = "Solved")

    # 9.417 μs (58 allocations: 6.95 KiB)
    # 2.296 μs (23 allocations: 2.78 KiB)
    # 224.125 μs (128 allocations: 40.97 KiB)
    # 3.448 μs (23 allocations: 4.33 KiB)
    # 2.898 s (4331 allocations: 221.99 MiB)
    # 149.166 μs (24 allocations: 172.08 KiB)
    # 7.837 s (12949 allocations: 363.06 MiB)
    # 302.458 μs (27 allocations: 329.34 KiB)

    #@btime BioLab.MatrixFactorization.factorize($ma, $n_fa)

    #@btime BioLab.MatrixFactorization.solve_h($ma, $mw)

end

# ---- #

const MW = BioLab.Simulation.make_matrix_1n(Float64, 3, 2)

# ---- #

const MH = BioLab.Simulation.make_matrix_1n(Float64, 2, 3)

# ---- #

const DI = joinpath(BioLab.TE, "write")

# ---- #

BioLab.Path.remake_directory(DI)

# ---- #

BioLab.MatrixFactorization.write(DI, MW)

# ---- #

BioLab.MatrixFactorization.write(DI, MH)

# ---- #

@test MW == Matrix(BioLab.DataFrame.read(joinpath(DI, "w.tsv"))[!, 2:end])

# ---- #

@test MH == Matrix(BioLab.DataFrame.read(joinpath(DI, "h.tsv"))[!, 2:end])

# ---- #

@test isfile(joinpath(DI, "w.html"))

# ---- #

@test isfile(joinpath(DI, "h.html"))

# ---- #

ma = rand(4, 8)

# ---- #

BioLab.Plot.plot_heat_map("", ma; layout = Dict("title" => Dict("text" => "A")))

# ---- #

mw, mh = BioLab.MatrixFactorization.factorize(ma, 3)

# ---- #

mwh = mw * mh

# ---- #

BioLab.Plot.plot_heat_map("", mwh; layout = Dict("title" => Dict("text" => "W x H")))

# ---- #

# https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1004760

# ---- #

ml = copy(mwh)

# ---- #

BioLab.Normalization.normalize_with_logistic!(ml)

# ---- #

BioLab.Plot.plot_heat_map("", ml; layout = Dict("title" => Dict("text" => "Logistic")))

# ---- #

prod(ml .^ ma .* (1 .- ml) .^ (1 .- ma))
