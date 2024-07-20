local enemy = ...

local nb_sons_created = 0

function enemy:on_created()
  self:set_size(32, 24)
  self:set_origin(16, 21)
  self:set_optimization_distance(0)

  if self:test_obstacles(0, 0) then
    -- Ne pas apparaître sur des pierres créées précédemment.
    self:remove()
    return
  end

  self:set_life(1)
  self:set_damage(1)
  self:set_invincible()

  local sprite = self:create_sprite("enemies/boss/drakomos/drakomos_lava_spawner")
  function sprite:on_animation_finished(animation)
    if animation == "disappearing" then
      enemy:remove()
    end
  end
end

function enemy:on_restarted()
  self:set_can_attack(false)

  -- Vérification de l'existence avant de démarrer le timer
  local function start_disappearing_animation()
    if not self or not self:exists() then
      return false  -- Si l'ennemi n'existe plus, arrêter le timer.
    end

    local sprite = self:get_sprite()
    sprite:set_animation("disappearing")
    sol.audio.play_sound("ice")

    local hero = self:get_map():get_entity("hero")
    if math.random(2) == 1 or self:get_distance(hero) < 24 then
      nb_sons_created = nb_sons_created + 1
      local son_name = self:get_name() .. "_son_" .. nb_sons_created
      local son = self:create_enemy{
        name = son_name,
        breed = "boss/drakomos/red_helmasaur",
      }
      local game = self:get_map():get_game()
      if game:get_life() <= game:get_max_life() / 3 then
        son:set_treasure("heart", 1)
      end
      print("Enemy created: " .. son_name)  -- Message de débogage pour la création d'un ennemi
    else
      local x, y, layer = self:get_position()
      self:get_map():create_destructible{
        x = x,
        y = y,
        layer = layer,
        sprite = "destructibles/stone_small_black",
        destruction_sound = "stone",
        weight = 0,
        damage_on_enemies = 6,
      }
      print("Destructible created at position: (" .. x .. ", " .. y .. ")")  -- Message de débogage pour la création du destructible
    end
    return false  -- Pour arrêter le timer après une exécution
  end

  -- Démarrage du timer avec la fonction anonyme
  if self:exists() then
    sol.timer.start(self, 1000, start_disappearing_animation)
  end
end
