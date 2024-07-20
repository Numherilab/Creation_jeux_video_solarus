local enemy = ...
local behavior = require("enemies/scrypts/bm/bubble")

-- Bubble: an invincible enemy that moves in diagonal directions
-- and bounces against walls - this one is made of water.

local properties = {
  sprite = "enemies/piege/bubble_blue",
}
behavior:create(enemy, properties)

-- Fonction pour vérifier si une condition est active
local function is_condition_active(hero, condition)
  return hero.condition and hero.condition[condition] or false
end

-- Fonction pour définir une condition
local function set_condition(hero, condition, active)
  hero.condition = hero.condition or {}
  hero.condition[condition] = active
end

-- Fonction pour arrêter la condition slow
local function stop_slow(hero)
  if is_condition_active(hero, 'slow') and hero.slow_timer ~= nil then
    hero.slow_timer:stop()
  end

  set_condition(hero, 'slow', false)
  hero:set_walking_speed(88)
end

function enemy:on_attacking_hero(hero)
  if not hero:is_invincible() then
    -- Application de la condition slow
    if is_condition_active(hero, 'slow') and hero.slow_timer ~= nil then
      hero.slow_timer:stop()
    end

    set_condition(hero, 'slow', true)
    hero:set_walking_speed(48)
    hero.slow_timer = sol.timer.start(hero, 5000, function()
      stop_slow(hero)
    end)
    
    -- Rendre le héros invincible temporairement pour éviter les attaques consécutives
    hero:set_invincible(true, 200)

    -- Retirer 2 points de vie au héros
    local game = hero:get_game()
    game:remove_life(1)
    
    -- Réduire la magie si elle est disponible
    if game:get_magic() > 0 then
      game:remove_magic(2)
      sol.audio.play_sound("magic_bar")
    end
  end
end

return enemy
