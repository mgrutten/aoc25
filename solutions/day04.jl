
function count_neighbors(grid, row, col)
    count = 0
    for r in max(1, row - 1):min(size(grid, 1), row + 1), c in max(1, col - 1):min(size(grid, 2), col + 1)
        count += grid[r, c]
    end
    # Remove the centre element
    count - 1
end


function part1(grid)
    accessible_rolls = 0
    for row in axes(grid, 1), col in axes(grid, 2)
        if grid[row, col] && count_neighbors(grid, row, col) < 4
            accessible_rolls += 1
        end
    end

    println("Total rolls: ", accessible_rolls)
end




function remove_rolls(grid)
    new_grid = copy(grid)
    for row in axes(grid, 1), col in axes(grid, 2)
        if grid[row, col] && count_neighbors(grid, row, col) < 4
            new_grid[row, col] = false
        end
    end
    new_grid
end


function part2(grid)
    original_count = count(grid)

    old_count = original_count + 1
    new_count = original_count
    while new_count < old_count
        grid = remove_rolls(grid)
        old_count = new_count
        new_count = count(grid)
    end

    println("Rolls removed: ", original_count - new_count)

end



lines = readlines("data/day04/input.txt")
grid = stack([c == '@' for c in line] for line in lines; dims=1)

part1(grid)
part2(grid)