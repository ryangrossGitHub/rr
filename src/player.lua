player = {
    x = 56,
    y = 30,
    dx = 0,         -- "dx" is Delta X (current speed/momentum)
    accel = 0.3,    -- How fast you speed up when holding a button
    friction = 0.95,-- How fast you slow down when you let go 
    max_speed = 0.3,  -- The top speed the player can reach
    sprite = 48
}

function move_left()
    -- Add negative momentum
    player.dx -= player.accel
end

function move_right()
    -- Add positive momentum
    player.dx += player.accel
end

-- Call this inside your main _update() function!
function update_player()
    -- 1. Apply friction so the player naturally slows down
    player.dx *= player.friction
    
    -- 2. Clamp the speed so the player doesn't accelerate to infinity
    if player.dx > player.max_speed then player.dx = player.max_speed end
    if player.dx < -player.max_speed then player.dx = -player.max_speed end
    
    -- 3. If the momentum gets microscopic, just stop completely
    if abs(player.dx) < 0.05 then player.dx = 0 end
    
    -- 4. Finally, move the player by their current momentum
    player.x += player.dx
end
