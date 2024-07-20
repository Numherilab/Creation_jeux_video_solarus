local enemy = ...

-- Blue duck soldier

require("enemies/scrypts/dx/generic_soldier")(enemy)
enemy:set_properties({
  main_sprite = "enemies/monstre_classique/blue_duck_soldier",
  sword_sprite = "enemies/monstre_classique/blue_duck_soldier_sword",
  life = 5,
  damage = 10,
  hurt_style = "monster",
  play_hero_seen_sound = true
})

