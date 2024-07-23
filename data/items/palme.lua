-- Lua script of item palme.
-- This script is executed only once for the whole game.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation for the full specification
-- of types, events and methods:
-- http://www.solarus-games.org/doc/latest

local item = ...
local game = item:get_game()

local item = ...

function item:on_created()

item:set_savegame_variable("possession_" .. item:get_name())
end

function item:on_variant_changed(variant)
  -- the possession state of the flippers determines the built-in ability "swim"
  self:get_game():set_ability("swim", variant)
end

