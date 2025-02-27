local behavior = {}

--This enemy is like Zelda's Leever. It moves randomly, and periodically will burrow below ground to later pop up. It is invulnerable when below ground. Special properties of this enemy type are time_underground, time_aboveground, and burrow_deviation. Time below/above ground are minimums, with the deviation being the random amount (in ms) to add to that. That keeps them from popping in and out in swarms if you have multiple. You could also use this for a ghost that phases in/out.
--Required sprites are walking, burrowing, and underground (which can be an empty graphic if you don't want they player to know where they are.
--You'll also need a sound called "burrow1" so they can make a noise and they go underground.

-- The properties parameter is a table.
-- All its values are optional except the sprite.

function behavior:create(enemy, properties)

  local going_hero = false
  local underground = false
  

  -- Set default properties.
  if properties.size_x == nil then
    properties.size_x = 16
  end
  if properties.size_y == nil then
    properties.size_y = 16
  end
  if properties.life == nil then
    properties.life = 2
  end
  if properties.damage == nil then
    properties.damage = 2
  end
  if properties.normal_speed == nil then
    properties.normal_speed = 32
  end
  if properties.faster_speed == nil then
    properties.faster_speed = 48
  end
  if properties.hurt_style == nil then
    properties.hurt_style = "normal"
  end
  if properties.pushed_when_hurt == nil then
    properties.pushed_when_hurt = true
  end
  if properties.push_hero_on_sword == nil then
    properties.push_hero_on_sword = false
  end
  if properties.ignore_obstacles == nil then
    properties.ignore_obstacles = false
  end
  if properties.detection_distance == nil then
    properties.detection_distance = 80
  end
  if properties.obstacle_behavior == nil then
    properties.obstacle_behavior = "normal"
  end
  if properties.movement_create == nil then
    properties.movement_create = function()
      local m = sol.movement.create("random_path")
      return m
    end
  end
  if properties.time_underground == nil then
    properties.time_underground = 2000
  end
  if properties.time_aboveground == nil then
    properties.time_aboveground = 3000
  end
  if properties.burrow_deviation == nil then
    properties.burrow_deviation = 6000
  end
  if properties.burrow_sound == nil then
    properties.burrow_sound = "burrow1"
  end
  

--create enemy properties
  function enemy:on_created()

    self:set_life(properties.life)
    self:set_damage(properties.damage)
    self:create_sprite(properties.sprite)
    self:set_hurt_style(properties.hurt_style)
    self:set_pushed_back_when_hurt(properties.pushed_when_hurt)
    self:set_push_hero_on_sword(properties.push_hero_on_sword)
    self:set_obstacle_behavior(properties.obstacle_behavior)
    self:set_size(properties.size_x, properties.size_y)
    self:set_origin(properties.size_x / 2, properties.size_y - 3)

  end


  function enemy:on_movement_changed(movement)

    local direction4 = movement:get_direction4()
    local sprite = self:get_sprite()
    sprite:set_direction(direction4)
  end


  function enemy:on_restarted()
    self:go_random()
    self:check_hero()
    
  end

  

  function enemy:burrow_down()
    sol.timer.stop_all(self)
    self:get_sprite():set_animation("burrowing")
    --play the sound if you're close enough
    local hero = self:get_map():get_entity("hero")
    local _, _, layer = self:get_position()
    local near_hero = self:get_distance(hero) < 140
    if enemy:is_on_screen() then sol.audio.play_sound(properties.burrow_sound) end
    sol.timer.start(self, 800, function() self:go_underground() end)
  end

  function enemy:burrow_up()
    self:get_sprite():set_animation("burrowing")
   --play the sound if you're close enough
    local hero = self:get_map():get_entity("hero")
    local _, _, layer = self:get_position()
    local near_hero = self:get_distance(hero) < 160
    if enemy:is_on_screen() then sol.audio.play_sound(properties.burrow_sound) end
    sol.timer.start(self, 800, function() self:go_aboveground() end)
  end

  function enemy:go_underground()
    underground = true
    self:get_sprite():set_animation("underground")
--this code is so you don't get chased by an underground dude
    local m = properties.movement_create()
    if m == nil then
      -- No movement.
      self:get_sprite():set_animation("stopped")
      m = self:get_movement()
      if m ~= nil then
        -- Stop the previous movement.
        m:stop()
      end
    else
      m:set_speed(properties.normal_speed)
      m:set_ignore_obstacles(properties.ignore_obstacles)
      m:start(self)
    end
--]]
    self:set_can_attack(false)
    sol.timer.start(self, (properties.time_underground + math.random(properties.burrow_deviation)), function() self:burrow_up() end)
    
  end

  function enemy:go_aboveground()
    underground = false
    self:set_can_attack(true)
    self:get_sprite():set_animation("walking")
    self:check_hero()
  end


  function enemy:check_hero()
--print("checking hero")
--sol.audio.play_sound("cursor")
    local hero = self:get_map():get_entity("hero")
    local _, _, layer = self:get_position()
    local _, _, hero_layer = hero:get_position()
    local near_hero =
        (layer == hero_layer or enemy:has_layer_independent_collisions()) and
        self:get_distance(hero) < properties.detection_distance
--        self:is_in_same_region(hero)

    if near_hero and not going_hero then
      if underground == false then self:go_hero()
      else self:go_random()
      end
    elseif not near_hero --[[and going_hero--]] then
      self:go_random()
    end
--and repeat this every 150ms
    sol.timer.start(self, 150, function() self:check_hero() end)

  end



  function enemy:go_random()
--    print("going random")
--    sol.audio.play_sound("wrong")
    going_hero = false
    sol.timer.start(self, properties.time_aboveground+math.random(properties.burrow_deviation), function() self:burrow_down() end)
    local m = properties.movement_create()
    if m == nil then
      -- No movement.
      self:get_sprite():set_animation("stopped")
      m = self:get_movement()
      if m ~= nil then
        -- Stop the previous movement.
        m:stop()
      end
    else
      m:set_speed(properties.normal_speed)
      m:set_ignore_obstacles(properties.ignore_obstacles)
      self:get_sprite():set_animation("walking")
      m:start(self)
    end
  end



  function enemy:go_hero()
    going_hero = true
    sol.timer.stop_all(self)
    sol.timer.start(self, (properties.time_aboveground + math.random(properties.burrow_deviation + 2000)), function() self:burrow_down() end)
    local m = sol.movement.create("target")
    m:set_speed(properties.faster_speed)
    m:set_ignore_obstacles(properties.ignore_obstacles)
    m:start(self)
    self:get_sprite():set_animation("walking")
  end



end

return behavior