
struct Region
    size::Vector{Int}
    present_count::Vector{Int}
end


function read_shape(lines)
    shape = Array{Bool}(undef, 3, 3)
    for i in 1:3
        line = lines[i]
        shape[i, :] = [c == '#' for c in line]
    end

    return shape
end

function read_region(line)
    (sz, pc) = split(line, ':')
    return Region(parse.(Int, split(sz, 'x')), parse.(Int, split(pc)))
end

function read_input(lines)
    shapes = Vector{Array{Bool}}(undef, 6)
    for shape_idx in 1:6
        shapes[shape_idx] = read_shape(lines[(shape_idx-1)*5 .+ (2:4)])
    end

    regions = Vector{Region}()
    for line in lines[6*5+1:end]
        push!(regions, read_region(line))
    end

    return (shapes, regions)
end


function part1(shapes, regions)
    valid_count = sum(
        (region.size[1] ÷ 3) * (region.size[2] ÷ 3) >= sum(region.present_count)
        for region in regions
    )
    println("Total: ", valid_count)
end


lines = readlines("data/day12/input.txt")
(shapes, regions) = read_input(lines)

part1(shapes, regions)