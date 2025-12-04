
function in_range(v, lh, rh)
    return v >= lh && v <= rh
end

function part1(pairs)

    invalid_sum = 0
    for (lh, rh) in pairs
        nlh = ndigits(lh)
        nrh = ndigits(rh)

        # Reject if both odd number of digits
        if isodd(nlh) && isodd(nrh)
            continue
        end

        # This is how many digits we can change
        ndiff = ndigits(rh - lh)

        # Start with an even number of digits
        if iseven(nlh)
            divisor = 10^(nlh ÷ 2)
            test_half = lh
        else
            divisor = 10^(nrh ÷ 2)
            test_half = rh
        end

        # How many numbers can we change in the high half?
        extra_tests = 10^max(0, ndiff - ndigits(divisor) + 1)

        # Test for symmetry
        for v in 0:extra_tests
            high_half = test_half ÷ divisor + v

            if ndigits(high_half) == ndigits(divisor) - 1
                value = high_half * divisor + high_half
                if in_range(value, lh, rh)
                    invalid_sum += value
                end
            end
        end

    end

    println("Result: ", invalid_sum)
end


if abspath(PROGRAM_FILE) == @__FILE__
    line = readline("data/day02/part1.txt")
    pairs = [parse.(Int, split(part, '-')) for part in split(line, ',')]

    part1(pairs)
end
