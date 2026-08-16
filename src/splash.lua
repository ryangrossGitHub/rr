-- 1. Setup the particle list
splashes = {}
splash_prob = 0.1 -- 10% chance to spawn a splash every frame

function make_splash(x, y)
    add(splashes, {
        x = x,
        y = y,
        vx = rnd(0.25) - 0.125,    -- random side movement
        vy = -rnd(0.125) - 0.0625, -- move upward/against current
        life = rnd(10) + 10  -- how many frames it lasts
    })
end

function update_splashes()
    for p in all(splashes) do
        p.x += p.vx
        p.y += p.vy
        p.life -= 1
        -- remove dead splashes
        if (p.life <= 0) del(splashes, p)
    end
end

function draw_splashes()
    for p in all(splashes) do
        -- draw white (7) or light blue (12) dots
        pset(p.x, p.y, 7) 
    end
end
