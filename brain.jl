module files
    include("environment.jl")
    include("fu.jl")
end

####### COMMANDS FOR PRIMARY NETWORK #######
#=
    reset_CU(id_cu)
    reset_FU(id_eaxon,id_cu)
    stop_CU
    stop_FU
    ping_CU(id_cu)
    ping_FU(id_eaxon,id_cu)
    set_SAR_limit()
    set_lead_off()
    get_SAR_limit()
    get_lead-off()
    stimulation()
=#

####### COMMANDS FOR SECUNDARY NETWORK #######
#=
    fast_get_sample(id_eaxon)
    reset(id_eaxon)
    stop_sensing(id_eaxon)
    ping_FU(id_eaxon, id_cu)
    stimulate(id_eaxon, id_cu)
    start_sensing(id_eaxon, id_cu)
    get_sample(id_eaxon, id_cu)
    get_stimulation_conf(id_eaxon, id_cu)
    get_group_conf(id_Eaxon, id_cu)
    set_stimulation_conf(id_eaxon, id_cu, config)
    set_group_conf(id_eaxon, id_cu, id_group, config)
    set_uplink_limit()
    set_efuse()
    get_efuse()
=#
function ping_FU(id_eaxon,id_cu)
    send_ACK(id_eaxon,id_cu)
end

function start_sensing(id_eaxon,id_cu)
    send_ACK(id_eaxon,id_cu)
end
