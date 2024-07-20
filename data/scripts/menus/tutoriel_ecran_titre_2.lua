local image_ecran_titre = sol.surface.create("images_tuto/ecran_titre.png")
local menu = {}
local text_1 = sol.text_surface.create({
 text_key = "ecran_titre.04",
 horizontal_alignment = "center",
 font = "enter_command",
 font_size = "40",
})


function menu:on_draw(dst_surface)
image_ecran_titre:draw(dst_surface, 0, 0)
text_1:draw(dst_surface, 110, 30)
end



function menu:on_key_pressed(key)
  if key == "space" then
  sol.audio.play_sound("frost1")
  sol.menu.stop(menu)
      return true  
  end
end

return menu
 