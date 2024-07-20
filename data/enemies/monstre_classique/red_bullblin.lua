local enemy = ...

-- Red Bullblin.

require("enemies/scrypts/dx/generic_soldier")(enemy)
enemy:set_properties({
  main_sprite = "enemies/monstre_classique/red_bullblin",
  sword_sprite = "enemies/armes_enemies/red_bullblin_sword",
  life = 4,
  damage = 4,
  play_hero_seen_sound = false,
  normal_speed = 32,
  faster_speed = 48,
})

