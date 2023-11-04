using SimpleWebsockets
using Serialization
using JSON

include("deskew.jl")
include("../core/settings.jl")

server = WebsocketServer()

images = Vector{Matrix{Float32}}()

listen(server, :client) do client
    listen(client, :message) do message
        flat_image = JSON.parse(message)
        image = reshape(flat_image, image_side, image_side)

        deskewed = deskew(image, image_side, center_coord)
        push!(images, deskewed)

        send(client, 1)
    end
end

port = 8000

listen(server, :listening) do _
    @info "Listening on $port..."
end

@async serve(server, port)

while true
    line = readline()

    if lowercase(line) == "exit"
        break
    end

    if !isopen(server)
        break
    end
end

open("data/nines.bin", "w") do io
    serialize(io, images)
end

close(server)
close(io)
