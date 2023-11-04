using SimpleWebsockets
using Serialization
using JSON

include("core/network.jl")
include("prepare-dataset/deskew.jl")

weights::Weights = deserialize("weights/deskewed.bin")

server = WebsocketServer()
ended = Condition()

listen(server, :client) do client
    listen(client, :message) do message
        flat_image = JSON.parse(message)
        image = reshape(flat_image, image_side, image_side)

        deskewed = deskew(image, image_side, center_coord)
        flat_deskewed = reshape(deskewed, inputs_count)

        output = compute_output(weights, flat_deskewed)

        ordered_digits = (i - 1 for i in sortperm(output.a2; rev=true))
        
        joined = join(ordered_digits, ", ")
        send(client, joined)
    end
end

listen(server, :connectError) do err
    notify(ended, err, error = true)
end

listen(server, :closed) do details
    @warn "Server has closed" details...
    notify(ended)
end

port = 8000

@async serve(server, port)
@info "Listening on $port"

wait(ended)
