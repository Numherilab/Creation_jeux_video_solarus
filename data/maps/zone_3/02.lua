-- Lua script of map zone_3/02.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

function sensor_miniboss:on_activated()
  if miniboss_aquadraco ~= nil then    
    miniboss_aquadraco:set_enabled(true)
    sol.audio.play_music("boss")
  end
end

if miniboss_aquadraco ~= nil then
  function miniboss_aquadraco:on_dead()
   
    sol.audio.play_sound("boss_killed")

  end
end