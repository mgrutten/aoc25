
function is_symmetric(val)
    # Number of digits
    nd = ndigits(val)

    # Odd number of digits can't be symmetric
    if isodd(nd)
        return false
    end

    # Calculate top half
    divisor = 10^(nd ÷ 2)
    high_half = val ÷ divisor

    # Is the value symmetric?
    return (high_half * divisor + high_half) == val
end

function part1(pairs)

    invalid_sum = 0
    for (lh, rh) in pairs
        # Reject if both odd number of digits
        if isodd(ndigits(lh)) && isodd(ndigits(rh))
            continue
        end

        for val in lh:rh
            if is_symmetric(val)
                invalid_sum += val
            end
        end
    end

    println("Result: ", invalid_sum)
end


function has_pattern(val, skip)
    # Need number of digits to be divisible by skip
    if ndigits(val) % skip != 0
        return false
    end

    digits_arr = reverse(digits(val))

    # Check each sequence starting at offset 0 to (skip-1)
    for offset in 1:skip
        first_digit = digits_arr[offset]
        all_same = all(digit == first_digit for digit in digits_arr[offset:skip:end])

        if !all_same
            return false
        end
    end

    return true
end

function part2(pairs)

    invalid_sum = 0
    for (lh, rh) in pairs
        for val in lh:rh
            if ndigits(val) < 2
                continue
            end
            max_skip = ndigits(rh) ÷ 2
            for skip in 1:max_skip
                if has_pattern(val, skip)
                    invalid_sum += val
                    break
                end
            end
        end
    end

    println("Result: ", invalid_sum)
end


line = readline("data/day02/part1.txt")
pairs = [parse.(Int, split(part, '-')) for part in split(line, ',')]

part1(pairs)
part2(pairs)
