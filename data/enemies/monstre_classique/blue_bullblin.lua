local enemy = ...

-- Blue Bullblin

require("enemies/scrypts/dx/generic_soldier")(enemy)
enemy:set_properties({
  main_sprite = "enemies/monstre_classique/blue_bullblin",
  sword_sprite = "enemies/monstre_classique/blue_bullblin_sword",
  life = 3,
  damage = 2,
  play_hero_seen_sound = false,
  normal_speed = 32,
  faster_speed = 48,
})

