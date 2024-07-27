-- Lua script of item potion_de_vie.
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

item:set_savegame_variable("possession_potion_de_vie")
item:set_amount_savegame_variable("amount_potion_de_vie")
item:set_max_amount(10)
item:set_assignable(true)

end

-- Event called when the hero starts using this item.
function item:on_using()
if item:get_amount() == 0 then
  sol.audio.play_sound("wrong")
item:set_finished()
else
      if game:get_life() == game:get_max_life() then
      game:start_dialog("item.potion_de_vie.non")
      else
      item:remove_amount(1)
      local count = 0
        game:add_life(8)
      sol.timer.start(item, 500, function()
      sol.audio.play_sound("heart")
      count = count + 1
      return count < 2
      end)
      end
end
  item:set_finished()
end

function item:on_obtaining()
  item:add_amount(1)
  game:set_item_assigned(1, item)
end