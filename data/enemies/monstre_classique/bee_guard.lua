local enemy = ...

-- Bee Guard

require("enemies/scrypts/dx/generic_soldier")(enemy)
enemy:set_properties({
  main_sprite = "enemies/monstre_classique/bee_guard",
  sword_sprite = "enemies/monstre_classique/bee_guard_sword",
  life = 3,
  damage = 2,
  play_hero_seen_sound = true,
  normal_speed = 32,
  faster_speed = 64,
  hurt_style = "monster"
})

