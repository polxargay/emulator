####### COMMANDS FOR PRIMARY NETWORK #######
#=
******** DOWNLINK COMMANDS *********

    reset_CU(id_cu) --> fet
    reset_FU(id_eaxon,id_cu) --> fet
    stop_CU --> fet
    stop_FU --> fet
    ping_CU(id_cu) --> fet
    ping_FU(id_eaxon,id_cu)
    set_SAR_limit() --> fet
    set_lead_off() --> fet
    get_SAR_limit() --> fet
    get_lead-off() --> fet
    stimulation()
=#

#communication module for the control unit
function brain_cu(command,id_cu)
    response = control_unit(command,id_cu)
    println(response)
end

#communication module for the functional unit
function brain_fu(command,id_cu,id_fu)
    response = functional_unit(id_eaxon,id_cu)
    println(response)
end

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
function cu_fu(command,id_eaxon,id_cu)
    response = functional_unit(command,id_eaxon,id_cu)
    println(response)
end
