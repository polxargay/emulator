function send_ACK_FU(id_eaxon,id_cu)
    x = 0 #initialize value in order to found the corresponding eAXON
    for i in 1:length(eaxons)
        if eaxons[i].id == id_eaxon && eaxons[i].cu_id == id_cu
            x = i #assign the corresponding eAXON to "x"
            eaxons[i].message = string("eaxon with ID ", eaxons[i].id, " sends ACK")
        end
    end
    return eaxons[x].message #return the ACK message
end

function functional_unit(command,id_eaxon,id_cu)

end
