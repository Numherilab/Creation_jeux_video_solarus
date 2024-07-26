-- Lua script of map zone_1/01.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

function secret:on_activated()
  sol.audio.play_sound("treasure")
  map:set_entities_enabled("secretmur", false)   
end

-- Definition of the movement for the NPC "gardequimarche"
local start_x, start_y = 72, 384
local end_x, end_y = 384, 104
local detection_radius = 48 -- Définir le rayon de détection autour du PNJ
local detection_interval = 100 -- Intervalle de vérification en millisecondes
local teleport_x, teleport_y = 376, 320 -- Position de téléportation du héros

local function create_movement(npc, target_x, target_y)
  local movement = sol.movement.create("target")
  movement:set_speed(48) -- Définir la vitesse souhaitée (réduite)
  movement:set_target(target_x, target_y)
  movement:start(npc, function()
    -- Alterner les positions cibles pour le trajet de retour
    local x, y = npc:get_position()
    if x == target_x and y == target_y then
      if target_x == end_x and target_y == end_y then
        create_movement(npc, start_x, start_y)
      else
        create_movement(npc, end_x, end_y)
      end
    end
  end)
end

local function check_hero_distance(npc)
  local hero = map:get_hero()
  local npc_x, npc_y = npc:get_position()
  local hero_x, hero_y = hero:get_position()
  local distance = math.sqrt((npc_x - hero_x)^2 + (npc_y - hero_y)^2)

  if distance <= detection_radius then
    game:start_dialog("zone_1.halte", function()
      -- Téléporter le héros après le dialogue
      hero:set_position(teleport_x, teleport_y)
    end)
    return false -- Arrêter le timer après la détection
  else
    return true -- Continuer le timer
  end
end

local function start_detection(npc)
  sol.timer.start(npc, detection_interval, function()
    return check_hero_distance(npc)
  end)
end

function map:on_started()
  local npc = map:get_entity("gardequimarche") -- Assuming the NPC is named "gardequimarche" in the map editor
  if npc then
    npc:set_position(start_x, start_y) -- Set initial position
    create_movement(npc, end_x, end_y)
    start_detection(npc) -- Start detection for the hero
  end
end

function map:on_restarted()
  local npc = map:get_entity("gardequimarche") -- Assuming the NPC is named "gardequimarche" in the map editor
  if npc then
    create_movement(npc, end_x, end_y)
    start_detection(npc) -- Start detection for the hero
  end
end

function MRchips:on_interaction()
        game:start_dialog("MR.chipsdonnechips")
                hero:start_treasure("tunic", 1, "MR.chipsdonnechips", function()
        end)
    end
