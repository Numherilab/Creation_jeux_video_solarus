-- Lua script of item arc.
-- This script is executed only once for the whole game.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation for the full specification
-- of types, events and methods:
-- http://www.solarus-games.org/doc/latest

local item = ...
local game = item:get_game()

-- Event called when all items have been created.
function item:on_started()

  -- Initialize the properties of your item here,
  -- like whether it can be saved, whether it has an amount
  -- and whether it can be assigned.
item:set_savegame_variable("possession_" .. item:get_name())
item:set_amount_savegame_variable("amount_" .. item:get_name())
item:set_assignable(true)

end

-- Event called when the hero starts using this item.
function item:on_using()


  if item:get_amount() <= 0 then
    sol.audio.play_sound("wrong")
    item:set_finished()
    return
  end

local hero = game:get_hero()
 item:remove_amount(1)
 hero:start_bow()

end

function item:on_obtaining()
  game:get_item("carquois"):set_variant(1)
  game:get_item("fleches"):set_obtainable(true)
  item:set_amount(item:get_max_amount())
end

