local image_ecran_titre = sol.surface.create("images_tuto/ecran_titre.png")
local menu = {}
local text_1 = sol.text_surface.create({
 text_key = "ecran_titre.01",
 horizontal_alignment = "center",
 font = "enter_command",
 font_size = "40",
})
local text_2 = sol.text_surface.create({
 text_key = "ecran_titre.02",
 horizontal_alignment = "center",
 font = "enter_command",
 font_size = "40",
})
local text_3 = sol.text_surface.create({
 text_key = "ecran_titre.03",
 horizontal_alignment = "center",
 font = "enter_command",
 font_size = "40",
})

function menu:on_draw(dst_surface)
image_ecran_titre:draw(dst_surface, 0, 0)
text_1:draw(dst_surface, 110, 30)
text_2:draw(dst_surface, 110, 90)
text_3:draw(dst_surface, 110, 150)

end

function menu:on_key_pressed(key)
  if key == "space" then
  sol.audio.play_sound("frost1")
  sol.menu.stop(menu)
      return true  
  end
end

return menu
 