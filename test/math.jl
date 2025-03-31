#https://eli.thegreenplace.net/2009/03/21/efficient-integer-exponentiation-algorithms

"""
Naive exponentiation by repeated multiplication
"""
function expt_mul(a::int, b::int)
    r = 1
    for i in 1:b
        r *= a
    end
    return r
end

function expt_rec(a::int, b::int)
    if b == 0
        return 1
    elseif b % 2 == 1
        return a * expt_rec(a, b - 1)
    else
        p = expt_rec(a, b / 2)
        return p * p
    end
end

"""
Calculate the moment of a data sample distribution as found here: https://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.moment.html
Arguments:
        --> distribution x as vector
        --> specify which moment k (int) to take
        --> center c is a float, should match data type of x
"""
function moment(x::Vector{Float64}, k::Int, c::Float64=0)
    n = length(x) # Length of distribution (discrete variable)
    m::Float64 = nothing # Initialize moment m variable as no value
    for j in 1:n
	dm = x[j] - c
        m += dm ^ k
    end
    m = m / n
    return moment
end
