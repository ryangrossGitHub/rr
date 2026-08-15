rocks = {
    spawn_prob = 0.02,
    list = {}
}

function spawn_rocks()
    if rnd() > rocks.spawn_prob then
        return
    end

    local rock = {
        y = 128,
        x = flr(rnd(128 - land.length_max * 2) + land.length_max),
        sprite = 2
    }
    add(rocks.list, rock)
end

function update_rocks()
    spawn_rocks()
    for rock in all(rocks.list) do
        rock.y -= 0.5
        if rock.y < -8 then
            del(rocks.list, rock)
        end
    end
end

function draw_rocks()
    for rock in all(rocks.list) do
        spr(rock.sprite, rock.x, rock.y)
    end
end