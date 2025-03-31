module WHAMjl

using PyCall
using Printf
mds = pyimport("MDSplus")

default_tree::String = "wham"

# Import MDSplus using Python (as long as Python has it installed)
mds = pyimport("MDSplus")

title() = print(
    "      _____        ___   _    _    __  __  ___
    / \\  \\ \\      / | | | |  / \\  |  \\/  |/ \\ \\
    | | | \\ \\ /\\ / /| |_| | / _ \\ | |\\/| | | | |
    | | | |\\ V  V / |  _  |/ ___ \\| |  | | | | |
    | | | | \\_/\\_/  |_| |_/_/   \\_|_|  |_| .jl |
     \\_/_/                                \\_/_/\n"
)

title()

"""
Shinethru MDS data structure.
ips -- impact parameter, Vector{Float64} for channels 1-15
ch -- shinethru channels, Vector{Vector{Float64}} for channel data arrays 1-15
time -- channel times, Vector{Vector{Float64}}
"""
struct st
    ips::Vector{Float64} # Only Float64 values allowed (Impact Parameter)
    ch::Vector{Vector{Float64}}  # Only Float64 arrays allowed (Channels 1-15 data arrays)
    time::Vector{Vector{Float64}} # Only Float64 arrays allowed (Channels 1-15 data arrays)
end

function get_shinethru(treename::String=default_tree, shotnum::Int)
    tree = mds.Tree(treename, shotnum)
    basepath::String = "diag.shinethru.linedens.linedens_"

    times = Vector{Vector{Float64}}()
    channels = Vector{Vector{Float64}}()

    for ch in 1:15
        if ch != 6
            absolutepath = basepath * @sprintf("%02d", ch)
            see_node = tree.getNode(absolutepath)
            ch_time = see_node.dim_of().getData()
            ch_data = see_node.dim_of().getData()
            push!(times, ch_time)
            push!(channels, ch_data)
        end
    end

    #data = node.getData().data()
    return times, channels
end

end # module WHAMjl
