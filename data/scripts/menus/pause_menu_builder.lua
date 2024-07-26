 local pause_menu_builder = {}

local item_names = {
 "arc",
 "boomerang",
 "lantern",
 "fire_rod",
 "potion_de_vie" ,
 "potionlavie" ,
 "pegasus_shoes" ,
 "hookshot" ,
 "bomb_counter" ,
 "dash" ,
 "water_rod",
}



local square_size = 24
local spacing = 8
local item_margin = 4
local num_rows = 4
local num_columns = 5
local grid_width = num_columns * (square_size + spacing) - spacing
local grid_height = num_rows * (square_size + spacing) - spacing
local quest_width, quest_height = sol.video.get_quest_size()
local grid_x = quest_width / 2 - grid_width / 2
local grid_y = quest_height / 2 - grid_height / 2

local square_img = sol.surface.create(square_size, square_size)
square_img:fill_color({20, 20, 20})
square_img:set_opacity(150)

local item_sprite = sol.sprite.create("entities/items")

--dessin de la grille sans les items
local function draw_grid(grid_surface)

      local dst_x, dst_y = 0, 0

      for row = 1, num_rows do
          for column = 1, num_columns do
              square_img:draw(grid_surface, dst_x, dst_y)
              dst_x = dst_x + square_size + spacing
              end
              dst_x = 0
              dst_y = dst_y + square_size + spacing        
      end
end

--dessin des items dans la grille

local function draw_items(grid_surface, game)

  local dst_x, dst_y = 0, 0

  for index, item_name in ipairs(item_names) do
    local item = game:get_item(item_name)
    local variant = item:get_variant()
    if variant > 0 then
    item_sprite:set_animation(item_name)
    item_sprite:set_direction(variant - 1)
    local origin_x, origin_y = item_sprite:get_origin()
    item_sprite:draw(grid_surface, dst_x + origin_x + item_margin, dst_y + origin_y + item_margin)
  end
    if index % num_columns == 0 then
       dst_x = 0
       dst_y = dst_y + square_size + spacing        
       else
       dst_x = dst_x + square_size + spacing


        end
    end
end

  function pause_menu_builder:create(game)

  local pause_menu = {}
  local grid_surface
  local cursor_sprite = sol.sprite.create("menus/inventory/selector")
  local cursor_x, cursor_y  
  local cursor_row, cursor_column = 0, 0

 local function update_cursor()
     cursor_x = grid_x - 4 + (cursor_column * (square_size + spacing))
     cursor_y = grid_y - 4 + (cursor_row * (square_size + spacing))

  end

  local function assign_item(slot)
    local index = cursor_row * num_columns + cursor_column + 1  --    
    local item_name = item_names[index]
    if item_name == nil then 
    return
    end
    local item = game:get_item(item_name)
    local variant = item:get_variant()
    if variant == 0 then 
    return
  end

local other_slot = 3 - slot
local other_item = game:get_item_assigned(other_slot)
if other_item == item then  
game:set_item_assigned(other_slot, game:get_item_assigned(slot))
end

  sol.audio.play_sound("throw")  
  game:set_item_assigned(slot, item)
end
  

  function pause_menu:on_started()
    grid_surface = sol.surface.create(grid_width, grid_height)
    draw_grid(grid_surface)
    draw_items(grid_surface, game)
    update_cursor()
  end

  function pause_menu:on_draw(dst_surface)
    grid_surface:draw(dst_surface, grid_x, grid_y) 
    cursor_sprite:draw(dst_surface, cursor_x, cursor_y)
  end
  
 

  function pause_menu:on_command_pressed(command)
     local handled = false
  if command == "right" then
     sol.audio.play_sound("cursor")
     cursor_column = (cursor_column + 1) % num_columns
     update_cursor()
     handled = true
  elseif command == "up" then
     sol.audio.play_sound("cursor")
     cursor_row = (cursor_row - 1) % num_rows
     update_cursor()
     handled = true
  elseif command == "left" then
     sol.audio.play_sound("cursor")
     cursor_column = (cursor_column - 1) % num_columns
     update_cursor()
     handled = true
  elseif command == "down" then
     sol.audio.play_sound("cursor")
     cursor_row = (cursor_row + 1) % num_rows
     update_cursor()
     handled = true
  elseif command == "item_1" then 
    assign_item(1)
     handled = true
  elseif command == "item_2" then
    assign_item(2)
     handled = true


  end
    return handled
 end

  return pause_menu

end

return pause_menu_builder