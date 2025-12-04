

function part1(lines)
    value = 50
    zero_count = 0

    # Iterate over lines
    for line in lines
        direction = line[1]
        rotation = parse(Int, line[2:end])

        # Move to next location
        if direction == 'L'
            value -= rotation
        elseif direction == 'R'
            value += rotation
        else
            error("Invalid direction: ", direction)
        end

        # Wrap at 99
        value = mod(value, 100)

        # Record zero values
        if value == 0
            zero_count += 1
        end

    end

    println("Zero count: ", zero_count)
end


function part2(lines)
    value = 50
    zero_count = 0

    # Iterate over lines
    for line in lines
        direction = line[1]
        rotation = parse(Int, line[2:end])

        # Move to next location
        if direction == 'L'
            new_value = value - rotation
            zero_count += abs(div(mod(100 - value, 100) + rotation, 100))
        elseif direction == 'R'
            new_value = value + rotation
            zero_count += div(new_value, 100)
        else
            error("Invalid direction: ", direction)
        end

        # Wrap at 99
        value = mod(new_value, 100)

    end

    println("Zero count: ", zero_count)
end



if abspath(PROGRAM_FILE) == @__FILE__
    lines = readlines("data/day01/part1.txt")
    part1(lines)
    part2(lines)
end
