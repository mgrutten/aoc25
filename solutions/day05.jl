
function parse_input(fname)
    lines = readlines(fname)

    # Find the blank line
    separator_idx = findfirst(==(""), lines)

    # Parse id ranges
    id_ranges = [Tuple(parse.(Int, split(line, "-"))) for line in lines[1:separator_idx-1]]

    # Parse ingredients
    ingredients = parse.(Int, lines[separator_idx+1:end])

    return id_ranges, ingredients
end


function merge_ranges(id_ranges)
    new_ranges = copy(id_ranges)

    # Sort by left endpoint
    sort!(new_ranges)

    # Merge overlapping ranges
    merged = Tuple{Int,Int}[]
    for (left, right) in new_ranges
        if !isempty(merged) && left <= merged[end][2] + 1
            # Overlapping or adjacent
            merged[end] = (merged[end][1], max(right, merged[end][2]))
        else
            # No overlap
            push!(merged, (left, right))
        end
    end

    return merged
end


function part1(id_ranges, ingredients)
    merged = merge_ranges(id_ranges)

    fresh_count = count(ingredient -> any(left <= ingredient <= right for (left, right) in merged), ingredients)
    println(fresh_count)
end

function part2(id_ranges)
    merged = merge_ranges(id_ranges)

    fresh_count = sum(right - left + 1 for (left, right) in merged)
    println(fresh_count)
end


id_ranges, ingredients = parse_input("data/day05/input.txt")
part1(id_ranges, ingredients)
part2(id_ranges)