function send_ACK_CU(id_cu)
    for i in 1:length(cus)
        if cus[i].id == id_cu
            println("CU with id ", cus[i].id, " sends ACK ")
        end
    end
end
