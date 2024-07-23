-- Lua script of map zone_1/01.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

function secret:on_activated()

sol.audio.play_sound("treasure")
map:set_entities_enabled("secretmur",false)   
end

function gardequimarche:on_interaction()
    local movement = sol.movement.create("path")
    movement:set_path{0, 0, 0, 0, 2, 2, 2, 2, 4, 4, 4, 4, 6, 6, 6, 6}
    movement:set_speed(45)
    movement:start(gardequimarche)
end
