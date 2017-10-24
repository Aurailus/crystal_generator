minetest.register_abm {
	label = "crystalgenerator power output",
	nodenames = {"crystal_generator:machine_active"},
	interval = 1,
	chance = 1,
	catch_up = false,
	action = function(pos, node)
		local meta = minetest.get_meta(pos)

		meta:set_int("generating", math.random(1, 100))

		local meta = minetest.get_meta(pos)
		local c = 0 
		local e = 0
		local m = 0
		local r = 0
		local a = 0

		for x = meta:get_int("xmin") + 1, meta:get_int("xmax") - 1 do
			for z = meta:get_int("zmin") + 1, meta:get_int("zmax") - 1 do
				for y = pos.y, pos.y + 10 do
					node = minetest.get_node(vector.new(x, y, z)).name

					if node == "caverealms:glow_crystal"  then c = c + 1 end
					if node == "caverealms:glow_emerald"  then e = e + 1 end
					if node == "caverealms:glow_mese"     then m = m + 1 end
					if node == "caverealms:glow_ruby"     then r = r + 1 end
					if node == "caverealms:glow_amethyst" then a = a + 1 end
				end
			end
		end

		local div = 0
		if c > 0 then div = div + 1 end
		if e > 0 then div = div + 1 end
		if m > 0 then div = div + 1 end
		if r > 0 then div = div + 1 end
		if a > 0 then div = div + 1 end

		power = (c + e + m + r + a) * 3
		if div > 0 then power = power / div end
		power = power - (power/10) + (math.random()*(power/5))

		meta:set_int("generating", power)

		-- minetest.chat_send_all("Quantities: " .. c .. ", " .. e .. ", " .. m .. ", " .. r .. ", " .. a)

		meta:set_string("infotext", "Crystal Generator Active\n" ..
		"Generating " .. tostring(meta:get_int("generating")) .. " EU. \n" ..
		"Bounds: " .. tostring(meta:get_int("xmin")) .. ", "
							 .. tostring(meta:get_int("xmax")) .. " to " 
							 .. tostring(meta:get_int("zmin")) .. ", " 
							 .. tostring(meta:get_int("zmax")) .. "\n" ..
		"ID: " .. meta:get_string("id"))
	end
}