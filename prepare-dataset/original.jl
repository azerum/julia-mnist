using MLDatasets
using Serialization

include("../core/dataset.jl")

# Load the files first to see if there are any errors before doing computations

open("data/train.bin", "w") do io
    mnist_train = MNIST(:train)
    train = mnist_to_dataset(mnist_train)

    serialize(io, train)
end

open("data/test.bin", "w") do io
    mnist_test = MNIST(:test)
    test = mnist_to_dataset(mnist_test)

    serialize(io, test)
end
