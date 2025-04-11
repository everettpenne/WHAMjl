include("../src/WHAMjl.jl")

using .WHAMjl
using LinearAlgebra
using Plots

# Main execution
tree = "wham"
shot = 250324094

impact_parameters, times, f = get_shinethru(shot, tree)
T, R = compute_T_matrix(impact_parameters)

# Choose time indices (using just one time point in this example)
time_indices = [10000]  # Make sure this is within bounds of your data

# Initialize f_t as a matrix where each column is a time point
f_t = Matrix{Float64}(undef, length(f), length(time_indices))

# Fill f_t with data at the specified times
for (j, t) in enumerate(time_indices)
    for (i, data) in enumerate(f)
        f_t[i, j] = data[t]
    end
end

#for time in time_indices

#end

λ = 1e-3  # Regularization parameter
g_reg = (T' * T + λ * I) \ (T' * f_t)

# Define the x-axis (time) as a single bin [left_edge, right_edge]
x_edges = [0.5, 1.5]  # Centers the single column at x=1

# Define y-axis edges (each pixel spans from i-0.5 to i+0.5)
y_edges = 0.5:1:(length(g_reg)+0.5)

# Plot heatmap with explicit edges
heatmap(
    x_edges, y_edges, reshape(g_reg, (1, length(g_reg))),  # Reshape to matrix
    c=:viridis,
    xlabel="Time",
    ylabel="g_reg Index",
    title="Heatmap with Adjusted Pixel Width",
    aspect_ratio=:auto  # Ensures square pixels if desired
)
