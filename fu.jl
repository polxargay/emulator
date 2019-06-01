#*******************************************************************
#************* RESPONSES FOR THE SECONDARY NETWORK *******************
#*******************************************************************
function functional_unit_brain(command,id_eaxon,id_cu)

    if command == "reset_fu"
        x = 0
        for i in 1:length(eaxons)
            if eaxons[i].id == id_eaxon && eaxons[i].cu_id == id_cu
                x = i
                eaxons[i].group = 0
                eaxons[i].message = string("eAXON with ID ", eaxons[i].id," says: TASK DONE")
            end
        end
        return eaxons[x].message

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

    end
end

#*******************************************************************
#************* RESPONSES FOR THE SECONDARY NETWORK *****************
#*******************************************************************
function functional_unit_cu_wo_payload(command,id_eaxon,id_cu,id_group,header_GCLAP)

    if command == "fast_sample"
        for i in 1:length(eaxons)
            if eaxons[i].id == id_eaxon && eaxons[i].cu_id == id_cu
                #return the last sample generated
                #f_sample = create_sample(1)
                sample = eaxons[i].samples[length(eaxons[1].samples)]
                return sample
            end
        end

    elseif command == "reset"
        for i in 1:length(eaxons)
            #single FU
            if (id_eaxon == eaxons[i].id) & (eaxons[i].cu_id == id_cu)
                eaxons[i].group = 0
                eaxons[i].samples = []
                eaxons[i].message = " "
                eaxons[i].sense_conf = " "
                eaxons[i].stimulation_conf = " "
                return string("eAXON with ID ", eaxons[i].id," sends ACK")
            #FU in the same group
            elseif (eaxons[i].cu_id == id_cu) & (id_group == eaxons[i].group)
                for j in 1:length(eaxons)
                    if (eaxons[j].cu_id == id_cu) & (eaxons[j].group == id_group)
                        eaxons[j].group = 0
                        eaxons[j].samples = []
                        eaxons[j].message = " "
                        eaxons[j].sense_conf = " "
                        eaxons[j].stimulation_conf = " "
                    end
                end
                return " "
            end
        end
        return string("eAXON with ID  sends ACK")

    elseif command == "stop_sensing"
        for i in 1:length(eaxons)
            if eaxons[i].id == id_eaxon && eaxons[i].cu_id == id_cu
                eaxons[i].group = 0
                eaxons[i].message = string("eAXON with ID ", eaxons[i].id," sends ACK")
                return eaxons[i].message
            end
        end

    elseif command == "ping_fu"
        for i in 1:length(eaxons)
            if eaxons[i].id == id_eaxon && eaxons[i].cu_id == id_cu
                eaxons[i].message = string("eAXON with ID ", eaxons[i].id," sends ACK")
                return eaxons[i].message
            end
        end

    elseif command == "stimulate"
        for i in 1:length(eaxons)
            if (id_eaxon == eaxons[i].id) & (eaxons[i].cu_id == id_cu)
                return " "
            elseif (eaxons[i].cu_id == id_cu) & (id_group == eaxons[i].group)
                return " "
            end
        end

    elseif command == "start_sensing"
        for i in 1:length(eaxons)
            if eaxons[i].id == id_eaxon && eaxons[i].cu_id == id_cu
                #create a number of samples between 40 and 100
                eaxons[i].samples = create_sample(rand(40:100))
                #define the message for the eaxon to deliver
                eaxons[i].message = string("eaxon with ID ", eaxons[i].id, " sends ACK")
                return eaxons[i].message
            end
        end

    elseif command == "get_sample"
        for i in 1:length(eaxons)
            if eaxons[i].id == id_eaxon && eaxons[i].cu_id == id_cu
                last_sample = eaxons[i].samples[length(eaxons[1].samples)]
                return last_sample
            end
        end

    elseif command == "get_stimulation_conf"
        for i in 1:length(eaxons)
            if eaxons[i].id == id_eaxon && eaxons[i].cu_id == id_cu
                return message = string("eAXON with ID ", eaxons[i].id, " sends stimulation configuration: ", eaxons[i].stimulation_conf)
            end
        end

    elseif command == "get_sensing_conf"
        for i in 1:length(eaxons)
            if eaxons[i].id == id_eaxon && eaxons[i].cu_id == id_cu
                eaxons[i].message = string("eAXON with ID ", eaxons[i].id, " sends sensing configuration: ", eaxons[i].sense_conf)
                return eaxons[i].message
            end
        end

    elseif command == "get_efuse"
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
            if eaxons[i].id == id_eaxon && eaxons[i].cu_id == id_cu
                eaxons[i].group = id_group
                eaxons[i].message = string("eaxon with ID ", eaxons[i].id, " sends ACK")
                return eaxons[i].message
            end
        end

    #set_stimulation_conf command (Anode - Cathode)
    elseif (payload == "00000000") & (header_IHCFP == "1010")
        for i in 1:length(eaxons)
            if (id_eaxon == eaxons[i].id) & (eaxons[i].cu_id == id_cu)
                eaxons[i].stimulation_conf = "00000000"
            elseif (eaxons[i].cu_id == id_cu) & (id_group == eaxons[i].group)
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
            if (id_eaxon == eaxons[i].id) & (eaxons[i].cu_id == id_cu)
                eaxons[i].stimulation_conf = "11111111"
            elseif (eaxons[i].cu_id == id_cu) & (id_group == eaxons[i].group)
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
            if (id_eaxon == eaxons[i].id) & (eaxons[i].cu_id == id_cu)
                eaxons[i].sense_conf = string(payload)
            #FU in the same group
            elseif (eaxons[i].cu_id == id_cu) & (id_group == eaxons[i].group)
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
            if (id_eaxon == eaxons[i].id) & (eaxons[i].cu_id == id_cu) & (eaxons[i].group == id_group)
                eaxons[i].message = string("eaxon with ID ", eaxons[i].id, " sends ACK")
                return eaxons[i].message
            elseif (id_eaxon == eaxons[i].id) & (eaxons[i].cu_id == id_cu) & (eaxons[i].group != id_group)
                return " "
            end
        end
    #get_group_conf command (is out of group?)
    elseif (SubString(payload,5,8) == "1111")&(header_IHCFP == "1001")
        for i in 1:length(eaxons)
            if (id_eaxon == eaxons[i].id) & (eaxons[i].cu_id == id_cu) & (eaxons[i].group == id_group)
                return " "
            elseif (id_eaxon == eaxons[i].id) & (eaxons[i].cu_id == id_cu) & (eaxons[i].group != id_group)
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

#create random samples
function create_sample(nsamples)
    samples = []
    for x in 1:nsamples
        push!(samples,"sample $(x)")
    end
    return samples
end
