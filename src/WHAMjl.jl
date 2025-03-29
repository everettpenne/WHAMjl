module WHAMjl

using PyCall

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

end # module WHAMjl
