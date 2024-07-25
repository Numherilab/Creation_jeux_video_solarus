-- Script of the water rod.
local item = ...

local behavior = require("items/inventory/library/magic_item")

local properties = {
  magic_needed = 4,
  sound_on_success = "lantern",
  savegame_variable = "possession_water_rod",
  hero_animation = "rod",
  sound_on_fail = "wrong",
  animation_sprite = "items/water_rod",
  animation_delay = 300,
  do_magic = function()

    -- Shoots some water on the map.
    local map = item:get_map()
    local hero = map:get_hero()
    local direction = hero:get_direction()

    local x, y, layer = hero:get_center_position()
    local water = map:create_custom_entity({
      model = "water",
      x = x,
      y = y + 3,
      layer = layer,
      width = 8,
      height = 8,
      direction = direction,
    })

    local water_sprite = water:get_sprite()
    water_sprite:set_animation("flying")

    local angle = direction * math.pi / 2
    local movement = sol.movement.create("straight")
    movement:set_speed(192)
    movement:set_angle(angle)
    movement:set_smooth(false)
    movement:start(water)
  end
}

behavior:create(item, properties)


-- Initialize the metatable of appropriate entities to work with the water.
local function initialize_meta()

  -- Add Lua water properties to enemies.
  local enemy_meta = sol.main.get_metatable("enemy")
  if enemy_meta.get_water_reaction ~= nil then
    -- Already done.
    return
  end

  enemy_meta.water_reaction = 3  -- 3 life points by default.
  enemy_meta.water_reaction_sprite = {}
  function enemy_meta:get_water_reaction(sprite)

    if sprite ~= nil and self.water_reaction_sprite[sprite] ~= nil then
      return self.water_reaction_sprite[sprite]
    end
    return self.water_reaction
  end

  function enemy_meta:set_water_reaction(reaction, sprite)

    self.water_reaction = reaction
  end

  function enemy_meta:set_water_reaction_sprite(sprite, reaction)

    self.water_reaction_sprite[sprite] = reaction
  end

  -- Change the default enemy:set_invincible() to also
  -- take into account the water.
  local previous_set_invincible = enemy_meta.set_invincible
  function enemy_meta:set_invincible()
    previous_set_invincible(self)
    self:set_water_reaction("ignored")
  end
  local previous_set_invincible_sprite = enemy_meta.set_invincible_sprite
  function enemy_meta:set_invincible_sprite(sprite)
    previous_set_invincible_sprite(self, sprite)
    self:set_water_reaction_sprite(sprite, "ignored")
  end

end
initialize_meta()
