using LinearAlgebra
using MLDatasets
using Serialization

include("dataset.jl")
include("modify.jl")

mutable struct Weights
    w1::Matrix
    b1::Vector

    w2::Matrix
    b2::Vector
end

function fill_weights(f)::Weights
    return Weights(
        (hidden_nodes_count, inputs_count) |> f,
        (hidden_nodes_count) |> f,

        (outputs_count, hidden_nodes_count) |> f,
        (outputs_count) |> f
    )
end

struct Output
    z1::Vector
    a1::Vector

    z2::Vector
    a2::Vector
end

function compute_output(weights::Weights, x)::Output
    z1 = weights.w1 * x + weights.b1
    a1 = sigmoid.(z1)
    
    z2 = weights.w2 * a1 + weights.b2
    a2 = sigmoid.(z2)
    
    return Output(z1, a1, z2, a2)
end

function sigmoid(x)
    1 / (1 + exp(-x))
end

# Computes σ'(x) from σ(x)
function sigmoid_prime_from_sigmoid(x)
    x * (1 - x)
end

function stochastic_gradient_descent!(weights::Weights, dataset::Dataset)
    start_range = 1:(length(dataset.digits) - mini_batch_size + 1)

    for _ in 1:iterations
        start = rand(start_range)
        images_range = start:(start + mini_batch_size - 1)

        gradient = compute_cost_gradient(weights, dataset, images_range);

        # weights -= rate * gradient
        modify!((w, g) -> w - rate * g, weights, gradient)

        if !isnothing(sleep_time)
            sleep(sleep_time)
        end
    end
end

function compute_cost_gradient(weights::Weights, dataset::Dataset, images_range)::Weights
    gradient = fill_weights(dims -> fill(0f0, dims...))

    for i in images_range
        image = @view dataset.features[:, :, i]
        x = reshape(image, inputs_count)

        y = @view dataset.expected_outputs[i, :]

        output = compute_output(weights, x)
        derivatives = compute_derivatives(weights, output, x, y)

        modify!(+, gradient, derivatives)
    end

    modify!(/, gradient, length(images_range))

    gradient
end

function compute_derivatives(weights::Weights, output::Output, x, y)::Weights
    # To remind yourself about the equations, see the table
    # above this paragraph 
    # http://neuralnetworksanddeeplearning.com/chap2.html#problem_543309

    d2 = @. -2 * (y - output.a2) * sigmoid_prime_from_sigmoid(output.a2)
    d1 = transpose(weights.w2) * d2 .* sigmoid_prime_from_sigmoid.(output.a1)

    b2 = d2
    b1 = d1

    w2 = d2 .* transpose(output.a1)
    w1 = d1 .* transpose(x)

    Weights(w1, b1, w2, b2)
end
