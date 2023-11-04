using Serialization

include("core/run_test.jl")

train = deserialize("data/deskewed-train.bin")

weights = fill_weights(dims -> randn(Float32, dims...))
stochastic_gradient_descent!(weights, train)

open("weights/deskewed.bin", "w") do io
    serialize(io, weights)
end

train = nothing
test = deserialize("data/deskewed-test.bin")

run_test(weights, test)
