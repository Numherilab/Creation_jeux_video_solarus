-- Lua script of item carquois.
-- This script is executed only once for the whole game.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation for the full specification
-- of types, events and methods:
-- http://www.solarus-games.org/doc/latest

local item = ...
local game = item:get_game()

function item:on_started()
  item:set_savegame_variable("possession_" .. item:get_name())
end

function item:on_variant_changed(variant)
    local max_amounts = { 30, 40, 50 }
     game:get_item("arc"):set_max_amount(max_amounts[variant])
end
 