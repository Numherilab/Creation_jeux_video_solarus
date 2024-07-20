-- Script that creates a game ready to be played.

-- Usage:
-- local game_manager = require("scripts/game_manager")
-- local game = game_manager:create("savegame_file_name")
-- game:start()

require("scripts/multi_events")
local initial_game = require("scripts/initial_game")
local pause_menu_builder = require("scripts/menus/pause_menu_builder")

local game_manager = {}

-- Creates a game ready to be played.
function game_manager:create(file)

  -- Create the game (but do not start it).
  local exists = sol.game.exists(file)
  local game = sol.game.load(file)
  if not exists then
    -- This is a new savegame file.
    initial_game:initialize_new_savegame(game)
  end

local pause_menu = pause_menu_builder:create(game)

function game:on_paused()
sol.audio.play_sound("pause_open")
sol.menu.start(game, pause_menu)
end

function game:on_unpaused()
sol.audio.play_sound("pause_closed")
sol.menu.stop(pause_menu)
end

  return game
end

return game_manager
