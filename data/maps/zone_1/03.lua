-- Lua script of map zone_1/03.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()


function shop:on_interaction()

game:start_dialog("dialogue/lanterne" , function(answer)
    if answer == 1 then
            game:start_dialog("donnelanterne")

    elseif answer == 2 then

        game:start_dialog("lanternedonnée")
end
end)
end