local time = 0
minetest.register_globalstep(function(dtime)
   time = time + dtime
   if time > 2 then

      time = 0

      for _,player in ipairs(minetest.get_connected_players()) do
         
         local pos = player:getpos()
         
         local near = minetest.find_node_near(pos, 10, "crystal_generator:machine_active")
         if near and minetest.get_meta(near):get_int("encased") == 0 then
            if player:get_hp() > 0 then
               player:set_hp(player:get_hp()-1)
            end
         end
      end
   end
end)