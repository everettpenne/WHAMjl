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

λ = 1e-3  # Regularization parameter
g_reg = (T' * T + λ * I) \ (T' * f_t)

#display(f_t)
display(g_reg)

# Create the heatmap
heatmap(1:1, 1:length(g_reg), g_reg,
    c=:thermal,  # Color scheme (you can choose others like :viridis, :plasma, etc.)
    xlabel="Time (single point)",
    ylabel="g_reg index",
    title="Regularized Solution g_reg at Time Index $(time_indices[1])",
    xticks=([1], [string(time_indices[1])]))  # Set custom x-axis tick

# If you want to save the plot
savefig("g_reg_heatmap.png")
