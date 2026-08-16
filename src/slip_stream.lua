function draw_slipstream()
  for i=0, 127 do 
    local draw_y = i - land.scroll_offset
    
    -- Get this specific row's stream center point
    local mid_x = (land.right[i+1] - land.left[i+1]) / 2 + land.left[i+1]
    
    -- Dynamic waving width using PICO-8 sin math
    local stream_width = 4 + sin((time() * 2.5 + draw_y * 0.1) / 22) * 10
    
    -- Draw the continuous dark blue channel segment
    rectfill(mid_x - stream_width/2, draw_y, mid_x + stream_width/2, draw_y, 1)
  end
end