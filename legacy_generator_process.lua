function crystal_generator.generator_process(pos)
	local meta = minetest.get_meta(pos)

	-- Check Casing
	meta:set_int("casetop", crystal_generator.check_glass(pos, 
		{xmin = meta:get_int("xmin"), 
		zmin = meta:get_int("zmin"), 
		xmax = meta:get_int("xmax"), 
		zmax = meta:get_int("zmax")}))

	local c = 0 
	local e = 0
	local m = 0
	local r = 0
	local a = 0

	local top = meta:get_int("casetop")
	if top == 0 then top = 11 end
	meta:set_int("active", 2)

	for y = pos.y, pos.y + top do
		for x = meta:get_int("xmin") + 1, meta:get_int("xmax") - 1 do
			for z = meta:get_int("zmin") + 1, meta:get_int("zmax") - 1 do
				local is_crystal = false
				node = minetest.get_node(vector.new(x, y, z)).name

				if node == "caverealms:glow_crystal"  then c = c + 1; is_crystal = true end
				if node == "caverealms:glow_emerald"  then e = e + 1; is_crystal = true end
				if node == "caverealms:glow_mese"     then m = m + 1; is_crystal = true end
				if node == "caverealms:glow_ruby"     then r = r + 1; is_crystal = true end
				if node == "caverealms:glow_amethyst" then a = a + 1; is_crystal = true end

				-- Node decay
				if is_crystal then
					if math.random(0, 500) == 0 then
						minetest.swap_node(vector.new(x, y, z), {name = "crystal_generator:depleted_crystal"})
					end
				end

				-- Encased
				if top ~= 11 then
					if node == "air" then
						if math.random(0, 7) == 0 and node == "air" then
							minetest.add_particle({
								pos = {x = x, y = y, z = z},
								velocity = {x = (math.random()-0.5)*2, y = (math.random()-0.5)*2, z = (math.random()-0.5)*2},
								acceleration = {x = 0, y = 0, z = 0},
								expirationtime = 3,
								size = 1,
								collisiondetection = true,
								vertical = false,
								texture = "caverealms_glow_crystal.png"
							})
						end
					end
				else
					if node == "air" then
						if math.random(0, 5) == 0 and node == "air" then
							minetest.add_particle({
								pos = {x = x, y = y, z = z},
								velocity = {x = (math.random()-0.5)*4, y = (math.random()-0.5)*4, z = (math.random()-0.5)*4},
								acceleration = {x = 0, y = 0, z = 0},
								expirationtime = 3,
								size = 2,
								collisiondetection = false,
								vertical = false,
								texture = "caverealms_glow_crystal.png"
							})
						end
					end
				end
			end
		end
	end

	local div = 0
	if c > 0 then div = div + 1 end
	if e > 0 then div = div + 1 end
	if m > 0 then div = div + 1 end
	if r > 0 then div = div + 1 end
	if a > 0 then div = div + 1 end

	local casemultiplier = 0.7
	if top ~= 11 then casemultiplier = 1 end

	power = (c * 0.8 + e * 1 + m * 2.5 + r * 2 + a * 1.2) * 6 * casemultiplier
	if div > 0 then power = power / div end
	power = power - (power/20) + (math.random()*(power/10))

	meta:set_int("MV_EU_supply", power)

	-- minetest.chat_send_all("Quantities: " .. c .. ", " .. e .. ", " .. m .. ", " .. r .. ", " .. a)

	crystal_generator.set_gen_info(pos)
end