local enemy = ...

-- Bari: a flying enemy that follows the hero and tries to electrocute him.

local shocking = false

function enemy:on_created()
  self:set_life(3)
  self:set_damage(6)
  self:create_sprite("enemies/animaux/bari_blue")
  self:set_size(16, 16)
  self:set_origin(8, 13)
  self:set_attack_consequence("hookshot", "immobilized")
  self:start_shock_cycle() -- Commence le cycle d'électrocution
end

function enemy:shock()
  local sprite = self:get_sprite()
  if sprite:has_animation("shaking") then
    shocking = true
    sprite:set_animation("shaking")
    sol.timer.start(self, 5000, function() -- 5 secondes d'électrocution
      self:stop_shock()
    end)
  else
    print("Animation 'shaking' does not exist in sprite 'enemies/animaux/bari_blue'")
  end
end

function enemy:stop_shock()
  local sprite = self:get_sprite()
  if sprite:has_animation("walking") then
    shocking = false
    sprite:set_animation("walking")
    sol.timer.start(self, 5000, function() -- 5 secondes avant la prochaine électrocution
      self:shock()
    end)
  else
    print("Animation 'walking' does not exist in sprite 'enemies/animaux/bari_blue'")
  end
end

function enemy:start_shock_cycle()
  self:shock()
end

function enemy:on_restarted()
  local m = sol.movement.create("path_finding")
  m:set_speed(32)
  m:start(self)
  if not shocking then
    sol.timer.start(self, 5000, function() self:shock() end) -- Redémarre le cycle d'électrocution au redémarrage
  end
end

function enemy:on_immobilized()
  shocking = false
end

function enemy:on_hurt_by_sword(hero, enemy_sprite)
  if shocking then
    hero:start_hurt(6) -- Inflige des dégâts au héros en le touchant pendant l'électrocution
  else
    self:hurt(1)
    self:remove_life(1)
  end
end

function enemy:on_attacking_hero(hero, enemy_sprite)
  if shocking then
    hero:start_hurt(6) -- Inflige des dégâts au héros en le touchant pendant l'électrocution
  else
    hero:start_hurt(self:get_damage())
  end
end

function enemy:on_dying()
  -- It splits into two mini baris when it dies
  self:create_enemy({ breed = "animaux/bari_mini" })
  self:create_enemy({ breed = "animaux/bari_mini" })
end
