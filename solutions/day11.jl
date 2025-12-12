using Graphs

function build_graph(connections::Dict{String,Set{String}})

    # Create a mapping between string labels and integer vertices
    label_to_vertex = Dict(label => i for (i, label) in enumerate(keys(connections)))
    label_to_vertex["out"] = length(label_to_vertex) + 1
    v(label) = label_to_vertex[label]

    # Create a directed graph
    g = DiGraph(length(label_to_vertex))

    # Add edges
    for (label, neighbours) in connections, neighbour in neighbours
        add_edge!(g, v(label), v(neighbour))
    end

    return (g, v)
end

function part1(g::DiGraph, v::Function)

    # Count paths
    paths = all_simple_paths(g, v("you"), v("out"))
    num_paths = sum(1 for _ in paths)

    println("Number of paths: $num_paths")
end


function part2(g::DiGraph, v::Function)

    # println("Number of vertices: ", nv(g))
    # println("Number of edges: ", ne(g))

    # println("Can reach fft from svr: ", has_path(g, v("svr"), v("fft")))
    # println("Can reach svr from fft: ", has_path(g, v("fft"), v("svr")))
    # println("Can reach dac from fft: ", has_path(g, v("fft"), v("dac")))
    # println("Can reach fft from dac: ", has_path(g, v("dac"), v("fft")))
    # println("Can reach out from dac: ", has_path(g, v("dac"), v("out")))
    # println("Can reach dac from out: ", has_path(g, v("out"), v("dac")))

    # println("Strongly connected components: ", length(strongly_connected_components(g)))

    function count_paths(g, start, finish, v)
        # Topological sort
        topo_order = topological_sort_by_dfs(g)

        # Dynamic programming on DAG
        count = Dict{Int,Int}()
        count[v(start)] = 1

        for node in topo_order
            if !haskey(count, node)
                continue
            end

            for neighbor in outneighbors(g, node)
                count[neighbor] = get(count, neighbor, 0) + count[node]
            end
        end

        return get(count, v(finish), 0)
    end

    # Count each segment
    c1 = count_paths(g, "svr", "fft", v)
    c2 = count_paths(g, "fft", "dac", v)
    c3 = count_paths(g, "dac", "out", v)
    total = c1 * c2 * c3

    println("Number of paths: $total")
end


lines = readlines("data/day11/input.txt")
connections = Dict{String,Set{String}}()
for line in lines
    (from, to) = split(line, ':')
    connections[from] = Set(split(to))
end

(g, v) = build_graph(connections)
part1(g, v)
part2(g, v)
