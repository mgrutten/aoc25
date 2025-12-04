
function part1(batteries)
    total_joltage = 0
    for battery in batteries
        first_digit, max_idx = findmax(battery[begin:end-1])
        second_digit = maximum(battery[max_idx+1:end])

        total_joltage += 10 * first_digit + second_digit
    end

    println("Total joltage: ", total_joltage)
end


function part2(batteries)
    total_joltage = 0
    for battery in batteries
        digits = zeros(Int, 12)
        max_idx = 0
        for d in 1:12
            digits[d], idx = findmax(battery[max_idx+1:end-(12-d)])
            max_idx += idx
        end

        joltage = reduce((acc, d) -> 10acc + d, digits; init=0)
        total_joltage += joltage
    end

    println("Total joltage: ", total_joltage)
end


if abspath(PROGRAM_FILE) == @__FILE__
    lines = readlines("data/day03/part1.txt")
    batteries = [parse.(Int, collect(line)) for line in lines]

    part1(batteries)
    part2(batteries)
end
