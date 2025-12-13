
struct Region
    size::Vector{Int}
    present_count::Vector{Int}
end


function read_shape(lines)
    return stack([c == '#' for c in line] for line in lines)
end

function read_region(line)
    sz, pc = split(line, ':')
    return Region(parse.(Int, split(sz, 'x')), parse.(Int, split(pc)))
end

function read_input(lines)
    shapes = [read_shape(view(lines, (shape_idx - 1) * 5 .+ (2:4))) for shape_idx in 1:6]
    regions = [read_region(line) for line in view(lines, 6*5+1:length(lines))]
    return (shapes, regions)
end


function part1(shapes, regions)
    valid_count = count(regions) do region
        prod(region.size .÷ 3) >= sum(region.present_count)
    end
    println("Total: ", valid_count)
end


lines = readlines("data/day12/input.txt")
(shapes, regions) = read_input(lines)

part1(shapes, regions)