-- Lua script of map qute 2 forêt.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

for enemy in map:get_entities_by_type("enemy") do
  function enemy:on_dead()
    if not map:has_entities("enemi_") then
      map:open_doors("portecle_")
    end
  end
end

function boss:on_dead()
porteboss:open()
end