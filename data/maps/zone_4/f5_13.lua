-- Lua script of map zone_4/f5_13.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

function fin:on_activated()

game:start_dialog("zone_4.zone_4_a")
end

