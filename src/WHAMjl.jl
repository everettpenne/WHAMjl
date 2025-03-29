module WHAMjl

using PyCall

# Import MDSplus using Python (as long as Python has it installed)
mds = pyimport("MDSplus")

greet() = print("Hello World!")

title() = print(
    "      _____        ___   _    _    __  __  ___
    / \\  \\ \\      / | | | |  / \\  |  \\/  |/ \\ \\
    | | | \\ \\ /\\ / /| |_| | / _ \\ | |\\/| | | | |
    | | | |\\ V  V / |  _  |/ ___ \\| |  | | | | |
    | | | | \\_/\\_/  |_| |_/_/   \\_|_|  |_| .jl |
     \\_/_/                                \\_/_/\n"
)

title()

end # module WHAMjl
