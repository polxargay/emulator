module files
    include("environment.jl")
    include("fu.jl")
end

function ping(id_eaxon,id_cu)
    send_ACK(id_eaxon,id_cu)
end

function start_sensing(id_eaxon,id_cu)
    send_ACK(id_eaxon,id_cu)
end
