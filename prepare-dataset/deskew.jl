function transform(f::Function, image)::Matrix
    result = zeros(size(image))

    for i in CartesianIndices(image)
        x = i[1]
        y = i[2]

        (x1, y1) = f(x, y)

        x1 = round(Int, x1)
        y1 = round(Int, y1)

        if checkbounds(Bool, result, x1, y1)
            result[x1, y1] = image[x, y]
        end
    end

    result
end

function deskew(image, image_side::Number, center_coord::Number)::Matrix
    x = 1:image_side
    y = transpose(x)

    total_intensity = sum(image)

    # Mean
    mx = sum(image .* x) / total_intensity
    my = sum(image .* y) / total_intensity

    x_distance = x .- mx
    y_distance = y .- my

    var_y = sum(@. y_distance^2 * image)
    cov = sum(@. x_distance * y_distance * image)

    # See `deskew-formula.md`
    a = cov / var_y

    # Skew back the mean to get the original mean
    ox = mx - a * my
    oy = my

    transform(image) do x, y
        # Skew back
        nx = x - a * y
        ny = y

        # Translate so the center is (center_coord, center_coord) 
        nx += center_coord - ox
        ny += center_coord - oy

        (nx, ny)
    end
end

function deskew_all!(
    features,
    image_side::Number, 
    center_coord::Number
)
    for i in axes(features)[3]
        image = @view features[:, :, i]
        features[:, :, i] = deskew(image, image_side, center_coord)
    end
end
