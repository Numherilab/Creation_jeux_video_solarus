-- Lua script of map Test monstre.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map is loaded.

function sensor_miniboss:on_activated()
  if miniboss_aquadraco ~= nil then
    map:close_doors("door_miniboss")
    miniboss_aquadraco:set_enabled(true)
    sol.audio.play_music("boss")
  end
end

if miniboss_aquadraco ~= nil then
  function miniboss_aquadraco:on_dead()
   
    sol.audio.play_sound("boss_killed")

  end
end