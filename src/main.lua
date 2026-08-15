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
    if (btn(2)) then
        move_up()
    end
    if (btn(3)) then
        move_down()
    end
    update_land()
    update_rocks()
end

function _draw()
    cls()
    map(0, 0)
    draw_land()
    draw_rocks()
    spr(player.sprite, player.x, player.y)
end