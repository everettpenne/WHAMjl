include("../src/WHAMjl.jl")

using .WHAMjl
using LinearAlgebra
using Plots
#unicodeplots()
gr()

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
for (i, t) in enumerate(time_indices)
    for (j, data) in enumerate(f)
        f_t[j, i] = data[t]
    end
end

λ = 1e-3  # Regularization parameter
g_reg = (T' * T + λ * I) \ (T' * f_t)

#display(f_t)
#display(g_reg)

θ = range(0, 2π, length=200)
r1 = @. exp(cos(θ)) - 2cos(4θ) + sin(θ / 12)^5
r2 = @. 2 + cos(3θ)

plot(θ, r1, proj=:polar, label="Butterfly", linewidth=2, color=:red)
plot!(θ, r2, proj=:polar, label="Flower", linestyle=:dash, color=:blue)
title!("Polar Plot Example")
savefig("polar_plot.png")
