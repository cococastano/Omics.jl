include("environment.jl")

# ---- #

DA = joinpath(BioLab.DA, "CLS")

@test readdir(DA) == []

# ---- #

for (na, ta, nu_) in (
    ("CCLE_mRNA_20Q2_no_haem_phen.cls", "HER2", []),
    ("GSE76137.cls", "Proliferating_Arrested", [1, 2, 1, 2, 1, 2]),
    ("LPS_phen.cls", "CNTRL_LPS", [1, 1, 1, 2, 2, 2]),
)

    cl = BioLab.CLS.read(joinpath(DA, na))

    @test cl[!, "Target"] == [ta]

    if !isempty(nu_)

        @test collect(cl[1, ["Sample $id" for id in 1:length(nu_)]]) == nu_

    end

end
