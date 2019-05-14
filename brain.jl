module files
    include("environment.jl")
    include("fu.jl")
end

function ping(id_eaxon,id_cu)
    functional_unit_recieve(id_eaxon,id_cu)
end
