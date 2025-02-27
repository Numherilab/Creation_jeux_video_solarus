-- A flame that can hurt enemies.
-- It is meant to by created by the lamp and the fire rod.
local water = ...

require("scripts/meta/enemy")  -- enemy:receive_attack_consequence()

local sprite

local enemies_touched = { }

water:set_size(8, 8)
water:set_origin(4, 5)
sprite = water:get_sprite() or water:create_sprite("entities/water")
sprite:set_direction(water:get_direction())

-- Remove the sprite if the animation finishes.
-- Use animation "flying" if you want it to persist.
function sprite:on_animation_finished()
  water:remove()
end

-- Returns whether a destructible is a bush.
local function is_bush(destructible)

  local sprite = destructible:get_sprite()
  if sprite == nil then
    return false
  end

  -- TODO : Use a systeme with animation_set
  local sprite_id = sprite:get_animation_set()
  return sprite_id == "entities/bush" or sprite_id:match("^destructibles/bush_")
end

local function bush_collision_test(water, other)

  if other:get_type() ~= "destructible" then
    return false
  end

  if not is_bush(other) then
    return
  end

  -- Check if the water box touches the one of the bush.
  -- To do this, we extend it of one pixel in all 4 directions.
  local x, y, width, height = water:get_bounding_box()
  return other:overlaps(x - 1, y - 1, width + 2, height + 2)
end

-- Traversable rules.
water:set_can_traverse("crystal", true)
water:set_can_traverse("crystal_block", true)
water:set_can_traverse("hero", true)
water:set_can_traverse("jumper", true)
water:set_can_traverse("stairs", false)
water:set_can_traverse("stream", true)
water:set_can_traverse("switch", true)
water:set_can_traverse("teletransporter", true)
water:set_can_traverse_ground("deep_water", true)
water:set_can_traverse_ground("shallow_water", true)
water:set_can_traverse_ground("hole", true)
water:set_can_traverse_ground("lava", true)
water:set_can_traverse_ground("prickles", true)
water:set_can_traverse_ground("low_wall", true)
water:set_can_traverse(true)
water.apply_cliffs = true

-- Burn bushes.
water:add_collision_test(bush_collision_test, function(water, entity)

  local map = water:get_map()

  if entity:get_type() == "destructible" then
    if not is_bush(entity) then
      return
    end
    local bush = entity

    local bush_sprite = entity:get_sprite()
    if bush_sprite:get_animation() ~= "on_ground" then
      -- Possibly already being destroyed.
      return
    end

    water:stop_movement()
    sprite:set_animation("stopped")
    sol.audio.play_sound("lantern")

    -- TODO remove this when the engine provides a function destructible:destroy()
    local bush_sprite_id = bush_sprite:get_animation_set()
    local bush_x, bush_y, bush_layer = bush:get_position()
    local treasure = { bush:get_treasure() }
    if treasure ~= nil then
      local pickable = map:create_pickable({
        x = bush_x,
        y = bush_y,
        layer = bush_layer,
        treasure_name = treasure[1],
        treasure_variant = treasure[2],
        treasure_savegame_variable = treasure[3],
      })
    end

    -- sol.audio.play_sound(bush:get_destruction_sound())
    sol.audio.play_sound("bush")
    bush:remove()

    local bush_destroyed_sprite = water:create_sprite(bush_sprite_id)
    local x, y = water :get_position()
    bush_destroyed_sprite:set_xy(bush_x - x, bush_y - y)
    bush_destroyed_sprite:set_animation("destroy")
  end
end)

-- Hurt enemies.
water:add_collision_test("sprite", function(water, entity)

  if entity:get_type() == "enemy" then
    local enemy = entity
    if enemies_touched[enemy] then
      -- If protected we don't want to play the sound repeatedly.
      return
    end
    enemies_touched[enemy] = true
    local reaction = enemy:get_water_reaction(enemy_sprite)
    enemy:receive_attack_consequence("water", reaction)

    sol.timer.start(water, 200, function()
      water:remove()
    end)
  end
end)

function water:on_obstacle_reached()
  water:remove()
end
