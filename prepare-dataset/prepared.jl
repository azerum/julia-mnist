using MLDatasets
using Serialization

include("../core/dataset.jl")
include("deskew.jl")

nines = deserialize("data/nines.bin")

open("data/deskewed-train.bin", "w") do io
    mnist_train = MNIST(:train)

    features = mnist_train.features

    # Add more nines so they will have more significant impact (this network
    # is not performing well with nines)
    features_count = size(features)[3]
    ten_percent = features_count * 0.1

    repeat_count = floor(Int, ten_percent / length(nines))
    many_nines = repeat(nines, repeat_count)

    # Nines are already deskewed, so concat them after deskewing the rest

    deskew_all!(features, image_side, center_coord)
    features = cat(features, many_nines...; dims=(3))

    targets = mnist_train.targets
    train = to_dataset(features, targets)

    serialize(io, train)
end

open("data/deskewed-test.bin", "w") do io
    mnist_test = MNIST(:test)
    deskew_all!(mnist_test.features, image_side, center_coord)

    test = mnist_to_dataset(mnist_test)

    serialize(io, test)
end
