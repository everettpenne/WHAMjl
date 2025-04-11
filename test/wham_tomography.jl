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
#time_indices = [6350, 10000, 15000, 20000, 21000]  # Make sure this is within bounds of your data
time_indices = [6000, 6250, 6500, 6750, 7000, 7250, 7500, 7750, 8000, 8250, 8500, 8750, 9000, 9250, 9500, 9750, 10000, 10250, 10500, 10750, 11000, 11250, 11500, 11750, 12000, 12250, 12500, 12750, 13000, 13250, 13500, 13750, 14000, 14250, 14500, 14750, 15000, 15250, 15500, 15750, 16000, 16250, 16500, 16750, 17000, 17250, 17500, 17750, 18000, 18250, 18500, 18750, 19000, 19250, 19500, 19750, 20000, 20250, 20500, 20750, 21000, 21250]

# Initialize f_t as a matrix where each column is a time point
f_t = Matrix{Float64}(undef, length(f), length(time_indices))

# Fill f_t with data at the specified times
for (j, t) in enumerate(time_indices)
    for (i, data) in enumerate(f)
        f_t[i, j] = data[t]
    end
end

λ = 1e-3  # Regularization parameter
g_reg = (T' * T + λ * I) \ (T' * f_t)

using Plots

# Assuming g_reg is a matrix where columns are time points and rows are indices
# g_reg size: (n_indices × n_time_points)

# Define x-axis edges (centered at 1, 2, 3, ... for each time point)
x_edges = 0.5:1:(length(time_indices)+0.5)

# Define y-axis edges (centered at 1, 2, 3, ... for each g_reg index)
y_edges = 0.5:1:(size(g_reg, 1)+0.5)

# Plot heatmap with adjusted pixel positions
heatmap(
    x_edges,
    y_edges,
    g_reg,  # Already in correct shape (indices × time_points)
    c=:viridis,  # Color scheme
    xlabel="Time Points",
    ylabel="g_reg Index",
    title="Regularized Solution g_reg at Multiple Times",
    xticks=(1:length(time_indices), string.(time_indices)),  # Label x-ticks with actual time indices
    aspect_ratio=:auto,  # Adjust for square pixels
    colorbar_title="Intensity"
)

# Optional: Save the plot
savefig("multi_time_g_reg_heatmap.png")
