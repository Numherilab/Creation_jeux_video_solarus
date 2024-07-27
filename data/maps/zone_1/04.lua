-- Lua script of map zone_1/04.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()


function sautepano:on_interaction()

game:start_dialog("saute" , function(answer)
    if answer == 1 then
            game:start_dialog("saute oui")

    elseif answer == 2 then

        game:start_dialog("saute non")
end
end)
end

-- dialogue avec le corbeau

function crow:on_interaction()

    if game:get_money() < 99 then
        game:start_dialog("zone_1.crow_question")

    elseif game:get_money() >= 99 then
        game:remove_money(100)
        game:start_dialog("zone_1.crow_oui")
        
        local movement = sol.movement.create("path")
        movement:set_path{4, 4}
        movement:set_speed(48)
        movement:start(crow)

    end

end


function map:on_started(destination)
  -- Désactiver le miniboss à l'initialisation de la carte.
  if miniboss ~= nil then
    miniboss:set_enabled(false)
  end

  -- Démarrer immédiatement la bataille du miniboss
  if miniboss ~= nil then
    miniboss:set_enabled(true)
  end
end


