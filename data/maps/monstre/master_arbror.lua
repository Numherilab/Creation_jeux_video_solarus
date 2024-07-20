-- Lua script of map monstre/master_arbror.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

function start_boss_sensor:on_activated()
  sol.audio.play_music("boss")
  boss:set_enabled(true)
end

function boss:on_dead()
  sol.audio.play_music("victory")
end