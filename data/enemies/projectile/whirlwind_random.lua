local enemy = ...
local game = enemy:get_game()

-- A whirlwind created by another enemy.

function enemy:on_created()
  self:set_life(1)
  self:set_damage(8)
  self:create_sprite("enemies/projectile/whirlwind_random")
  self:set_size(48, 64)
  self:set_origin(24, 31)
  self:set_invincible()
  self:set_attack_consequence("sword", "custom")
  self:set_obstacle_behavior("flying")
  self:set_layer_independent_collisions(true)
  self:set_pushed_back_when_hurt(false)
  self:set_can_hurt_hero_running(true)
  self:set_push_hero_on_sword(true)
  self:set_optimization_distance(0)
  self:set_minimum_shield_needed(3)  -- Mirror shield protects hero.
end

function enemy:on_restarted()
  sol.audio.play_sound("wind")
  self:start_random_movement()
end

function enemy:start_random_movement()
  local m = sol.movement.create("random")
  m:set_speed(144)
  m:set_ignore_obstacles(false)
  m:start(self)
  
  function m:on_obstacle_reached()
    enemy:bounce()
  end
end

function enemy:bounce()
  local angle = math.random(0, 2 * math.pi)
  local m = sol.movement.create("straight")
  m:set_speed(144)
  m:set_angle(angle)
  m:set_ignore_obstacles(false)
  m:start(self)

  function m:on_obstacle_reached()
    enemy:bounce()
  end
end

function enemy:on_custom_attack_received(attack, sprite)
  if attack == "sword" and game:get_item("sword"):get_variant() == 3 then
    -- Only hurt by the light sword.
    sprite:fade_out(20, function() self:remove() end)
  end
end
