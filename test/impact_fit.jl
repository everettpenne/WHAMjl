include("../src/WHAMjl.jl")

using .WHAMjl

tree = "wham"
shots = [250324094]

scan_times = [1, 15000, 20000, 25000, 30000, 35000, 39999]

for shot in shots
    impact_parameters, times, channels = get_shinethru(shot)
    println("Processing shot: ", shot)
    println("Total Impact Parameters: ", length(impact_parameters))
    println("Number of time points: ", length(times[1]))
    println("Number of channels: ", length(channels))

    #println(channels[1][1:100])
    #println(impact_parameters)

    for t in scan_times
        scan = []
        for ch in channels
            push!(scan, ch[t])
        end
        #println("Scan time: ", t)
        #println(string(scan))
    end

end
