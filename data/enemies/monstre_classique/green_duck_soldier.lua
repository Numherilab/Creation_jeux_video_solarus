local enemy = ...

-- Green duck soldier.

require("enemies/scrypts/dx/generic_soldier")(enemy)
enemy:set_properties({
  main_sprite = "enemies/monstre_classique/green_duck_soldier",
  sword_sprite = "enemies/armes_enemies/green_duck_soldier_sword",
  life = 4,
  damage = 8,
  hurt_style = "monster",
  play_hero_seen_sound = true
})

