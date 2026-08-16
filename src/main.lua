speed = 0.5

function _init()
    init_land()
end

function _update60()
    if (btn(0)) then
        move_left()
    end
    if (btn(1)) then
        move_right()
    end

    update_land()
    update_rocks()
    update_player()
    -- update_splashes()
end

function _draw()
    cls()
    map(0, 0)
    draw_land()
    draw_rocks()
    spr(player.sprite, player.x, player.y)
    -- draw_splashes()
end