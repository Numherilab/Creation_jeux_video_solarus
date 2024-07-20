local camera_shake = {}

function camera_shake:shake(camera)
    
local game = camera:get_game()
    sol.audio.play_sound("quake")
    game:set_suspended(true)
local map = camera:get_map()

local angle = 0
local shaking_count = 0
    local function shake_step()
    local movement = sol.movement.create("straight")
    movement:set_speed(60)
    movement:set_smooth(false)
    movement:set_ignore_obstacles(true)
    movement:set_max_distance(4)
    movement:set_angle(angle)
    angle = math.pi - angle
    shaking_count = shaking_count + 1
    movement:start(camera, function()
        if shaking_count <= 15 then
        shake_step()
        else
        game:set_suspended(false)
        camera:start_tracking(map:get_hero())      
         end
      end)
   end 

    shake_step()
end
return camera_shake