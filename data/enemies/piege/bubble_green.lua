local enemy = ...
local behavior = require("enemies/scrypts/bm/bubble")

-- Bubble: an invincible enemy that moves in diagonal directions
-- and bounces against walls - this one poisons the hero.

local properties = {
  sprite = "enemies/piege/bubble_green",
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

-- Fonction pour arrêter la condition poison
local function stop_poison(hero)
  if is_condition_active(hero, 'poison') and hero.poison_timer ~= nil then
    hero.poison_timer:stop()
  end

  hero:set_blinking(false)
  set_condition(hero, 'poison', false)
end

-- Fonction pour appliquer la condition poison
local function start_poison(hero, damage, delay, max_iteration)
  if is_condition_active(hero, 'poison') and hero.poison_timer ~= nil then
    hero.poison_timer:stop()
  end

  local iteration_poison = 0
  local function do_poison()
    if is_condition_active(hero, "poison") and iteration_poison < max_iteration then
      sol.audio.play_sound("hero_hurt")
      hero:get_game():remove_life(damage)
      iteration_poison = iteration_poison + 1
    end

    if iteration_poison == max_iteration then
      stop_poison(hero)
    else
      hero.poison_timer = sol.timer.start(hero, delay, do_poison)
    end
  end

  hero:set_blinking(true, delay)
  set_condition(hero, 'poison', true)
  do_poison()
end

function enemy:on_attacking_hero(hero)
  if not hero:is_invincible() then
    -- Appliquer la condition poison
    start_poison(hero, 1, 1000, 4)
    hero:set_invincible(true, 200)

    -- Réduire la magie si elle est disponible
    if self:get_game():get_magic() > 0 then
      self:get_game():remove_magic(2)
      sol.audio.play_sound("magic_bar")
    end
  end
end

return enemy
