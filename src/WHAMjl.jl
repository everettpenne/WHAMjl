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
Note that detectors indexed 11, 14 (+/- 0.01488); 12, 13 (+/- 0.00744);
are the "horizontal" detectors in the array (11, 14 are the tips of the +)
Detector 1 (0.09792) and Detector 10 (-0.09288) are the tips of the vertical tips.
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
        m += dm^k
    end
    m = m / n
    return moment
end

"""
Compute exact chord length through an annular pixel.
y: impact parameter of the chord
R_inner: inner radius of annulus
R_outer: outer radius of annulus
"""
function compute_chord_length(y, R_inner, R_outer)
    y_abs = abs(y)
    if y_abs >= R_outer
        return 0.0  # No intersection
    elseif y_abs <= R_inner
        return 2 * sqrt(R_outer^2 - y_abs^2) - 2 * sqrt(R_inner^2 - y_abs^2)
    else
        return 2 * sqrt(R_outer^2 - y_abs^2)  # Partial intersection (only crosses outer edge)
    end
end

"""
Determine the values of the T matrix (line of sight matrix) using exact geometry.
"""
function compute_T_matrix(detectors)
    M = length(detectors)
    MAX_RAD = 0.1 # Maximum pixel radius
    delta_r = MAX_RAD / M
    radii = [k * delta_r for k in 1:M]  # Equally spaced radii

    # Sort detectors by absolute value and filter valid radii
    y_abs = sort!(abs.(detectors))
    R = Float64[]
    for (k, rad) in enumerate(radii)
        if k <= length(y_abs) && rad >= y_abs[k]
            push!(R, rad)
        end
    end

    # Verify we have valid pixels
    if isempty(R)
        error("No valid pixels found - check detector positions")
    end

    # Initialize T matrix
    N_ch = length(detectors)
    N_pix = length(R)
    T = zeros(N_ch, N_pix)

    # Compute exact chord lengths
    for i in 1:N_ch
        y = detectors[i]  # Impact parameter (signed)
        for j in 1:N_pix
            R_in = j == 1 ? 0.0 : R[j-1] # condition ? value_if_true : value_if_false
            R_out = R[j]
            T[i, j] = compute_chord_length(y, R_in, R_out)
        end
    end

    return T, R  # Return the matrix for further use
end

export st, get_shinethru, title, compute_T_matrix, compute_chord_length

end # module WHAMjl
