using PyCall
using Printf

# Import MDSplus (ensure Python has it installed)
mds = pyimport("MDSplus")

# Open the WHAM tree
shotnum = 250324094  # Replace with your shot number
tree = mds.Tree("wham", shotnum)

# Access a node (e.g., line-integrated density)
node = tree.getNode("diag.shinethru.linedens.linedens_01")
data = node.record.data()  # Get data array
time = node.dim_of().data()  # Get time axis

println("Data: ", size(data)[1])
println("Time: ", size(time)[1])

function get__shinethru(treename::String="wham", shotnum::Int)
    tree = mds.Tree(treename, shotnum)
    basepath::String = "diag.shinethru.linedens.linedens_"

    times = Vector{Vector{Float64}}()
    channels = Vector{Vector{Float64}}()
    for ch in 1:15
    if ch != 6
        absolutepath = basepath * sprintf("%02d", ch)
        see_node = tree.getNode(absolutepath)
        ch_time = see_node.dim_of().getData()
        ch_data = see_node.dim_of().getData()
        push!(times, ch_time)
        push!(channels, ch_data)
    end

    return times, channels
end
