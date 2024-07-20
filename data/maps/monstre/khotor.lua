local map = ...
local game = map:get_game()

function map:on_started(destination)
  -- Désactiver le miniboss à l'initialisation de la carte.
  if miniboss ~= nil then
    miniboss:set_enabled(false)
  end

  -- Démarrer immédiatement la bataille du miniboss
  if miniboss ~= nil then
    miniboss:set_enabled(true)
  end
end

