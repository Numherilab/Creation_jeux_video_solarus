local enemy = ...
local behavior = require("enemies/scrypts/bm/toward_hero")

-- Crab: a basic enemy.

local properties = {
  sprite = "enemies/animaux/crab",
  life = 2,
  damage = 2,
  normal_speed = 32,
  faster_speed = 40,
}
behavior:create(enemy, properties)