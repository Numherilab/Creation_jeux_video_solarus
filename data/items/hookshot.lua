local item = ...

function item:on_created()

  self:set_savegame_variable("i1105")
  self:set_assignable(true)
end

function item:on_using()
  self:get_map():get_entity("hero"):start_hookshot()
  self:set_finished()
end

function item:on_obtained(variant, savegame_variable) 
  local game = self:get_game()
  game:start_dialog("grappin")
end
