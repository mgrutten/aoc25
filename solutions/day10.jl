
using DataStructures
using JuMP, HiGHS


struct Machine
    lights::String
    switches::Vector{Vector{Int}}
    joltages::Vector{Int}
end

function parse_machine(line::String)
    # Extract lights (between [ and ])
    lights_match = match(r"\[([.#]+)\]", line)
    lights = lights_match[1]

    # Extract switches (all parentheses groups)
    switches = Vector{Int}[]
    for m in eachmatch(r"\(([0-9,]+)\)", line)
        nums = parse.(Int, split(m[1], ','))
        push!(switches, nums)
    end

    # Extract joltages (between { and })
    joltages_match = match(r"\{([0-9,]+)\}", line)
    joltages = parse.(Int, split(joltages_match[1], ','))

    return Machine(lights, switches, joltages)
end


function toggle_lights(lights::String, indices::Vector{Int})
    chars = collect(lights)
    for idx in indices
        chars[idx+1] = chars[idx+1] == '.' ? '#' : '.'  # 0-indexed to 1-indexed
    end
    return String(chars)
end

function solve_lights(machine::Machine)
    start = "."^length(machine.lights)
    target = machine.lights

    if start == target
        return 0
    end

    # Priority queue for possible solutions
    queue = PriorityQueue{String,Int}()
    queue[start] = 0

    # Breadth-first-search
    while !isempty(queue)
        current, current_cost = peek(queue)
        dequeue!(queue)

        if current == target
            return current_cost
        end

        # Try each switch
        for switch in machine.switches
            next_state = toggle_lights(current, switch)
            new_cost = current_cost + 1

            if !haskey(queue, next_state) || new_cost < queue[next_state]
                queue[next_state] = new_cost
            end
        end
    end

    error("No solution found")
end


function part1(machines)
    total = sum(solve_lights(machine) for machine in machines)
    println("Total switches: ", total)
end


function solve_joltages(machine::Machine)
    model = Model(HiGHS.Optimizer)
    set_silent(model)

    switch_count = length(machine.switches)
    counter_count = length(machine.joltages)

    # Variables: how many times to press each switch
    @variable(model, presses[1:switch_count] >= 0, Int)

    # Constraints: achieve exact joltages at each position
    for pos in 1:counter_count
        # Sum contributions from all switches that affect this position
        contribution = @expression(model,
            sum(presses[i] for i in 1:switch_count
                if (pos - 1) in machine.switches[i];
                init=0)
        )
        @constraint(model, contribution == machine.joltages[pos])
    end

    # Objective: minimize total presses
    @objective(model, Min, sum(presses))

    optimize!(model)

    if termination_status(model) == OPTIMAL
        return Int(objective_value(model))
    else
        error("No solution found!")
    end
end


function part2(machines)
    total = sum(solve_joltages(machine) for machine in machines)
    println("Total switches: ", total)
end



lines = readlines("data/day10/input.txt")
machines = parse_machine.(lines)

#foreach(println, machines)

part1(machines)
part2(machines)