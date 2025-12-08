import Distances
import DataStructures


function find_pairs(points)
    n = size(points, 1)

    pairs = Vector{Tuple{Float64,Int,Int}}()
    sizehint!(pairs, div(n * (n - 1), 2))

    for i in 1:n-1
        for j in i+1:n
            d = Distances.euclidean(view(points, i, :), view(points, j, :))
            push!(pairs, (d, i, j))
        end
    end

    return pairs
end


function part1(points, close_count)

    n = size(points, 1)

    pairs = find_pairs(points)
    partialsort!(pairs, 1:close_count, by=first)

    ds = DataStructures.IntDisjointSet(n)
    for (_, i, j) in pairs[1:close_count]
        DataStructures.union!(ds, i, j)
    end

    cluster_sizes = DataStructures.counter(DataStructures.find_root!.(Ref(ds), 1:n))
    top3 = partialsort(collect(values(cluster_sizes)), 1:3, rev=true)

    println("3 largest: ", top3)
    println("Result: ", prod(top3))
end


function part2(points)

    n = size(points, 1)

    pairs = find_pairs(points)
    sort!(pairs, by=first)

    ds = DataStructures.IntDisjointSet(n)
    for (_, i, j) in pairs
        DataStructures.union!(ds, i, j)
        if DataStructures.num_groups(ds) == 1
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