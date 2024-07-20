function sensor_miniboss:on_activated()
  if boss ~= nil then
   
    boss:set_enabled(true)
    sol.audio.play_music("boss")
  end
end

if boss ~= nil then
  function boss:on_dead()
   
    sol.audio.play_sound("boss_killed")

  end
end