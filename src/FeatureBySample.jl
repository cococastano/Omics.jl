module FeatureBySample

using DataFrames: dropmissing!

using StatsBase: mean

using ..Omics

function get_sample(ta, co)

    ta[!, co]

end

function get_sample(ta, re::Regex)

    ta[!, findall(contains(re), names(ta))[]]

end

function index_feature(fe_, da, id_)

    fe_[id_], da[id_, :]

end

function select(gr_, fl, mi)

    ar___ = [(id_, round(lastindex(id_) * mi)) for id_ in values(Omics.Dic.inde(gr_))]

    map(fl_ -> all(ar_ -> ar_[2] <= sum(!isnan, fl_[ar_[1]]), ar___), eachrow(fl))

end

function collapse(fu, ty, fe_, da)

    fe_id_ = Omics.Dic.inde(fe_)

    fa_ = sort!(collect(keys(fe_id_)))

    dt = Matrix{ty}(undef, lastindex(fa_), size(da, 2))

    for ie in eachindex(fa_)

        id_ = fe_id_[fa_[ie]]

        dt[ie, :] =
            isone(lastindex(id_)) ? da[id_[], :] : [fu(da_) for da_ in eachcol(da[id_, :])]

    end

    fa_, dt

end

function rea(ts, co, sa_; ta_ = ones(Int, lastindex(sa_)), mi = 1.0)

    ta = dropmissing!(Omics.Table.rea(ts), co)

    fe_ = ta[!, co]

    @info "Read $(lastindex(fe_))."

    da = stack((get_sample(ta, sa) for sa in sa_))

    fe_, da = index_feature(fe_, da, select(ta_, da, mi))

    @info "Selected $(lastindex(fe_))."

    if !allunique(fe_)

        fe_, da = collapse(mean, Float64, fe_, da)

        @info "Collapsed into $(lastindex(fe_))."

    end

    da___ = eachrow(da)

    if any(allequal, da___)

        fe_, da = index_feature(fe_, da, map(!allequal, da___))

        @info "Kept $(lastindex(fe_))."

    end

    fe_, da

end

function joi(fi, f1_, s1_, d1, f2_, s2_, d2)

    f3_ = union(f1_, f2_)

    s3_ = union(s1_, s2_)

    d3 = fill(fi, lastindex(f3_), lastindex(s3_))

    fe_id = Omics.Dic.index(f3_)

    sa_id = Omics.Dic.index(s3_)

    for is in eachindex(s1_)

        ia = sa_id[s1_[is]]

        for ie in eachindex(f1_)

            d3[fe_id[f1_[ie]], ia] = d1[ie, is]

        end

    end

    for is in eachindex(s2_)

        ia = sa_id[s2_[is]]

        for ie in eachindex(f2_)

            d3[fe_id[f2_[ie]], ia] = d2[ie, is]

        end

    end

    f3_, s3_, d3

end

end
