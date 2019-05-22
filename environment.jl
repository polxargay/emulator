module Files
    include("brain.jl")
    include("cu.jl")
    include("fu.jl")
end

mutable struct EAXON
    id
    group
    cu_id
    message
    EAXON(x,y,z) = new(x,y,z,"ACK")
end

mutable struct CU
    id
    sar_limit
    lead_off
    message
    CU(x,y,z) = new(x,y,z,"message")
end

#Create an empty array of EAXON struct
eaxons = []
cus = []

function create_eaxon(neaxons,cu_id)
    for x in 1:neaxons
        #al final de l'array eaxons[], afegeixo els eaxons creats
        push!(eaxons,EAXON(x,0,0,cu_id))
    end
    #println(eaxons)
    #return eaxons
end

function create_environment(ncu,neaxons)
    for x in 1:ncu
        push!(cus,CU(x,0))
        create_eaxon(neaxons,x)
    end
    println(eaxons)
end
