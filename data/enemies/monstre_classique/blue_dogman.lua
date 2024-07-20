local enemy = ...

-- Blue Dogman

require("enemies/scrypts/dx/generic_towards_hero.lua")(enemy)
enemy:set_properties({
  sprite = "enemies/monstre_classique/blue_dogman",
  life = 6,
  damage = 4,
  normal_speed = 48,
  faster_speed = 48
})

