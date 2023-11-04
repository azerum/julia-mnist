using Serialization

include("core/run_test.jl")

weights = deserialize("weights/deskewed.bin")
test = deserialize("data/deskewed-train.bin")

run_test(weights, test)
