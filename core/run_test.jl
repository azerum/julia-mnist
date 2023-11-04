include("network.jl")

function run_test(weights::Weights, dataset::Dataset)
    cost = 0.0
    right_count = 0

    for i in eachindex(dataset.digits)
        image = @view dataset.features[:, :, i]
        x = reshape(image, inputs_count)

        y = @view dataset.expected_outputs[i, :]
        digit = dataset.digits[i]

        output = compute_output(weights, x)
        cost += euclidean_distance(y, output.a2)

        if output_to_digit(output.a2) == digit
            right_count += 1
        end
    end

    total_count = length(dataset.digits)

    cost /= total_count
    right_percent = right_count / total_count * 100

    println("Cost $cost. Right $right_count / $total_count ($right_percent%)");
end

function euclidean_distance(a, b)::Number
    sum = 0.0

    for i in eachindex(a)
        sum += (a[i] - b[i])^2
    end

    sum
end
