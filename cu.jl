#= Response from the CU in the primary network
******** UPLINK COMMANDS *******


=#

function control_unit(command,id_cu)

    if command == "reset_cu"
        x = 0
        for i in 1:length(cus)
            if cus[i].id == id_cu
                x = i
                cus[i].message = string("Control Unit with ID ", cus[i].id," says: TASK DONE")
                for j in 1:length(eaxons)
                    if eaxons[j].cu_id == id_cu
                        eaxons[j].group = 0
                        eaxons[j].message = "message"
                    end
                end
            end
        end
        return cus[x].message

    elseif command == "stop_cu"
        x = 0
        for i in 1:length(cus)
            if cus[i].id == id_cu
                x = i
                cus[i].message = string("Control Unit with ID ", cus[i].id," says: TASK DONE")
            end
        end
        return cus[x].message

    elseif command == "ping_cu"
        x = 0 #initialize value in order to found the corresponding eAXON
        for i in 1:length(cus)
            if cus[i].id == id_cu
                x = i #assign the corresponding eAXON to "x"
                cus[i].message = string("Control Unit with ID ", cus[i].id, " sends ACK")
            end
        end
        return cus[x].message

    elseif command == "set_sar"
        print("Set sar limit: ")
        sar_limit = parse(Int,readline())
        x = 0 #initialize value in order to found the corresponding eAXON
        for i in 1:length(cus)
            if cus[i].id == id_cu
                x = i #assign the corresponding eAXON to "x"
                cus[i].sar_limit = sar_limit
                cus[i].message = string("Control Unit with ID ", cus[i].id, " says: TASK DONE")
            end
        end
        return cus[x].message

    elseif command == "set_lead_off"
        print("Set lead-off threshold: ")
        lead_off = parse(Int,readline())
        x = 0 #initialize value in order to found the corresponding eAXON
        for i in 1:length(cus)
            if cus[i].id == id_cu
                x = i #assign the corresponding eAXON to "x"
                cus[i].lead_off = lead_off
                cus[i].message = string("Control Unit with ID ", cus[i].id, " says: TASK DONE")
            end
        end
        return cus[x].message

    elseif command == "get_sar"
        x = 0 #initialize value in order to found the corresponding eAXON
        for i in 1:length(cus)
            if cus[i].id == id_cu
                x = i #assign the corresponding eAXON to "x"
                cus[i].message = string("Control Unit with ID ", cus[i].id, " sends SAR LIMIT: ",cus[i].sar_limit)
            end
        end
        return cus[x].message

    elseif command == "get_lead_off"
        x = 0 #initialize value in order to found the corresponding eAXON
        for i in 1:length(cus)
            if cus[i].id == id_cu
                x = i #assign the corresponding eAXON to "x"
                cus[i].message = string("Control Unit with ID ", cus[i].id, " sends lead-off threshold: ",cus[i].lead_off)
            end
        end
        return cus[x].message
    end

end


####### COMMANDS FOR SECUNDARY NETWORK #######
#=
    fast_get_sample(id_eaxon) --> fet
    reset(id_eaxon) --> fet
    stop_sensing(id_eaxon) --> fet
    ping_FU(id_eaxon, id_cu) --> fet
    stimulate(id_eaxon, id_cu)
    start_sensing(id_eaxon, id_cu) --> fet
    get_sample(id_eaxon, id_cu)
    get_stimulation_conf(id_eaxon, id_cu)
    get_group_conf(id_Eaxon, id_cu)
    set_stimulation_conf(id_eaxon, id_cu, config)
    set_sensing_conf
    set_group_conf(id_eaxon, id_cu, id_group, config) --> fet
    set_uplink_limit()
    set_efuse()
    get_efuse()
=#

#if there is no group defined, send 0 in id_group field
function cu_fu(command,id_eaxon,id_cu,id_group)
    response = functional_unit_cu(command,id_eaxon,id_cu,id_group)
    println(response)
end
