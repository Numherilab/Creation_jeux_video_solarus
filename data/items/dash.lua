require("scripts/multi_events")
local item = ...
local game = item:get_game()
local behavior = require("items/inventory/library/magic_item")

local properties = {
  magic_needed = 5,  -- Consomme 3 points de magie
  sound_on_success = "cane",
  sound_on_fail = "wrong",
  savegame_variable = "possession_dash",
  assignable = true,
  do_magic = function()

    local hero = game:get_hero()
    local dir = hero:get_direction()
    if dir == 1 then dir = (math.pi/2) elseif dir == 2 then dir = math.pi elseif dir == 3 then dir = (3*math.pi/2) end
    local m = sol.movement.create("straight")
    m:set_angle(dir)
    m:set_speed(350)
    m:set_max_distance(64)
    m:set_smooth(true)
    hero:freeze()
    hero:set_blinking(true, 200)
    sol.audio.play_sound("cane")
    m:start(hero, function() hero:unfreeze() end)
    game:simulate_command_pressed("attack")
    hero:set_invincible(true, 300)

    function m:on_obstacle_reached()
      hero:unfreeze()
    end
  end
}

behavior:create(item, properties)

item:register_event("on_created", function(self)
  item:set_savegame_variable(properties.savegame_variable)
  item:set_assignable(properties.assignable)
end)

item:register_event("on_obtained", function(self)
  game:set_item_assigned(2, self)
end)

item:register_event("on_pickable_created", function(self, pickable)
  -- Vous pouvez définir un mouvement particulier ici si vous n'aimez pas celui par défaut.
end)

return item
