module Coordinate

using MultivariateStats: MetricMDS, fit

using ..Nucleus

function get(an_x_an_x_di, maxoutdim = 2)

    fit(MetricMDS, an_x_an_x_di; distances = true, maxoutdim, maxiter = 10^3).X

end

function pull(di_x_no_x_co, no_x_po_x_pu)

    no_x_po_x_pu = copy(no_x_po_x_pu)

    foreach(Nucleus.Normalization.normalize_with_sum!, eachcol(no_x_po_x_pu))

    di_x_no_x_co * no_x_po_x_pu

end

end
