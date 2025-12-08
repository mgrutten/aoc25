using Distances
using DataStructures

function part1(points, close_count)

    n = size(points, 1)

    pairs = Vector{Tuple{Float64,Int,Int}}()
    sizehint!(pairs, div(n * (n - 1), 2))

    for i in 1:n-1
        for j in i+1:n
            d = euclidean(view(points, i, :), view(points, j, :))
            push!(pairs, (d, i, j))
        end
    end

    partialsort!(pairs, 1:close_count, by=first)
    closest = pairs[1:close_count]

    ds = DisjointSets(1:n)
    for (_, i, j) in closest
        union!(ds, i, j)
    end

    cluster_sizes = Dict{Int,Int}()
    for i in 1:n
        root = find_root!(ds, i)
        cluster_sizes[root] = get(cluster_sizes, root, 0) + 1
    end

    sizes = sort(collect(values(cluster_sizes)), rev=true)

    println("Clusters: ", length(sizes))
    println("3 largest: ", sizes[1:3])
    println("Result: ", prod(sizes[1:3]))
end


function part2(points)

    n = size(points, 1)

    pairs = Vector{Tuple{Float64,Int,Int}}()
    sizehint!(pairs, div(n * (n - 1), 2))

    for i in 1:n-1
        for j in i+1:n
            d = euclidean(view(points, i, :), view(points, j, :))
            push!(pairs, (d, i, j))
        end
    end

    sort!(pairs, by=first)

    ds = DisjointSets(1:n)
    for (_, i, j) in pairs
        union!(ds, i, j)
        if num_groups(ds) == 1
            println(points[i, :], "/", points[j, :])
            println("Result: ", points[i, 1] * points[j, 1])
            break
        end
    end

end


lines = readlines("data/day08/input.txt")
points = stack(parse.(Int, split(line, ',')) for line in lines; dims=1)

part1(points, 1000)
part2(points)