local enemy = ...
local behavior = require("enemies/scrypts/bm/bubble")

-- Bubble: an invincible enemy that moves in diagonal directions
-- and bounces against walls - this one confuses the hero.

local properties = {
  sprite = "enemies/bubble_grey",
}
behavior:create(enemy, properties)

-- Variable pour vérifier si les événements sont déjà enregistrés
local events_registered = false

-- Function to start confusion
local function start_confusion(hero, duration)
  local game = hero:get_game()
  local in_command_pressed = false
  local in_command_release = false

  -- Ne pas démarrer une nouvelle confusion si le héros est déjà confus
  if hero:is_condition_active("confusion") then
    return
  end

  hero:set_condition("confusion", true)

  if not events_registered then
    events_registered = true

    -- Override command pressed and released events
    game:register_event("on_command_pressed", function(game, command)
      if not hero:is_condition_active("confusion") or in_command_pressed or game:is_paused() then
        return false
      end

      if command == "left" then
        game:simulate_command_released("left")
        in_command_pressed = true
        game:simulate_command_pressed("right")
        in_command_pressed = false
        return true
      elseif command == "right" then
        game:simulate_command_released("right")
        in_command_pressed = true
        game:simulate_command_pressed("left")
        in_command_pressed = false
        return true
      elseif command == "up" then
        game:simulate_command_released("up")
        in_command_pressed = true
        game:simulate_command_pressed("down")
        in_command_pressed = false
        return true
      elseif command == "down" then
        game:simulate_command_released("down")
        in_command_pressed = true
        game:simulate_command_pressed("up")
        in_command_pressed = false
        return true
      end
      return false
    end)

    game:register_event("on_command_released", function(game, command)
      if not hero:is_condition_active("confusion") or in_command_release or game:is_paused() then
        return false
      end

      if command == "left" then
        in_command_release = true
        game:simulate_command_released("right")
        in_command_release = false
        return true
      elseif command == "right" then
        in_command_release = true
        game:simulate_command_released("left")
        in_command_release = false
        return true
      elseif command == "up" then
        in_command_release = true
        game:simulate_command_released("down")
        in_command_release = false
        return true
      elseif command == "down" then
        in_command_release = true
        game:simulate_command_released("up")
        in_command_release = false
        return true
      end
      return false
    end)
  end

  -- Stop confusion after the duration
  sol.timer.start(game, duration, function()
    hero:set_condition("confusion", false)

    -- Ensure all directions are released
    local directions = {"left", "right", "up", "down"}
    for _, direction in ipairs(directions) do
      if game:is_command_pressed(direction) then
        game:simulate_command_released(direction)
      end
    end
  end)
end

-- Ensure hero has the set_condition method
local hero_meta = sol.main.get_metatable("hero")

if hero_meta.set_condition == nil then
  function hero_meta:set_condition(condition, active)
    if self.condition == nil then
      self.condition = {}
    end
    self.condition[condition] = active
  end

  function hero_meta:is_condition_active(condition)
    return self.condition and self.condition[condition]
  end
end

function enemy:on_attacking_hero(hero)
  if not hero:is_invincible() then
    start_confusion(hero, 10000)  -- Confuse hero for 10 seconds
    hero:set_invincible(true, 200)
    if self:get_game():get_magic() > 0 then
      self:get_game():remove_magic(2)
      sol.audio.play_sound("magic_bar")
    end
  end
end
