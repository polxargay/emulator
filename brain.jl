####### COMMANDS FOR PRIMARY NETWORK #######
#=
******** DOWNLINK COMMANDS *********

    reset_CU(id_cu) --> fet
    reset_FU(id_eaxon,id_cu) --> fet
    stop_CU --> fet
    stop_FU --> fet
    ping_CU(id_cu) --> fet
    ping_FU(id_eaxon,id_cu) --> fet
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
    response = functional_unit_brain(command,id_eaxon,id_cu,id_group)
    println(response)
end
