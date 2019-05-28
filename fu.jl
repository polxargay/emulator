#************* Responses for the primary network *****************

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

#************* Responses for the secondary network *****************
function functional_unit_brain(command,id_eaxon,id_cu)

    if command == "reset"
        x = 0
        for i in 1:length(eaxons)
            if eaxons[i].id == id_eaxon && eaxons[i].cu_id == id_cu
                x = i
                eaxons[i].group = 0
                eaxons[i].message = string("eAXON with ID ", eaxons[i].id," says: TASK DONE")
            end
        end
        return eaxons[x].message

    elseif command == "stop_sensing"
        x = 0
        for i in 1:length(eaxons)
            if eaxons[i].id == id_eaxon && eaxons[i].cu_id == id_cu
                x = i
                eaxons[i].group = 0
                eaxons[i].message = string("eAXON with ID ", eaxons[i].id," sends ACK")
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
        x = 0 #initialize value in order to found the corresponding eAXON
        for i in 1:length(eaxons)
            if eaxons[i].id == id_eaxon && eaxons[i].cu_id == id_cu
                x = i #assign the corresponding eAXON to "x"
                eaxons[i].message = string("eaxon with ID ", eaxons[i].id, " sends ACK")
            end
        end
        return eaxons[x].message

    #=elseif command == "start_sensing"
        x = 0 #initialize value in order to found the corresponding eAXON
        for i in 1:length(eaxons)
            if (eaxons[i].id == id_eaxon or eaxons[i].group == id_eaxon) && eaxons[i].cu_id == id_cu
                if eaxons[i].id == id_eaxon
                    x = i #assign the corresponding eAXON to "x"
                    eaxons[i].message = string("eaxon with ID ", eaxons[i].id, " sends ACK")
                    return eaxons[x].message #return the ACK message
                elseif eaxons[i].group == id_eaxon
                    return null
                end
            end
        end=#

    end

end

function create_sample()
    #=for i in 1:length(eaxons)
        if eaxons[i].id == id_eaxon && eaxons[i].cu_id == id_cu
            #eaxons[i].group = 0
            push!(eaxons.samples[2],EAXON(id_eaxon,0,id_cu,["sample"],"ACK"))
        end
    end=#
    samples = String[]
    push!(samples,"sample")
end
