-- Initializes enemy helper functions.

local enemy_meta = sol.main.get_metatable("enemy")

-- Helper function to inflict an explicit reaction from a scripted weapon.
function enemy_meta:receive_attack_consequence(attack, reaction)

  if type(reaction) == "number" then
    self:hurt(reaction)
  elseif reaction == "immobilized" then
    self:immobilize()
  elseif reaction == "protected" then
    sol.audio.play_sound("sword_tapping")
  elseif reaction == "custom" then
    if self.on_custom_attack_received ~= nil then
      self:on_custom_attack_received(attack)
    end
  end

end

function enemy_meta:is_on_screen()
  local enemy = self
  local map = enemy:get_map()
  local camera = map:get_camera()
  local camx, camy = camera:get_position()
  local camwi, camhi = camera:get_size()
  local enemyx, enemyy = enemy:get_position()

  local on_screen = enemyx >= camx and enemyx <= (camx + camwi) and enemyy >= camy and enemyy <= (camy + camhi)
  return on_screen
end