
const OP_MAP = Dict('*' => prod, '+' => sum)

function parse_input(fname)
    lines = readlines(fname)
    line_data = stack(split(line) for line in lines; dims=1)

    problems = [
        (parse.(Int, line_data[1:end-1, problem]), OP_MAP[line_data[end, problem][1]])
        for problem in axes(line_data, 2)
    ]

    return problems
end

function part1(problems)
    result = sum(op_func(values) for (values, op_func) in problems)
    println("Total: $result")
end


function parse_part2(fname)
    lines = readlines(fname)

    indices = findall(!=(' '), lines[end])
    push!(indices, length(lines[end]) + 2)

    problems = [
        (
            [
                parse(Int, join(lines[row][col] for row in 1:length(lines)-1))
                for col in indices[idx]:indices[idx+1]-2
            ],
            OP_MAP[lines[end][indices[idx]]]
        )
        for idx in 1:length(indices)-1
    ]

    return problems
end


fname = "input.txt"
problems = parse_input("data/day06/" * fname)
part1(problems)

problems = parse_part2("data/day06/" * fname)
part1(problems)