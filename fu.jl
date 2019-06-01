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
function functional_unit_cu_wo_payload(command,id_eaxon,id_cu,id_group)

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
            if (eaxons[i].id == id_eaxon) & (eaxons[i].cu_id == id_cu) & (id_group == 0)
                eaxons[i].group = 0
                eaxons[i].samples = []
                eaxons[i].message = " "
                eaxons[i].sense_conf = " "
                eaxons[i].stimulation_conf = " "
                return string("eAXON with ID ", eaxons[i].id," sends ACK")
            elseif (eaxons[i].id == id_eaxon) & (eaxons[i].cu_id == id_cu) & (id_group != 0)
                for j in 1:length(eaxons)
                    if (eaxons[j].id == id_eaxon) & (eaxons[j].cu_id == id_cu) & (eaxons[j].group == id_group)
                        eaxons[i].group = 0
                        eaxons[i].samples = []
                        eaxons[i].message = " "
                        eaxons[i].sense_conf = " "
                        eaxons[i].stimulation_conf = " "
                    end
                end

            end
        end

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
            if eaxons[i].id == id_eaxon && eaxons[i].cu_id == id_cu

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
                return message = string("eAXON with ID ", eaxons[i].id, " sends sensing configuration: ", eaxons[i].sense_conf)
            end
        end

    end
end

function functional_unit_cu_w_payload(id_eaxon,id_cu,id_group,payload,header)

    #set_group_conf command
    if (payload == "0000") & (header == 1100)
        for i in 1:length(eaxons)
            if eaxons[i].id == id_eaxon && eaxons[i].cu_id == id_cu
                eaxons[i].group = 0
                eaxons[i].message = string("eaxon with ID ", eaxons[i].id, " sends ACK")
                return eaxons[i].message
            end
        end
    elseif (payload == "1111") & (header == 1100)
        for i in 1:length(eaxons)
            if eaxons[i].id == id_eaxon && eaxons[i].cu_id == id_cu
                eaxons[i].group = id_group
                eaxons[i].message = string("eaxon with ID ", eaxons[i].id, " sends ACK")
                return eaxons[i].message
            end
        end

    #set_stimulation_conf command
    elseif (payload == "00000000") & (header == 1010)
        for i in 1:length(eaxons)
            if eaxons[i].id == id_eaxon && eaxons[i].cu_id == id_cu
                eaxons[i].stimulation_conf = "00000000: Anode - Cathode"
            end
        end

    elseif (payload == "11111111") & (header == 1010)
        for i in 1:length(eaxons)
            if eaxons[i].id == id_eaxon && eaxons[i].cu_id == id_cu
                eaxons[i].stimulation_conf = "11111111: Cathode – Anode"
            end
        end

    #set_sensing_conf command
    elseif header == 1011
        #*****set sensing conf in the eAXON******
        for i in 1:length(eaxons)
            if eaxons[i].id == id_eaxon && eaxons[i].cu_id == id_cu
                eaxons[i].sense_conf = string(payload)
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
