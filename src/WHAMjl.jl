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

"""
Get shinethru data from MDSplus tree
"""
function get_shinethru(shotnum::Int, treename::String="wham")
    tree = mds.Tree(treename, shotnum)
    basepath::String = "diag.shinethru.linedens.linedens_"
    impact_path = "diag.shinethru.linedens.detector_pos"

    impact_parameters = Vector{Vector{Float64}}()
    times = Vector{Vector{Float64}}()
    channels = Vector{Vector{Float64}}()

    impact_node = tree.getNode(impact_path)
    impact_parameters = Float64.(PyVector(impact_node.data()))

    for ch in 1:15
        if ch != 6
            absolutepath = basepath * @sprintf("%02d", ch)
            see_node = tree.getNode(absolutepath)
            ch_time = Float64.(PyVector(see_node.dim_of().data()))
            ch_data = Float64.(PyVector(see_node.data()))
            push!(times, ch_time)
            push!(channels, ch_data)
        end
    end

    #data = node.getData().data()
    return impact_parameters, times, channels
end

"""
Calculate the moment of a data sample distribution as found here: https://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.moment.html
Arguments:
	--> distribution x as vector
	--> specify which moment k (int) to take
	--> center c is a float, should match data type of x
"""
function moment(x::Vector{Float64}, k::Int, c::Float64=0)
    n = length(x) # Length of distribution (discrete variable)
    m::Float64 = nothing # Initialize moment m variable as no value
    for j in 1:n
	dm = x[j] - c
        m += dm ^ k
    end
    m = m / n
    return moment
end

export st, get_shinethru, title

end # module WHAMjl
