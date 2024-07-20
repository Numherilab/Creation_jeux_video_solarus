local enemy = ...

-- Red duck soldier.

require("enemies/scrypts/dx/generic_soldier")(enemy)
enemy:set_properties({
  main_sprite = "enemies/monstre_classique/red_duck_soldier",
  sword_sprite = "enemies/armes_enemies/red_duck_soldier_sword",
  life = 8,
  damage = 12,
  hurt_style = "monster",
  play_hero_seen_sound = true
})

