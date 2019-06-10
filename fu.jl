#*******************************************************************
#************* RESPONSES FOR THE SECONDARY NETWORK *******************
#*******************************************************************
function functional_unit_brain(command,id_eaxon,id_cu,id_group)

    if command == "reset_fu"
        for i in 1:length(eaxons)
            #single FU
            if (id_eaxon == eaxons[i].id) & (eaxons[i].cu_id == id_cu) & (id_group == 0)
                eaxons[i].group = 0
                eaxons[i].samples = []
                eaxons[i].message = " "
                eaxons[i].sense_conf = " "
                eaxons[i].stimulation_conf = " "
                eaxons[i].sensing = false
                return string("eAXON with ID ", eaxons[i].id," sends ACK")
            #FUs in the same group
            elseif (id_eaxon == 0) & (eaxons[i].cu_id == id_cu) & (id_group == eaxons[i].group)
                for j in 1:length(eaxons)
                    if (eaxons[j].cu_id == id_cu) & (eaxons[j].group == id_group)
                        eaxons[j].group = 0
                        eaxons[j].samples = []
                        eaxons[j].message = " "
                        eaxons[j].sense_conf = " "
                        eaxons[j].stimulation_conf = " "
                        eaxons[j].sensing = false
                    end
                end
                return " "
            end
        end

    elseif command == "stop_fu"
        x = 0
        for i in 1:length(eaxons)
            if eaxons[i].id == id_eaxon && eaxons[i].cu_id == id_cu
                x = i
                eaxons[i].message = string("eAXON with ID ", eaxons[i].id," says: TASK DONE")
            end
        end
        return eaxons[x].message

    elseif command == "ping_fu"
        x = 0 #initialize value in order to found the corresponding eAXON
        for i in 1:length(eaxons)
            if eaxons[i].id == id_eaxon && eaxons[i].cu_id == id_cu
                x = i #assign the corresponding eAXON to "x"
                eaxons[i].message = string("eaxon with ID ", eaxons[i].id, " sends ACK")
            end
        end
        return eaxons[x].message #return the ACK message

    elseif command == "stimulate"

    end
end

#*******************************************************************
#************* RESPONSES FOR THE SECONDARY NETWORK *****************
#*******************************************************************

function functional_unit_cu_wo_payload(header_IHCFP,id_eaxon,id_cu,id_group,header_GCLAP)

    #fast_sample command
    if header_IHCFP == "0000"
        for i in 1:length(eaxons)
            if (eaxons[i].id == id_eaxon) & (eaxons[i].cu_id == id_cu) & (eaxons[i].sensing == true)
                #return the last sample generated
                #f_sample = create_sample(1)
                if length(eaxons[i].samples) <= 0
                    sample = create_sample(1,"00","00")
                    push!(eaxons[i].samples,sample)
                    sample = popfirst!(eaxons[i].samples)
                    if channel() == true
                        return sample
                    elseif channel() == false
                        return string("packet lost - uplink")
                    end
                elseif length(eaxons[i].samples) >= 0
                    sample = popfirst!(eaxons[i].samples)
                    if channel() == true
                        return sample
                    elseif channel() == false
                        return string("packet lost - uplink")
                    end
                end
            elseif (eaxons[i].id == id_eaxon) & (eaxons[i].cu_id == id_cu) & (eaxons[i].sensing == false)
                return string("FU is not sensing")
            end
        end
    #reset command
    elseif header_IHCFP == "0001"
        for i in 1:length(eaxons)
            #single FU
            if (id_eaxon == eaxons[i].id) & (eaxons[i].cu_id == id_cu) & (id_group == 0)
                eaxons[i].group = 0
                eaxons[i].samples = []
                eaxons[i].message = " "
                eaxons[i].sense_conf = " "
                eaxons[i].stimulation_conf = " "
                eaxons[i].sensing = false
                return string("eAXON with ID ", eaxons[i].id," sends ACK")
            #FU in the same group
            elseif (id_eaxon == 0) & (eaxons[i].cu_id == id_cu) & (id_group == eaxons[i].group)
                for j in 1:length(eaxons)

                    if (eaxons[j].cu_id == id_cu) & (eaxons[j].group == id_group)
                        eaxons[j].group = 0
                        eaxons[j].samples = []
                        eaxons[j].message = " "
                        eaxons[j].sense_conf = " "
                        eaxons[j].stimulation_conf = " "
                        eaxons[j].sensing = false
                    end
                end
                return " "
            end
        end
    #stop_sensing command
    elseif header_IHCFP == "0010"
        for i in 1:length(eaxons)
            if (eaxons[i].id == id_eaxon) & (eaxons[i].cu_id == id_cu) & (id_group == 0)
                eaxons[i].sensing = false
                eaxons[i].message = string("eAXON with ID ", eaxons[i].id," sends ACK")
                if channel() == true
                    return eaxons[i].message
                elseif channel() == false
                    return " "
                end
            elseif (id_eaxons == 0) & (eaxons[i].cu_id == id_cu) & (id_group == eaxons[i].group)
                eaxons[i].sensing = false
                return " "
            end
        end
    #ping_fu command
    elseif header_IHCFP == "0011"
        for i in 1:length(eaxons)
            if (eaxons[i].id == id_eaxon) & (eaxons[i].cu_id == id_cu)
                eaxons[i].message = string("eAXON with ID ", eaxons[i].id," sends ACK")
                if channel() == true#if there's no error transmition send the message
                    return eaxons[i].message
                elseif channel() == false#if there's a transmition error send error message (theoretically shouldn't send anything, but so I know what happened)
                    return string("packet lost - uplink")
                end
            end
        end
    #stimulate command
    elseif header_IHCFP == "0100"
        for i in 1:length(eaxons)
            if (id_eaxon == eaxons[i].id) & (eaxons[i].cu_id == id_cu)
                return " "
            elseif (eaxons[i].cu_id == id_cu) & (id_group == eaxons[i].group)
                return " "
            end
        end
    #start_sensing command
    elseif header_IHCFP == "0101"
        for i in 1:length(eaxons)
            if (id_eaxon == eaxons[i].id) & (eaxons[i].cu_id == id_cu) & (id_group == 0)
                if (SubString(eaxons[i].sense_conf,1,2) == "00") & (SubString(eaxons[i].sense_conf,3,4) == "00")
                    eaxons[i].sensing = true
                    sample = create_sample(250,SubString(eaxons[i].sense_conf,1,2),SubString(eaxons[i].sense_conf,5,8))
                    push!(eaxons[i].samples,sample)
                    eaxons[i].message = string("eaxon with ID ", eaxons[i].id, " sends ACK")
                    if channel() == true
                        return eaxons[i].message
                    elseif channel() == false
                        return " "
                    end
                elseif (SubString(eaxons[i].sense_conf,1,2) == "00") & (SubString(eaxons[i].sense_conf,3,4) == "01")
                    eaxons[i].sensing = true
                    samples,parameters = create_sample(500,SubString(eaxons[i].sense_conf,1,2),SubString(eaxons[i].sense_conf,5,8))
                    push!(eaxons[i].parameters,parameters)
                    push!(eaxons[i].samples,samples)
                    eaxons[i].message = string("eaxon with ID ", eaxons[i].id, " sends ACK")
                    return eaxons[i].message
                elseif (SubString(eaxons[i].sense_conf,1,2) == "00") & (SubString(eaxons[i].sense_conf,3,4) == "10")
                    eaxons[i].sensing = true
                    samples,parameters = create_sample(750,SubString(eaxons[i].sense_conf,1,2),SubString(eaxons[i].sense_conf,5,8))
                    push!(eaxons[i].parameters,parameters)
                    push!(eaxons[i].samples,samples)
                    eaxons[i].message = string("eaxon with ID ", eaxons[i].id, " sends ACK")
                    return eaxons[i].message
                elseif (SubString(eaxons[i].sense_conf,1,2) == "00") & (SubString(eaxons[i].sense_conf,3,4) == "11")
                    eaxons[i].sensing = true
                    samples,parameters = create_sample(1000,SubString(eaxons[i].sense_conf,1,2),SubString(eaxons[i].sense_conf,5,8))
                    push!(eaxons[i].parameters,parameters)
                    push!(eaxons[i].samples,samples)
                    eaxons[i].message = string("eaxon with ID ", eaxons[i].id, " sends ACK")
                    return eaxons[i].message
                elseif (SubString(eaxons[i].sense_conf,1,2) == "01") & (SubString(eaxons[i].sense_conf,3,4) == "00")
                    eaxons[i].sensing = true
                    samples,parameters = create_sample(250,SubString(eaxons[i].sense_conf,1,2),SubString(eaxons[i].sense_conf,5,8))
                    push!(eaxons[i].parameters,parameters)
                    push!(eaxons[i].samples,samples[1])
                    eaxons[i].message = string("eaxon with ID ", eaxons[i].id, " sends ACK")
                    return eaxons[i].message
                elseif (SubString(eaxons[i].sense_conf,1,2) == "01") & (SubString(eaxons[i].sense_conf,3,4) == "01")
                    eaxons[i].sensing = true
                    samples,parameters = create_sample(500,SubString(eaxons[i].sense_conf,1,2),SubString(eaxons[i].sense_conf,5,8))
                    push!(eaxons[i].parameters,parameters)
                    push!(eaxons[i].samples,samples)
                    eaxons[i].message = string("eaxon with ID ", eaxons[i].id, " sends ACK")
                    return eaxons[i].message
                elseif (SubString(eaxons[i].sense_conf,1,2) == "01") & (SubString(eaxons[i].sense_conf,3,4) == "10")
                    eaxons[i].sensing = true
                    samples,parameters = create_sample(750,SubString(eaxons[i].sense_conf,1,2),SubString(eaxons[i].sense_conf,5,8))
                    push!(eaxons[i].parameters,parameters)
                    push!(eaxons[i].samples,samples)
                    eaxons[i].message = string("eaxon with ID ", eaxons[i].id, " sends ACK")
                    return eaxons[i].message
                elseif (SubString(eaxons[i].sense_conf,1,2) == "01") & (SubString(eaxons[i].sense_conf,3,4) == "11")
                    eaxons[i].sensing = true
                    samples,parameters = create_sample(1000,SubString(eaxons[i].sense_conf,1,2),SubString(eaxons[i].sense_conf,5,8))
                    push!(eaxons[i].parameters,parameters)
                    push!(eaxons[i].samples,samples)
                    eaxons[i].message = string("eaxon with ID ", eaxons[i].id, " sends ACK")
                    return eaxons[i].message
                elseif (SubString(eaxons[i].sense_conf,1,2) == "10") & (SubString(eaxons[i].sense_conf,3,4) == "00")
                    eaxons[i].sensing = true
                    samples,parameters = create_sample(250,SubString(eaxons[i].sense_conf,1,2),SubString(eaxons[i].sense_conf,5,8))
                    push!(eaxons[i].parameters,parameters)
                    push!(eaxons[i].samples,samples)
                    eaxons[i].message = string("eaxon with ID ", eaxons[i].id, " sends ACK")
                    return eaxons[i].message
                elseif (SubString(eaxons[i].sense_conf,1,2) == "10") & (SubString(eaxons[i].sense_conf,3,4) == "01")
                    eaxons[i].sensing = true
                    samples,parameters = create_sample(500,SubString(eaxons[i].sense_conf,1,2),SubString(eaxons[i].sense_conf,5,8))
                    push!(eaxons[i].parameters,parameters)
                    push!(eaxons[i].samples,samples)
                    eaxons[i].message = string("eaxon with ID ", eaxons[i].id, " sends ACK")
                    return eaxons[i].message
                elseif (SubString(eaxons[i].sense_conf,1,2) == "10") & (SubString(eaxons[i].sense_conf,3,4) == "10")
                    eaxons[i].sensing = true
                    samples,parameters = create_sample(750,SubString(eaxons[i].sense_conf,1,2),SubString(eaxons[i].sense_conf,5,8))
                    push!(eaxons[i].parameters,parameters)
                    push!(eaxons[i].samples,samples)
                    eaxons[i].message = string("eaxon with ID ", eaxons[i].id, " sends ACK")
                    return eaxons[i].message
                elseif (SubString(eaxons[i].sense_conf,1,2) == "10") & (SubString(eaxons[i].sense_conf,3,4) == "11")
                    eaxons[i].sensing = true
                    samples,parameters = create_sample(1000,SubString(eaxons[i].sense_conf,1,2),SubString(eaxons[i].sense_conf,5,8))
                    push!(eaxons[i].parameters,parameters)
                    push!(eaxons[i].samples,samples)
                    eaxons[i].message = string("eaxon with ID ", eaxons[i].id, " sends ACK")
                    return eaxons[i].message
                end
            elseif (id_eaxon == 0) & (eaxons[i].cu_id == id_cu) & (id_group == eaxons[i].group)
                for j in 1:length(eaxons)
                    if (eaxons[j].cu_id == id_cu) & (eaxons[j].group == id_group)
                        if (SubString(eaxons[j].sense_conf,1,2) == "00") & (SubString(eaxons[j].sense_conf,3,4) == "00")
                            eaxons[j].sensing = true
                            sample = create_sample(250,SubString(eaxons[j].sense_conf,1,2),SubString(eaxons[j].sense_conf,5,8))
                            push!(eaxons[j].samples,sample)
                        elseif (SubString(eaxons[j].sense_conf,1,2) == "00") & (SubString(eaxons[j].sense_conf,3,4) == "01")
                            eaxons[j].sensing = true
                            sample = create_sample(500,SubString(eaxons[j].sense_conf,1,2),SubString(eaxons[j].sense_conf,5,8))
                            push!(eaxons[j].samples,sample)
                        elseif (SubString(eaxons[j].sense_conf,1,2) == "00") & (SubString(eaxons[j].sense_conf,3,4) == "10")
                            eaxons[j].sensing = true
                            sample = create_sample(750,SubString(eaxons[j].sense_conf,1,2),SubString(eaxons[j].sense_conf,5,8))
                            push!(eaxons[j].samples,sample)
                        elseif (SubString(eaxons[j].sense_conf,1,2) == "00") & (SubString(eaxons[j].sense_conf,3,4) == "11")
                            eaxons[j].sensing = true
                            sample = create_sample(1000,SubString(eaxons[j].sense_conf,1,2),SubString(eaxons[j].sense_conf,5,8))
                            push!(eaxons[j].samples,sample)
                        elseif (SubString(eaxons[j].sense_conf,1,2) == "01") & (SubString(eaxons[j].sense_conf,3,4) == "00")
                            eaxons[j].sensing = true
                            sample = create_sample(250,SubString(eaxons[j].sense_conf,1,2),SubString(eaxons[j].sense_conf,5,8))
                            push!(eaxons[j].samples,sample)
                        elseif (SubString(eaxons[j].sense_conf,1,2) == "01") & (SubString(eaxons[j].sense_conf,3,4) == "01")
                            eaxons[j].sensing = true
                            sample = create_sample(500,SubString(eaxons[j].sense_conf,1,2),SubString(eaxons[j].sense_conf,5,8))
                            push!(eaxons[j].samples,sample)
                        elseif (SubString(eaxons[j].sense_conf,1,2) == "01") & (SubString(eaxons[j].sense_conf,3,4) == "10")
                            eaxons[j].sensing = true
                            sample = create_sample(750,SubString(eaxons[j].sense_conf,1,2),SubString(eaxons[j].sense_conf,5,8))
                            push!(eaxons[j].samples,sample)
                        elseif (SubString(eaxons[j].sense_conf,1,2) == "01") & (SubString(eaxons[j].sense_conf,3,4) == "11")
                            eaxons[j].sensing = true
                            sample = create_sample(1000,SubString(eaxons[j].sense_conf,1,2),SubString(eaxons[j].sense_conf,5,8))
                            push!(eaxons[j].samples,sample)
                        elseif (SubString(eaxons[j].sense_conf,1,2) == "11") & (SubString(eaxons[j].sense_conf,3,4) == "00")
                            eaxons[j].sensing = true
                            sample = create_sample(250,SubString(eaxons[j].sense_conf,1,2),SubString(eaxons[j].sense_conf,5,8))
                            push!(eaxons[j].samples,sample)
                        elseif (SubString(eaxons[j].sense_conf,1,2) == "11") & (SubString(eaxons[j].sense_conf,3,4) == "01")
                            eaxons[j].sensing = true
                            sample = create_sample(500,SubString(eaxons[j].sense_conf,1,2),SubString(eaxons[j].sense_conf,5,8))
                            push!(eaxons[j].samples,sample)
                        elseif (SubString(eaxons[j].sense_conf,1,2) == "11") & (SubString(eaxons[j].sense_conf,3,4) == "10")
                            eaxons[j].sensing = true
                            sample = create_sample(750,SubString(eaxons[j].sense_conf,1,2),SubString(eaxons[j].sense_conf,5,8))
                            push!(eaxons[j].samples,sample)
                        elseif (SubString(eaxons[j].sense_conf,1,2) == "11") & (SubString(eaxons[j].sense_conf,3,4) == "11")
                            eaxons[j].sensing = true
                            sample = create_sample(1000,SubString(eaxons[j].sense_conf,1,2),SubString(eaxons[j].sense_conf,5,8))
                            push!(eaxons[j].samples,sample)
                        end
                    end
                end
                return " "
            end
        end
    #get_sample command
    elseif header_IHCFP == "0110"
        for i in 1:length(eaxons)
            if (eaxons[i].id == id_eaxon) & (eaxons[i].cu_id == id_cu) & (SubString(eaxons[i].sense_conf,1,2) == "00")
                #last_sample = eaxons[i].samples[length(eaxons[i].samples)]
                sample = popfirst!(eaxons[i].samples)
                return sample
            elseif (eaxons[i].id == id_eaxon) & (eaxons[i].cu_id == id_cu) & (SubString(eaxons[i].sense_conf,1,2) != ("00"))
                parameter = popfirst!(eaxons[i].parameters[1])
                eaxons[i].samples = []
                return parameter
            end
        end
    #get_stimulation_conf command
    elseif header_IHCFP == "0111"
        for i in 1:length(eaxons)
            if (eaxons[i].id == id_eaxon) & (eaxons[i].cu_id == id_cu)
                eaxons[i].message = string("eAXON with ID ", eaxons[i].id, " sends stimulation configuration: ", eaxons[i].stimulation_conf)
                return eaxons[i].message
            end
        end
    #get_sensing_conf command
    elseif header_IHCFP == "1000"
        for i in 1:length(eaxons)
            if eaxons[i].id == id_eaxon && eaxons[i].cu_id == id_cu
                eaxons[i].message = string("eAXON with ID ", eaxons[i].id, " sends sensing configuration: ", eaxons[i].sense_conf)
                return eaxons[i].message
            end
        end
    #get_efuse command
    elseif header_IHCFP == "1111"
        for i in 1:length(eaxons)
            if eaxons[i].id == id_eaxon && eaxons[i].cu_id == id_cu
                eaxons[i].message = string("eAXON with ID ", eaxons[i].id, " sends efuse value: ", eaxons[i].efuse_value)
                return eaxons[i].message
            end
        end
    end
end

function functional_unit_cu_w_payload(id_eaxon,id_cu,id_group,payload,header_IHCFP,header_GCLAP)

    #set_group_conf command --> remove from group
    if (payload == "0000") & (header_IHCFP == "1100")
        for i in 1:length(eaxons)
            if (eaxons[i].id == id_eaxon) & (eaxons[i].cu_id == id_cu)
                eaxons[i].group = 0
                eaxons[i].message = string("eaxon with ID ", eaxons[i].id, " sends ACK")
                return eaxons[i].message
            end
        end
    #set_group_conf command --> add to group
    elseif (payload == "1111") & (header_IHCFP == "1100")
        for i in 1:length(eaxons)
            if (eaxons[i].id == id_eaxon) & (eaxons[i].cu_id == id_cu)
                eaxons[i].group = id_group
                eaxons[i].message = string("eaxon with ID ", eaxons[i].id, " sends ACK")
                return eaxons[i].message
            end
        end

    #set_stimulation_conf command (Anode - Cathode)
    elseif (payload == "00000000") & (header_IHCFP == "1010")
        for i in 1:length(eaxons)
            if (id_eaxon == eaxons[i].id) & (eaxons[i].cu_id == id_cu) & (id_group == 0)
                eaxons[i].stimulation_conf = "00000000"
            elseif (id_eaxon == 0) & (eaxons[i].cu_id == id_cu) & (id_group == eaxons[i].group)
                for j in 1:length(eaxons)
                    if (eaxons[j].cu_id == id_cu) & (eaxons[j].group == id_group)
                        eaxons[j].stimulation_conf = "00000000"
                    end
                end
            end
        end
    #set_stimulation_conf command (Cathode - Anode)
    elseif (payload == "11111111") & (header_IHCFP == "1010")
        for i in 1:length(eaxons)
            if (id_eaxon == eaxons[i].id) & (eaxons[i].cu_id == id_cu) & (id_group == 0)
                eaxons[i].stimulation_conf = "11111111"
            elseif (id_eaxon == 0) & (eaxons[i].cu_id == id_cu) & (id_group == eaxons[i].group)
                for j in 1:length(eaxons)
                    if (eaxons[j].cu_id == id_cu) & (eaxons[j].group == id_group)
                        eaxons[j].stimulation_conf = "11111111"
                    end
                end
            end
        end

    #set_sensing_conf command
    elseif (header_IHCFP == "1011")
        for i in 1:length(eaxons)
            #Single FU
            if (id_eaxon == eaxons[i].id) & (eaxons[i].cu_id == id_cu) & (id_group == 0)
                eaxons[i].sense_conf = string(payload)
            #FU in the same group
            elseif (id_eaxon == 0) & (eaxons[i].cu_id == id_cu) & (id_group == eaxons[i].group)
                for j in 1:length(eaxons)
                    if (eaxons[j].cu_id == id_cu) & (eaxons[j].group == id_group)
                        eaxons[j].sense_conf = string(payload)
                    end
                end
            end
        end

    #get_group_conf command (is in group?)
    elseif (SubString(payload,5,8) == "0000")&(header_IHCFP == "1001")
        for i in 1:length(eaxons)
            if (id_eaxon == eaxons[i].id) & (eaxons[i].cu_id == id_cu) & (id_group == eaxons[i].group)
                eaxons[i].message = string("eaxon with ID ", eaxons[i].id, " sends ACK")
                return eaxons[i].message
            elseif (id_eaxon == eaxons[i].id) & (eaxons[i].cu_id == id_cu) & (id_group != eaxons[i].group)
                return " "
            end
        end
    #get_group_conf command (is out of group?)
    elseif (SubString(payload,5,8) == "1111")&(header_IHCFP == "1001")
        for i in 1:length(eaxons)
            if (id_eaxon == eaxons[i].id) & (eaxons[i].cu_id == id_cu) & (id_group != eaxons[i].group)
                return " "
            elseif (id_eaxon == eaxons[i].id) & (eaxons[i].cu_id == id_cu) & (id_group == eaxons[i].group)
                eaxons[i].message = string("eaxon with ID ", eaxons[i].id, " sends ACK")
                return eaxons[i].message
            end
        end

    #set_uplink_limit command
    elseif (header_IHCFP == "1101")
        for i in 1:length(eaxons)
            if (id_eaxon == eaxons[i].id) & (eaxons[i].cu_id == id_cu)
                eaxons[i].uplink_limit = payload
            end
        end

    #set_efuse
    elseif (header_IHCFP == "1110") & (SubString(header_GCLAP,2,2)=="1")
        for i in 1:length(eaxons)
            if (id_eaxon == eaxons[i].id) & (eaxons[i].cu_id == id_cu)
                eaxons[i].efuse_value = payload
            end
        end

    end
end

#create samples
function create_sample(nsamples,mode,window)
    samples = []
    parameters = []
    window = parse(Int,window,base=2)
    j=window+1#counter in order to know when we have reached the window limit

    if mode == "00"#raw mode
        for x in 1:nsamples
            push!(samples,"sample $(x)")
        end
        return samples
    elseif mode == "01"#Param. RMS
        for x in 1:window
            push!(samples,"sample $(x)")
            if x == window
                while j <= nsamples
                    push!(parameters,"RAW parameter $(j)")
                    j = j+window
                end
            end
        end
        return samples,parameters
    elseif mode == "10"#Param. zero-crossings
        for x in 1:window
            push!(samples,"sample $(x)")
            if x == window
                while j <= nsamples
                    push!(parameters,"zero-crossing parameter $(j)")
                    j = j+window#increment j+window so we will have samples every time we reach "window"
                end
            end
        end
        return samples,parameters
    end
end
