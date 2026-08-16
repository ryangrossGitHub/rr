-- 1. Added arrays to hold the shifting ratios for grass and sand
land = { 
  left = {}, right = {}, 
  l_grass_r = {}, l_sand_r = {}, -- Left side ratios
  r_grass_r = {}, r_sand_r = {}, -- Right side ratios
  length_max = 40, 
  scroll_offset = 0 
}  

function init_land() 
  for i=1, 129 do 
    -- Generate the main shoreline widths (your original logic)
    land.left[i] = get_rand_with_neg() + (land.left[i-1] or 0) 
    if land.left[i] < 0 then land.left[i] = 0 
    elseif land.left[i] > land.length_max then land.left[i] = land.length_max end  
    
    land.right[i] = get_rand_with_neg() + (land.right[i-1] or 0) 
    if land.right[i] > 128 then land.right[i] = 128 
    elseif land.right[i] < 128-land.length_max then land.right[i] = 128-land.length_max end 

    -- 2. Generate smooth random ratios based on the previous index
    -- Grass ratio targets around 0.65 to 0.75, Sand targets around 0.3 to 0.4
    land.l_grass_r[i] = clamp_val((rnd(0.04) - 0.02) + (land.l_grass_r[i-1] or 0.7), 0.5, 0.85)
    land.l_sand_r[i]  = clamp_val((rnd(0.04) - 0.02) + (land.l_sand_r[i-1] or 0.35), 0.15, 0.45)
    
    land.r_grass_r[i] = clamp_val((rnd(0.04) - 0.02) + (land.r_grass_r[i-1] or 0.7), 0.5, 0.85)
    land.r_sand_r[i]  = clamp_val((rnd(0.04) - 0.02) + (land.r_sand_r[i-1] or 0.35), 0.15, 0.45)
  end 
end  

-- Helper function to keep our random walk ratios within a beautiful visual boundary
function clamp_val(val, min_v, max_v)
  if val < min_v then return min_v end
  if val > max_v then return max_v end
  return val
end

function get_rand_with_neg() 
  return rnd(2) - 1 
end  

function update_land() 
  land.scroll_offset += speed
  
  while land.scroll_offset >= 1 do
    land.scroll_offset -= 1
    
    -- Drop the oldest row of data from all arrays
    deli(land.left, 1) 
    deli(land.right, 1)  
    deli(land.l_grass_r, 1)
    deli(land.l_sand_r, 1)
    deli(land.r_grass_r, 1)
    deli(land.r_sand_r, 1)
    
    -- Calculate new shoreline width
    local new_left = get_rand_with_neg() + land.left[128] 
    if new_left < 0 then new_left = 0 
    elseif new_left > land.length_max then new_left = land.length_max end  
    
    local new_right = get_rand_with_neg() + land.right[128] 
    if new_right > 128 then new_right = 128 
    elseif new_right < 128 - land.length_max then new_right = 128 - land.length_max end  
    
    add(land.left, new_left) 
    add(land.right, new_right) 

    -- 3. Push a brand new smooth ratio value to the top of the screen
    local new_l_grass = clamp_val((rnd(0.04) - 0.02) + land.l_grass_r[128], 0.5, 0.85)
    local new_l_sand  = clamp_val((rnd(0.04) - 0.02) + land.l_sand_r[128], 0.15, 0.45)
    local new_r_grass = clamp_val((rnd(0.04) - 0.02) + land.r_grass_r[128], 0.5, 0.85)
    local new_r_sand  = clamp_val((rnd(0.04) - 0.02) + land.r_sand_r[128], 0.15, 0.45)
    
    add(land.l_grass_r, new_l_grass)
    add(land.l_sand_r, new_l_sand)
    add(land.r_grass_r, new_r_grass)
    add(land.r_sand_r, new_r_sand)
  end
end  

function draw_land() 
  for i=0, 127 do 
    local draw_y = i - land.scroll_offset
    local left = land.left[i+1] 
    local right = land.right[i+1] 
    
    -------------------------------------------------------
    -- LEFT SIDE TERRAIN (Uses unique line-by-line ratios)
    -------------------------------------------------------
    if left > 0 then
      -- 1. Forest Base
      rectfill(0, draw_y, left, draw_y, 15) 
      
      -- 2. Grass (Multiplied by this line's custom smooth ratio)
      local left_grass = left * land.l_grass_r[i+1]
      rectfill(0, draw_y, left_grass, draw_y, 11) 
      
      -- 3. Sand (Multiplied by this line's custom smooth ratio)
      local left_sand = left * land.l_sand_r[i+1]
      rectfill(0, draw_y, left_sand, draw_y, 3)
    end
    
    -------------------------------------------------------
    -- RIGHT SIDE TERRAIN
    -------------------------------------------------------
    if right < 128 then
      local right_thickness = 128 - right
      
      -- 1. Forest Base
      rectfill(right, draw_y, 128, draw_y, 15) 
      
      -- 2. Grass
      local right_grass = 128 - (right_thickness * land.r_grass_r[i+1])
      rectfill(right_grass, draw_y, 128, draw_y, 11) 
      
      -- 3. Sand
      local right_sand = 128 - (right_thickness * land.r_sand_r[i+1])
      rectfill(right_sand, draw_y, 128, draw_y, 3)
    end
  end 
end