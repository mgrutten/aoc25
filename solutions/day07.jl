using Memoize

function print_grid(grid)
    for row in axes(grid, 1)
        println(join(grid[row, :]))
    end
end


function part1(grid)
    beam_grid = copy(grid)

    splits = 0
    for row in axes(beam_grid, 1)[2:end]
        for col in axes(beam_grid, 2)
            cell = beam_grid[row, col]
            above = beam_grid[row-1, col]

            if cell == '.' && above in ['S', '|']
                beam_grid[row, col] = '|'
            elseif cell == '^' && above == '|'
                if beam_grid[row, col-1] == '.'
                    beam_grid[row, col-1] = '|'
                end
                if beam_grid[row, col+1] == '.'
                    beam_grid[row, col+1] = '|'
                end
                splits += 1
            end
        end
    end

    #print_grid(beam_grid)
    println("Total splits: ", splits)
end


function part2(grid)

    @memoize function dfs(row, col)
        # End of the path
        if row == size(grid, 1)
            return 1
        end

        cell = grid[row, col]
        total_paths = 0

        if cell == '.'
            total_paths += dfs(row + 1, col)
        elseif cell == '^'
            total_paths += dfs(row, col - 1)
            total_paths += dfs(row, col + 1)
        end

        return total_paths
    end

    # Find starting position
    start_col = findfirst(grid[1, :] .== 'S')
    result = dfs(2, start_col)

    println("Total paths: ", result)
end

lines = readlines("data/day07/input.txt")
grid = stack(collect(line) for line in lines; dims=1)

part1(grid)
part2(grid)
