local enemy = ...
local behavior = require("enemies/scrypts/bm/bubble")

-- Bubble: an invincible enemy that moves in diagonal directions
-- and bounces against walls - this one shocks the hero.

local properties = {
  sprite = "enemies/piege/bubble_yellow",
}
behavior:create(enemy, properties)

function enemy:on_attacking_hero(hero)
  if not hero:is_invincible() then
    -- Geler le héros pendant 2 secondes et lui enlever 1 point de vie
    hero:freeze()
    hero:get_game():remove_life(1)
    sol.audio.play_sound("spark")
    
    -- Dégeler le héros après 2 secondes
    sol.timer.start(hero, 2000, function()
      hero:unfreeze()
    end)

    hero:set_invincible(true, 200)
    if self:get_game():get_magic() > 0 then
      self:get_game():remove_magic(2)
      sol.audio.play_sound("magic_bar")
    end
  end
end
