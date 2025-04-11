include("../src/WHAMjl.jl")

using .WHAMjl
using LinearAlgebra
using Plots

# Main execution
tree = "wham"
shot = 250324094

impact_parameters, times, f = get_shinethru(shot, tree)
T, R = compute_T_matrix(impact_parameters)

# Instead of just one time point, let's use a range of time points
time_indices = 1:100:length(times)  # Adjust the step as needed

# Initialize f_t as a matrix where each column is a time point
f_t = Matrix{Float64}(undef, length(f), length(time_indices))

# Fill f_t with data at the specified times
for (j, t) in enumerate(time_indices)
    for (i, data) in enumerate(f)
        f_t[i, j] = data[t]
    end
end

# Create the heatmap - corrected dimensions
heatmap(times[time_indices], 1:size(f_t, 1), f_t',
    xlabel="Time",
    ylabel="Channel",
    title="Shinethrough Heatmap",
    color=:thermal)

# Note the transpose (') of f_t - this ensures size(z) == (length(y), length(x))
