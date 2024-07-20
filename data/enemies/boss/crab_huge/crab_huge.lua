local enemy = ...

-- Huge Crab: slow moving but much tougher crab (Overworld Boss).

local positions = {
  {x = 136, y = 280, direction4 = 3},
  {x = 320, y = 384, direction4 = 3},
  {x = 480, y = 368, direction4 = 3},
}

function enemy:on_created()
  self:set_life(12)
  self:set_damage(4)
  self:create_sprite("enemies/boss/crab_huge/crab_huge")
  self:set_size(256, 160)
  self:set_origin(172, 81)
  self.whirlwinds_created = false -- Track if whirlwinds have been created
  self.whirlwinds = {} -- List to keep track of created whirlwinds
end

function enemy:on_restarted()
  local m = sol.movement.create("path_finding")
  m:set_speed(24)
  m:start(self)
end

function enemy:on_hurt(attack)
  local life = self:get_life()
  local pos = positions[math.random(#positions)]
  local map = self:get_map()

  -- Create a crab at a random position
  map:create_enemy({
    breed = "animaux/crab",
    x = pos.x,
    y = pos.y,
    layer = self:get_layer(),
    direction = pos.direction4
  })

  -- When life is 6 or less and whirlwinds have not been created yet
  if life <= 6 and not self.whirlwinds_created then
    self.whirlwinds_created = true -- Ensure whirlwinds are created only once

    -- Create two whirlwinds at random positions
    for i = 1, 2 do
      local pos = positions[math.random(#positions)]
      local whirlwind = map:create_enemy({
        breed = "projectile/whirlwind_random",
        x = pos.x,
        y = pos.y,
        layer = self:get_layer(),
        direction = pos.direction4
      })
      table.insert(self.whirlwinds, whirlwind) -- Add whirlwind to the list
    end
  end
end

function enemy:on_dead()
  -- Remove all whirlwinds
  for _, whirlwind in ipairs(self.whirlwinds) do
    if whirlwind:exists() then
      whirlwind:remove()
    end
  end
end
