image_side = 28
center_coord = 14

inputs_count = image_side^2
hidden_nodes_count = 30
outputs_count = 10

mini_batch_size = 60
iterations = 10_000
rate = 5

# Delay between the iterations of Stochastic Gradient Descent in seconds.
# Added to reduce the CPU load. Set to `nothing` not to sleep at all
sleep_time = 0.001
