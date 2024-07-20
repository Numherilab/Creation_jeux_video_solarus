local enemy = ...

-- Globul.

require("enemies/scrypts/dx/generic_towards_hero")(enemy)
enemy:set_properties({
  sprite = "enemies/monstre_classique/globul",
  life = 4,
  damage = 2
})

