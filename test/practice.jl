using PyCall

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
