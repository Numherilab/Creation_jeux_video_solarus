local enemy = ...
local map = enemy:get_map()
local angry = false   -- Indique si le cucco est en colère
local num_times_hurt = 0 -- Nombre de fois que le cucco a été blessé

-- Cucco (Poulet Hylien) : L'attaquer trop souvent déclenche une riposte.

function enemy:on_created()
  self:set_life(100)  -- Définit les points de vie du cucco à 100
  self:set_damage(2)   -- Définit les dégâts infligés par le cucco à 2
  self:create_sprite("enemies/animaux/cucco")  -- Associe un sprite spécifique au cucco
  self:set_size(16, 16)  -- Définit la taille du cucco
  self:set_origin(8, 13)  -- Définit l'origine du cucco
end

function enemy:on_movement_changed(movement)
  local direction4 = movement:get_direction4()  -- Obtient la direction du mouvement (0-3)
  self:get_sprite():set_direction(direction4)  -- Définit la direction du sprite en fonction du mouvement
end

function enemy:on_obstacle_reached(movement)
  if not angry then
    enemy:go_random()  -- Si le cucco n'est pas en colère, il se déplace de manière aléatoire
  else
    enemy:go_angry()  -- Si le cucco est en colère, il cible le héros
  end
end

function enemy:on_restarted()
  if angry then
    enemy:go_angry()  -- Si le cucco est en colère, il cible le héros
  else
    enemy:go_random()  -- Sinon, il se déplace de manière aléatoire
    sol.timer.start(enemy, 100, function()
      if map.angry_cuccos and not angry then
        enemy:go_angry()  -- Si un cucco de la carte est en colère, tous les cuccos deviennent en colère
        return false
      end
      return true  -- Répète le timer.
    end)
  end
end

function enemy:go_random()
  angry = false  -- Définit l'état de colère à faux
  local movement = sol.movement.create("random")  -- Crée un mouvement aléatoire
  movement:set_speed(32)  -- Définit la vitesse du mouvement
  movement:start(enemy)  -- Démarre le mouvement
  enemy:set_can_attack(false)  -- Le cucco ne peut pas attaquer dans cet état
end

function enemy:go_angry()
  angry = true  -- Définit l'état de colère à vrai
  map.angry_cuccos = true  -- Indique que les cuccos de la carte sont en colère
  going_hero = true
  sol.audio.play_sound("cucco")  -- Joue un son de cucco
  local movement = sol.movement.create("target")  -- Crée un mouvement ciblant le héros
  movement:set_speed(96)  -- Définit la vitesse du mouvement en colère
  movement:start(enemy)  -- Démarre le mouvement
  enemy:get_sprite():set_animation("angry")  -- Change l'animation du sprite pour "angry"
  enemy:set_can_attack(true)  -- Le cucco peut attaquer dans cet état
end

function enemy:on_hurt()
  sol.audio.play_sound("cucco")  -- Joue un son de cucco lorsque blessé
  num_times_hurt = num_times_hurt + 1  -- Incrémente le compteur de blessures
  if num_times_hurt == 3 and not map.angry_cuccos then
    -- Si le cucco est blessé 3 fois et qu'aucun cucco n'est encore en colère, déclenche la colère
    map.angry_cuccos = true  -- Tous les cuccos de la carte deviennent en colère et attaquent le héros
  end
end
