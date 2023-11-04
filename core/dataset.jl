using MLDatasets

include("settings.jl")

mutable struct Dataset 
    features::Array{Float32, 3}
    digits::Vector{Int64}
    expected_outputs::Matrix{Float32}
end

function digits_to_outputs(digits::Vector{Int64})::Matrix{Float32}
    outputs = zeros(Float32, length(digits), outputs_count)

    for (i, d) in enumerate(digits)
        outputs[i, d + 1] = 1
    end

    outputs
end

function output_to_digit(output::Vector{Float32})::Int
    (_, i) = findmax(output)
    i - 1
end

function mnist_to_dataset(mnist::MNIST)::Dataset
    to_dataset(mnist.features, mnist.targets)
end

function to_dataset(features, targets)::Dataset
    outputs = digits_to_outputs(targets)
    Dataset(features, targets, outputs)
end
