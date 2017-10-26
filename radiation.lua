local time = 0
minetest.register_globalstep(function(dtime)
   time = time + dtime
   if time > 2 then

      time = 0

      for _,player in ipairs(minetest.get_connected_players()) do
         
         local pos = player:getpos()
         local near = minetest.find_node_near(pos, 20, "crystal_generator:machine_active")

         if near then
            local meta = minetest.get_meta(near)

            if meta:get_int("casetop") == 0 
            and meta:get_int("active") == 2 
            and meta:get_int("MV_EU_supply") > 0
            and player:get_hp() > 0 then
               player:set_hp(player:get_hp()-1)
            end
         end
      end
   end
end)