using Pkg
Pkg.add(["SavitzkyGolay", "Plots"])

using SavitzkyGolay, Plots

# Generate data
x = range(0, 10, length=200)
true_signal = sin.(x)
noisy_data = true_signal + 0.3 * randn(length(x))

# Filter parameters
window_size = 21
poly_order = 3

# Apply filter (version-agnostic approach)
filter_result = savitzky_golay(noisy_data, window_size, poly_order)
smoothed_data = filter_result isa AbstractVector ? filter_result : filter_result.smoothed

# Plot
p = plot(x, noisy_data,
        label="Noisy Data",
        color=:gray, alpha=0.6, linewidth=1.5, linestyle=:dot)
plot!(p, x, smoothed_data,
        label="SavGol Filtered",
        color=:red, linewidth=2.5)
plot!(p, x, true_signal,
        label="True Signal",
        color=:blue, linewidth=2, linestyle=:dash)
title!(p, "Savitzky-Golay Filter")
xlabel!(p, "Time")
ylabel!(p, "Amplitude")

display(p)
savefig(p, "savgol_plot.png")
