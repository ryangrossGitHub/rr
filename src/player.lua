player = {
    x = 56,
    y = 30,
    x_speed = 1,
    y_speed = 0.5,
    sprite = 48
}

function move_left()
    player.x -= player.x_speed
end

function move_right()
    player.x += player.x_speed
end

function move_down()
    player.y += player.y_speed
end

function move_up()
    player.y -= player.y_speed
end