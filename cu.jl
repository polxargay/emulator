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
    fast_get_sample --> fet
    reset --> fet
    stop_sensing --> fet
    ping_FU --> fet
    stimulate --> no sé què he de simular per fer aquest estimulació
    start_sensing --> fet --> falta definir com fer servir la Window!!!!!!
    get_sample --> fet
    get_stimulation_conf --> fet
    get_sensing_conf --> fet
    get_group_conf --> fet
    set_stimulation_conf --> fet
    set_sensing_conf --> fet
    set_group_conf --> fet
    set_uplink_limit() --> fet
    set_efuse() --> fet
    get_efuse() --> fet
=#


#if there is no group defined, must put 0 in id_group field
function cu_fu(command,id_eaxon,id_cu,id_group)
    payload = " " #initialize payload variable
    header_IHCFP = " " #initialize header variable
    header_GCLAP = " " #Initialize GCLAP header

    #initialize variables for the set_sensing_conf command
    mode = ""
    freq = ""
    window = ""
    data = ""

    ##**************Commands which don't need payload***************
    if (command == "fast_sample")
        header_GCLAP = "01"
        header_IHCFP = "0000"
        if channel() == true
            #println("true")
            response = functional_unit_cu_wo_payload(header_IHCFP,id_eaxon,id_cu,id_group,header_GCLAP)
            println(response)
        elseif channel() == false
            println("packet lost - downlink")
        end
    elseif command == "reset"
        header_GCLAP = "01"
        header_IHCFP = "0001"
        response = functional_unit_cu_wo_payload(header_IHCFP,id_eaxon,id_cu,id_group,header_GCLAP)
        println(response)
    elseif command == "stop_sensing"
        header_GCLAP = "01"
        header_IHCFP = "0010"
        response = functional_unit_cu_wo_payload(header_IHCFP,id_eaxon,id_cu,id_group,header_GCLAP)
        println(response)
    elseif command =="ping_fu"
        header_GCLAP = "01"
        header_IHCFP = "0011"
        if channel() == true
            response = functional_unit_cu_wo_payload(header_IHCFP,id_eaxon,id_cu,id_group,header_GCLAP)
            println(response)
        elseif channel() == false
            println("packet lost - downlink")
        end
    elseif command =="stimulate"
        header_GCLAP = "01"
        header_IHCFP = "0100"
        response = functional_unit_cu_wo_payload(header_IHCFP,id_eaxon,id_cu,id_group,header_GCLAP)
        println(response)
    elseif command =="start_sensing"
        header_GCLAP = "01"
        header_IHCFP = "0101"
        response = functional_unit_cu_wo_payload(header_IHCFP,id_eaxon,id_cu,id_group,header_GCLAP)
        println(response)
    elseif command == "get_sample"
        header_GCLAP = "01"
        header_IHCFP = "0110"
        response = functional_unit_cu_wo_payload(header_IHCFP,id_eaxon,id_cu,id_group,header_GCLAP)
        println(response)
    elseif command =="get_stimulation_conf"
        header_GCLAP = "01"
        header_IHCFP = "0111"
        response = functional_unit_cu_wo_payload(header_IHCFP,id_eaxon,id_cu,id_group,header_GCLAP)
        println(response)
    elseif command == "get_sensing_conf"
        header_GCLAP = "01"
        header_IHCFP = "1000"
        response = functional_unit_cu_wo_payload(header_IHCFP,id_eaxon,id_cu,id_group,header_GCLAP)
        println(response)
    elseif command == "get_efuse"
        header_GCLAP = "01"
        header_IHCFP = "1111"
        response = functional_unit_cu_wo_payload(header_IHCFP,id_eaxon,id_cu,id_group,header_GCLAP)
        println(response)

    ##***************Commands which need payload*****************

    elseif command == "get_group_conf"
        header_IHCFP = "1001"
        header_GCLAP = "10"
        group = string(id_group, base = 2, pad = 4)
        print("Press 0 for asking 'is in group' || Press 1 for asking 'is out of group': ")
        in_out = parse(Int,readline())

        if in_out == 0
            payload = string(group,"0000")
        elseif in_out == 1
            payload = string(group,"1111")
        end

        response = functional_unit_cu_w_payload(id_eaxon,id_cu,id_group,payload,header_IHCFP,header_GCLAP)
        println(response)
    elseif command == "set_stimulation_conf"
        header_IHCFP = "1010"
        header_GCLAP = "10"
        print("Assign stimulation configuration to this eAXON (0 for Anode - Cathode || 1 for Cathode - Anode): ")
        stim_conf = parse(Int,readline())

        if stim_conf == 0
            payload = "00000000"
        elseif stim_conf == 1
            payload = "11111111"
        end

        functional_unit_cu_w_payload(id_eaxon,id_cu,id_group,payload,header_IHCFP,header_GCLAP)
    elseif command == "set_sensing_conf"
        header_IHCFP = "1011"
        header_GCLAP = "10"
        print("Choose Mode 1-Raw, 2-Param RMS or 3-Param zero-crossin: ")
        mode = parse(Int,readline())
        print("Choose sampling frequence 1-250 S/s, 2-500 S/s, 3-750 S/s, 4-1000 S/s: ")
        freq = parse(Int,readline())
        print("Choose window (max 15): ")
        window = parse(Int,readline())
        #sense_conf = SENSE_CONF(mode,freq,window)
        #functional_unit_cu_w_payload(id_eaxon,id_cu,id_group,sense_conf,header)

        if (mode == 1) & (freq == 1)
            data = "0000"
            payload = create_payload(data,window)
            functional_unit_cu_w_payload(id_eaxon,id_cu,id_group,payload,header_IHCFP,header_GCLAP)
        elseif (mode == 1) & (freq == 2)
            data = "0001"
            payload = create_payload(data,window)
            functional_unit_cu_w_payload(id_eaxon,id_cu,id_group,payload,header_IHCFP,header_GCLAP)
        elseif (mode == 1) & (freq == 3)
            data = "0010"
            payload = create_payload(data,window)
            functional_unit_cu_w_payload(id_eaxon,id_cu,id_group,payload,header_IHCFP,header_GCLAP)
        elseif (mode == 1) & (freq == 4)
            data = "0011"
            payload = create_payload(data,window)
            functional_unit_cu_w_payload(id_eaxon,id_cu,id_group,payload,header_IHCFP,header_GCLAP)
        elseif (mode == 2) & (freq == 1)
            data = "0100"
            payload = create_payload(data,window)
            functional_unit_cu_w_payload(id_eaxon,id_cu,id_group,payload,header_IHCFP,header_GCLAP)
        elseif (mode == 2) & (freq == 2)
            data = "0101"
            payload = create_payload(data,window)
            functional_unit_cu_w_payload(id_eaxon,id_cu,id_group,payload,header_IHCFP,header_GCLAP)
        elseif (mode == 2) & (freq == 3)
            data = "0110"
            payload = create_payload(data,window)
            functional_unit_cu_w_payload(id_eaxon,id_cu,id_group,payload,header_IHCFP,header_GCLAP)
        elseif (mode == 2) & (freq == 4)
            data = "0111"
            payload = create_payload(data,window)
            functional_unit_cu_w_payload(id_eaxon,id_cu,id_group,payload,header_IHCFP,header_GCLAP)
        elseif (mode == 3) & (freq == 1)
            data = "1000"
            payload = create_payload(data,window)
            functional_unit_cu_w_payload(id_eaxon,id_cu,id_group,payload,header_IHCFP,header_GCLAP)
        elseif (mode == 3) & (freq == 2)
            data = "1001"
            payload = create_payload(data,window)
            functional_unit_cu_w_payload(id_eaxon,id_cu,id_group,payload,header_IHCFP,header_GCLAP)
        elseif (mode == 3) & (freq == 3)
            data = "1010"
            payload = create_payload(data,window)
            functional_unit_cu_w_payload(id_eaxon,id_cu,id_group,payload,header_IHCFP,header_GCLAP)
        elseif (mode == 3) & (freq == 4)
            data = "1011"
            payload = create_payload(data,window)
            functional_unit_cu_w_payload(id_eaxon,id_cu,id_group,payload,header_IHCFP,header_GCLAP)
        end
    elseif command == "set_group_conf"
        header_IHCFP = "1100"
        header_GCLAP = "10"
        print("Assign group to the eAXON (press 0 if you want to remove from group): ")
        group = parse(Int,readline())

        if group == 0
            payload = "0000"
        elseif group != 0
            payload = "1111"
        end

        response = functional_unit_cu_w_payload(id_eaxon,id_cu,group,payload,header_IHCFP,header_GCLAP)
        println(response)
    elseif command == "set_uplink_limit"
        header_IHCFP = "1101"
        header_GCLAP = "10"
        print("Set uplink limit (max 255mA): ")
        uplink_limit = parse(Int,readline())
        uplink_limit = string(uplink_limit,base=2,pad=8)
        payload = uplink_limit

        functional_unit_cu_w_payload(id_eaxon,id_cu,id_group,payload,header_IHCFP,header_GCLAP)
    elseif command == "set_efuse"
        header_IHCFP = "1110"
        header_GCLAP = "11"
        print("Set eFUSE value (max 4294967295): ")
        efuse_value = parse(Int,readline())
        efuse_value = string(efuse_value,base=2,pad=32)
        payload = efuse_value

        functional_unit_cu_w_payload(id_eaxon,id_cu,id_group,payload,header_IHCFP,header_GCLAP)
    end
end

#create payload for set_sensing_conf
function create_payload(data,wind)
    window = string(wind,base=2,pad=4)
    payload = string(data,window)
    return payload
end
