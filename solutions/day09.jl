
function calculate_area(i, j, points)
    return (abs(points[i, 1] - points[j, 1]) + 1) * (abs(points[i, 2] - points[j, 2]) + 1)
end


function part1(points)
    n = size(points, 1)
    max_area = maximum(calculate_area(i, j, points) for i in 1:n-1 for j in i+1:n)
    println("Max area: ", max_area)
end


function rectangle_intersects_edges(i, j, points)
    n = size(points, 1)

    rx1, ry1 = points[i, 1], points[i, 2]
    rx2, ry2 = points[j, 1], points[j, 2]

    rmin_x, rmax_x = minmax(rx1, rx2)
    rmin_y, rmax_y = minmax(ry1, ry2)

    # Test each edge
    for k in 1:n
        k_next = (k % n) + 1
        x1, y1 = points[k, 1], points[k, 2]
        x2, y2 = points[k_next, 1], points[k_next, 2]

        if y1 == y2
            # Horizontal edge
            edge_y = y1
            edge_min_x, edge_max_x = minmax(x1, x2)

            if rmin_y < edge_y < rmax_y &&
               edge_max_x > rmin_x &&
               edge_min_x < rmax_x
                return true
            end
        elseif x1 == x2
            # Vertical edge
            edge_x = x1
            edge_min_y, edge_max_y = minmax(y1, y2)

            if rmin_x < edge_x < rmax_x &&
               edge_max_y > rmin_y &&
               edge_min_y < rmax_y
                return true
            end
        end
    end

    return false
end


function part2(points)
    n = size(points, 1)

    max_area = maximum(
        calculate_area(i, j, points)
        for i in 1:n-1 for j in i+1:n
        if !rectangle_intersects_edges(i, j, points)
    )

    println("Max valid area: ", max_area)
end


lines = readlines("data/day09/input.txt")
points = stack(parse.(Int, split(line, ',')) for line in lines; dims=1)

part1(points)
part2(points)