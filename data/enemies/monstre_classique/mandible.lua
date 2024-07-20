local enemy = ...

-- Mandible.

require("enemies/scrypts/dx/generic_towards_hero")(enemy)
enemy:set_properties({
  sprite = "enemies/monstre_classique/mandible",
  life = 3,
  damage = 2,
  hurt_style = "monster"
})

