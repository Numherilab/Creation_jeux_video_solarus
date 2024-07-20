-- Lua script of item fleches.
-- This script is executed only once for the whole game.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation for the full specification
-- of types, events and methods:
-- http://www.solarus-games.org/doc/latest

local item = ...
local game = item:get_game()

function item:on_started()

  item:set_brandish_when_picked(false)
  local possession_arc = game:get_value("possession_arc") or 0
  item:set_obtainable(possession_arc > 0)
end



function item:on_obtaining()

game:get_item("arc"):add_amount(5)
end