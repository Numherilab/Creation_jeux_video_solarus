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

function crow:on_interaction()

    if not game:get_value("crow_1") then
        game:start_dialog("crow_question", function(answer)
            if answer == 1 then
                if game:get_money() >= 100 then
                    game:remove_money(100)
                    game:start_dialog("crow_oui")
                else
                    game:start_dialog("not_enough_money")  -- Assurez-vous d'avoir un dialogue pour cette situation
                end
            elseif answer == 2 then
                game:start_dialog("crow_non")
            end
            game:set_value("crow_1", true)   
        end)
    else
        game:start_dialog("crow_already_done")  -- Assurez-vous d'avoir un dialogue pour cette situation
    end
end