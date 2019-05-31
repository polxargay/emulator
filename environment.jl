mutable struct EAXON
    id::Int64
    group::Int64
    cu_id::Int64
    samples::Vector{} #es pot posar com un array????????
    message
    sense_conf
    stimulation_conf
    EAXON(x,y,z) = new(x,y,z)
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
        push!(eaxons,EAXON(x,0,cu_id))
    end
    #println(eaxons)
    #return eaxons
end

function create_environment(ncu,neaxons)
    for x in 1:ncu
        push!(cus,CU(x,0,0))
        create_eaxon(neaxons,x)
    end
    println(eaxons)
end
