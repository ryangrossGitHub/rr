land = {
    left = {},
    right = {},
    length_max = 20
}

function init_land()
    for i=1, 128 do
        land.left[i] = get_rand_with_neg() + (land.left[i-1] or 0)
        if land.left[i] < 0 then
            land.left[i] = 0
        elseif land.left[i] > land.length_max then
            land.left[i] = land.length_max
        end

        land.right[i] = get_rand_with_neg() + (land.right[i-1] or 0)
        if land.right[i] > 128 then
            land.right[i] = 128
        elseif land.right[i] < 128-land.length_max then
            land.right[i] = 128-land.length_max
        end
    end
end

function get_rand_with_neg()
    return rnd(2) - 1
end

function update_land()
    deli(land.left, 1)
    deli(land.right, 1)

    local new_left = get_rand_with_neg() + land.left[127]
    if new_left < 0 then
        new_left = 0
    elseif new_left > land.length_max then
        new_left = land.length_max
    end
    
    local new_right = get_rand_with_neg() + land.right[127]
    if new_right > 128 then
        new_right = 128
    elseif new_right < 128 - land.length_max then
        new_right = 128 - land.length_max
    end

    add(land.left, new_left)
    add(land.right, new_right)
end

function draw_land()
    for i=0, 127 do
        local left = land.left[i+1]
        local right = land.right[i+1]
        rectfill(0, i, left, i, 3)
        rectfill(right, i, 128, i, 3)
    end
end