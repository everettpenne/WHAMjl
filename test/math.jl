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
