-- Lua script of map monstre/test_5.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

function torche_1:is_lit()
 coffrec_torche:set_enabled(true)
end

function  map:has_entities("torchec_"):is_lit()
 coffrec_torche:set_enabled(true)
end
