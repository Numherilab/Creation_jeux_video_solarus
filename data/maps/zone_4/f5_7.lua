-- Lua script of map zone_4/.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

local map = ...
local game = map:get_game()

local fighting_boss = false
local nb_spawners_created = 0
local boss

-- Positions possibles des spawn de lave de Drakomos
local spawner_xy = {
  { x = 176, y = 301 },
  { x = 272, y = 325 },
  { x = 320, y = 301 },
  { x = 392, y = 365 },
  { x = 400, y = 237 },
  { x = 144, y = 245 },
  { x = 152, y = 325 },
  { x = 152, y = 365 },
  { x = 312, y = 357 },
  { x = 392, y = 325 },
  { x = 232, y = 301 },
  { x = 368, y = 301 }
}

local function repeat_lava_spawner()
  if boss and boss:get_life() > 0 then  -- Boss vivant
    nb_spawners_created = nb_spawners_created + 1
    local index = math.random(#spawner_xy)
    map:create_enemy{
      name = "spawner_" .. nb_spawners_created,
      breed = "boss/drakomos/drakomos_lava_spawner",
      layer = 0,
      x = spawner_xy[index].x,
      y = spawner_xy[index].y,
      direction = 0
    }
    sol.timer.start(5000 + math.random(10000), repeat_lava_spawner)
  end
end

function map:on_started(destination)
  boss = map:get_entity("boss")
  if boss then
    boss:set_enabled(false)
    function boss:on_dead()
      game:set_value("b321", true)  -- Marquer le boss comme tué
    end
  end
end

function start_boss_sensor:on_activated()
  if not game:get_value("b321") and not fighting_boss then
    start_boss_sensor:set_enabled(false)
    hero:freeze()
    sol.timer.start(1000, function()
      sol.audio.play_music("boss")
      if boss then
        boss:set_enabled(true)
      end
      hero:unfreeze()
      sol.timer.start(3000, repeat_lava_spawner)
      fighting_boss = true
    end)
  end
end
