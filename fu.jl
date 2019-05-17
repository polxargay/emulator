function send_ACK_FU(id_eaxon,id_cu)
    for i in 1:length(eaxons)
        if eaxons[i].id == id_eaxon && eaxons[i].cu_id == id_cu
            println("eAXON with id ", eaxons[i].id, " sends ACK ")
        end
    end
end

function sensing(id_eaxon,id_cu)


end
