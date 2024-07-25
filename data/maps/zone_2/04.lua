-- Lua script of map zone_2/04.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

function capteur_1:on_activated()
  capteur_1:remove()
  game:start_dialog("zone_2.tintin")
 
end
