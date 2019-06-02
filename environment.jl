mutable struct EAXON
    id::Int64
    group::Int64
    cu_id::Int64
    samples #es pot posar com un array????????
    message
    sense_conf
    stimulation_conf
    uplink_limit
    efuse_value
    sensing::Bool
    EAXON(x,y,z,j) = new(x,y,z,j)
end

mutable struct CU
    id::Int64
    sar_limit::Int64
    lead_off::Int64
    message
    CU(x,y,z) = new(x,y,z)
end

#Create an empty array of EAXON struct
eaxons = EAXON[]
cus = CU[]

function create_eaxon(neaxons,cu_id)
    for x in 1:neaxons
        #al final de l'array eaxons[], afegeixo els eaxons creats
        push!(eaxons,EAXON(x,0,cu_id,[]))
    end
    #println(eaxons)
    #return eaxons
end

#=function initialize_values(ncu,neaxons)
    for i in 1:ncu
        for j in 1:neaxons
            if (eaxons[j].id == j) & (eaxons[j].cu_id == i)
                eaxons[j].samples = []
            end

        end
    end
end=#

function create_environment(ncu,neaxons)
    for x in 1:ncu
        push!(cus,CU(x,0,0))
        create_eaxon(neaxons,x)
    end
    println(eaxons)
end
