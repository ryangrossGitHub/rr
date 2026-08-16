rocks = {
    spawn_prob = 0.07,
    list = {}
}

function spawn_rock()
  local r = {
    x = get_rand_between(land.length_max),
    y = 128,           
    seed = rnd(10000) -- Save a unique seed number for this specific rock!
  }
  add(rocks.list, r)
end

function update_rocks()
  -- Move rocks up the screen at the same speed as your terrain
  for r in all(rocks.list) do
    r.y -= speed
    
    -- Remove the rock if it goes off the top of the screen
    if r.y < -8 then del(rocks.list, r) end
  end
  
  -- Example: 2% chance to spawn a new rock every frame
  if rnd(1) < rocks.spawn_prob then spawn_rock() end
end

function draw_rocks()
  for r in all(rocks.list) do
    -- 1. Lock PICO-8's randomizer to this rock's unique seed
    srand(r.seed)
    
    -- 2. Draw the rock (it will generate the same unique shape every frame)
    draw_unique_rock(r.x, r.y)
  end
  
  -- 3. Reset the system seed afterward so the rest of your game remains truly random
  srand(sub(time(), 1)) 
end

-- Draws a completely unique rock directly to the screen at (pos_x, pos_y)
function draw_unique_rock(pos_x, pos_y)
  -- 1. Pick a random peak/center inside an 8x8 box
  local center_x = 3 + rnd(2)
  local center_y = 3 + rnd(2)
  
  -- 2. Pick a random base size for this specific rock
  local max_radius = 2.5 + rnd(1.5)
  
  -- 3. Loop through each row of the rock vertically (Y axis)
  for y=0, 7 do
    local screen_y = pos_y + y
    
    -- Safety check: skip drawing if the row is off the top/bottom of the screen
    if screen_y >= 0 and screen_y <= 127 then
      
      -- 4. Figure out the horizontal boundaries (left and right edges) for this row
      -- We look for the furthest pixels that fall within our max_radius
      local left_x = nil
      local right_x = nil
      
      for x=0, 7 do
        local dx = x - center_x
        local dy = y - center_y
        local distance = sqrt(dx*dx + dy*dy)
        
        -- Add jagged noise to the edge check
        local final_dist = distance + (rnd(0.8) - 0.4)
        
        if final_dist < max_radius then
          if left_x == nil then left_x = x end
          right_x = x
        end
      end
      
      -- 5. Draw this row's pixels if it has a valid width
      if left_x != nil then
        -- Draw the base shadow layer (Dark Grey - Color 5)
        rectfill(pos_x + left_x, screen_y, pos_x + right_x, screen_y, 5)
        
        -- 6. Layer the highlight peak on top (Light Grey - Color 6)
        -- Look inside this row to see if any pixels are close enough to the peak
        local high_left = nil
        local high_right = nil
        
        for x = left_x, right_x do
          local dx = x - center_x
          local dy = y - center_y
          local distance = sqrt(dx*dx + dy*dy)
          local final_dist = distance + (rnd(0.6) - 0.3)
          
          if final_dist < max_radius * 0.45 then
            if high_left == nil then high_left = x end
            high_right = x
          end
        end
        
        -- Draw the light grey inner highlight strip if it exists
        if high_left != nil then
          rectfill(pos_x + high_left, screen_y, pos_x + high_right, screen_y, 6)
        end
        
      end
    end
  end
end


function get_rand_between(padding)
    -- 128 screen width, 8 sprite width, padding on both sides
    local max = 128 - padding - 8
    local min = padding
    return flr(rnd(max - min) + min)
end