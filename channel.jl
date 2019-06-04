#this file represents the channel, in which some loses may occur
#lost packets (commands) will be simulated here

function channel()
    threshold = 0.2
    x = rand()
    if x >= threshold
        println(x)
        return true
    elseif x < threshold
        println(x)
        return false
    end
end
