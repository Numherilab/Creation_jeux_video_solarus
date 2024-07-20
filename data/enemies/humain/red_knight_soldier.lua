local enemy = ...

-- Red knight soldier.

require("enemies/scrypts/dx/generic_soldier")(enemy)
enemy:set_properties({
  main_sprite = "enemies/humain/red_knight_soldier",
  sword_sprite = "enemies/armes_enemies/red_knight_soldier_sword",
  life = 4,
  damage = 2,
  play_hero_seen_sound = true
})

