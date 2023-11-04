using Plots
using Serialization
using MLDatasets

include("core/dataset.jl")

draw_from(features) = i -> heatmap(
    transpose(@view features[:, :, i]); 
    yflip=true
)

function slideshow(features, digits, n)
    indexes = Iterators.Stateful(i for (i, d) in enumerate(digits) if d == n)
    draw = draw_from(features)

    function () 
        i = first(indexes)
        draw(i)

        i
    end
end
