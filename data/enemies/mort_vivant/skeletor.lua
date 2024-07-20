local enemy = ...

-- Skeletor.

require("enemies/scrypts/dx/generic_towards_hero")(enemy)
enemy:set_properties({
  sprite = "enemies/mort_vivant/skeletor",
  life = 3,
  damage = 2
})

