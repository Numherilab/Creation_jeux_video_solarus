local enemy = ...
local behavior = require("enemies/scrypts/bm/bubble")

-- Bubble: an invincible enemy that moves in diagonal directions
-- and bounces against walls - this one freezes the hero.

local properties = {
  sprite = "enemies/piege/bubble_white",
}
behavior:create(enemy, properties)

local normal_walking_speed = 88

function enemy:on_attacking_hero(hero)
  if not hero:is_invincible() then
    hero:set_walking_speed(2)
    hero:set_invincible(true, 200)
    
    -- Timer de 4 secondes pour rétablir la vitesse de marche
    sol.timer.start(hero, 4000, function()
      hero:set_walking_speed(normal_walking_speed)
    end)

    if self:get_game():get_magic() > 0 then
      self:get_game():remove_magic(2)
      sol.audio.play_sound("magic_bar")
    end
  end
end
