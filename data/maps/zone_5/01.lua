-- Lua script of map zone_5/02.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()

  -- You can initialize the movement and sprites of various
  -- map entities here.
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end

function capteurpeche:on_activated()
          capteurpeche:remove()
          hero:freeze()
      
       sol.timer.start(map, 500, function()
       local camera = map:get_camera()
    
        local movement_1 = sol.movement.create("target")
      movement_1:set_target(camera:get_position_to_track(camera1))
      movement_1:set_speed(200)
      movement_1:start(camera, function()

      game:start_dialog("zone_5.quiveutpoisson")
 
        sol.timer.start(map, 1000, function()       
           
            local movement_5 = sol.movement.create("target")
              movement_5:set_target(camera:get_position_to_track(hero))
              movement_5:set_speed(200)
              movement_5:start(camera, function() 

          camera:start_tracking(hero)     
          hero:unfreeze()

     end)
    end)
   end) 
  end)
 end