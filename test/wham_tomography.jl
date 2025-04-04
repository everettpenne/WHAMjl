include("../src/WHAMjl.jl")

using .WHAMjl
using LinearAlgebra

tree = "wham"
shots = [250324094]

for shot in shots
        impact_parameters, times, channels = get_shinethru(tree, shot)
        println(size(impact_parameters))
        println(size(times))
        println(size(channels))

