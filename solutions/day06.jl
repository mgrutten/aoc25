
function parse_input(fname)
    lines = readlines(fname)

    line_data = stack(split(line) for line in lines; dims=1)
    problems = [(parse.(Int, line_data[1:end-1, problem]), line_data[end, problem][1]) for problem in axes(line_data, 2)]

    return problems
end

function evaluate(values, operator)
    if operator == '*'
        return prod(values)
    elseif operator == '+'
        return sum(values)
    else
        error("Invalid operator: $operator")
    end
end

function part1(problems)
    result = sum(evaluate(values, operator) for (values, operator) in problems)
    println("Total: $result")
end


function parse_part2(fname)
    lines = readlines(fname)

    indices = findall(c -> c != ' ', lines[end])
    push!(indices, length(lines[end]) + 2)

    problems = Tuple{Vector{Int},Char}[]
    for idx in eachindex(indices)[1:end-1]
        values = [
            parse(Int, join(lines[row][col] for row in 1:length(lines)-1))
            for col in indices[idx]:indices[idx+1]-2
        ]
        push!(problems, (values, lines[end][indices[idx]]))
    end

    return problems
end


fname = "input.txt"
problems = parse_input("data/day06/" * fname)
part1(problems)

problems = parse_part2("data/day06/" * fname)
part1(problems)