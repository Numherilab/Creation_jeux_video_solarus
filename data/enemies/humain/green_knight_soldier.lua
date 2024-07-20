local enemy = ...

-- Green knight soldier.

require("enemies/scrypts/dx/generic_soldier")(enemy)
enemy:set_properties({
  main_sprite = "enemies/humain/green_knight_soldier",
  sword_sprite = "enemies/armes_enemies/green_knight_soldier_sword",
  life = 2,
  damage = 2,
  play_hero_seen_sound = true
})

