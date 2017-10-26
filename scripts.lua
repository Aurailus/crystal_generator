
--------
--Info--
--------
function crystal_generator.set_gen_info(pos)
	local meta = minetest.get_meta(pos)

	local activeString = "Idle"
	local active = meta:get_int("active")

	if active == 1 then activeString = "Has No Network" end
	if active == 2 then activeString = "Active" end

	local metaString = "Crystal MV Generator " .. activeString;
	if active == 2 then
		metaString = metaString .. " (" .. tostring(meta:get_int("MV_EU_supply")) .. " EU for " .. tostring(meta:get_int("time_left")) .. "s)"
	end

	metaString = metaString .. "\nBounds: " .. tostring(meta:get_int("xmin")) .. ", "
							 						.. tostring(meta:get_int("xmax")) .. " to " 
							 						.. tostring(meta:get_int("zmin")) .. ", " 
							 						.. tostring(meta:get_int("zmax"))

	if meta:get_int("casetop") == 0 then
		metaString = metaString .. "\nThis generator is not encased and is leaking radiation!"
	end

	meta:set_string("infotext", metaString)
end

----------------
--Toggle State--
----------------
function crystal_generator.toggle_gen_state(pos)
	local meta = minetest.get_meta(pos)

	if meta:get_int("active") > 0 then
		meta:set_int("active", 0)
		meta:set_int("MV_EU_supply", 0)
		meta:set_int("time_left", 0)
		minetest.swap_node(pos, {name = "crystal_generator:machine_inactive"})
	else
		meta:set_int("active", 1)
		minetest.swap_node(pos, {name = "crystal_generator:machine_active"})

		local top = crystal_generator.check_glass(pos, {xmin = meta:get_int("xmin"), 
																									zmin = meta:get_int("zmin"), 
																									xmax = meta:get_int("xmax"), 
																									zmax = meta:get_int("zmax")})

		meta:set_int("casetop", top)
	end
	crystal_generator.set_gen_info(pos)
end

---------------
--Check Glass--
---------------
function crystal_generator.check_glass(pos, bounds)
	local top = 0

	for i = 1, 10 do
		if minetest.get_node(vector.new(bounds.xmin+1, pos.y + i, bounds.zmin)).name == "crystal_generator:glass" then
			top = i
		end
	end
	-- No Glass at origin check
	if top == 0 then return 0 end

	for x = bounds.xmin + 1, bounds.xmax - 1 do
		for z = bounds.zmin + 1, bounds.zmax - 1 do
			if minetest.get_node(vector.new(x, pos.y + top + 1, z)).name ~= "crystal_generator:glass" then
				-- No Glass at top
				return 0
			end
		end
	end

	for x = bounds.xmin + 1, bounds.xmax - 1 do
		for y = 1, top do
			if minetest.get_node(vector.new(x, pos.y + y, bounds.zmin)).name ~= "crystal_generator:glass" then
				--No glass on z sides
				return 0
			end
			if minetest.get_node(vector.new(x, pos.y + y, bounds.zmax)).name ~= "crystal_generator:glass" then
				--No glass on z 
				return 0
			end
		end
	end

	for z = bounds.zmin + 1, bounds.zmax - 1 do
		for y = 1, top do
			if minetest.get_node(vector.new(bounds.xmin, pos.y + y, z)).name ~= "crystal_generator:glass" then
				--No glass on x sides
				return 0
			end
			if minetest.get_node(vector.new(bounds.xmax, pos.y + y, z)).name ~= "crystal_generator:glass" then
				--No glass on x sides
				return 0
			end
		end
	end

	-- All good
	return top
end

---------
--Setup--
---------
function crystal_generator.check_gen_setup(pos)

	if minetest.get_node(vector.new(pos.x-1, pos.y, pos.z)).name ~= "crystal_generator:frame" then
		--No frame behind generator
		return "Generator requires a frame!"
	end

	--Initialize Variables
	local xmin, xmax, zmin, zmax
	local sizeX, sizeZ
	local size = 0
	local equal = true

	xmax = pos.x - 1

	--Check front row for symmetry
	while minetest.get_node(vector.new(pos.x-1, pos.y, pos.z + size)).name == "crystal_generator:frame" do
		if minetest.get_node(vector.new(pos.x-1, pos.y, pos.z - size)).name == "crystal_generator:frame" then
			size = size + 1
		else
			--Not symmetrical Z
			return "Generator must be centered!"
		end
	end
	if minetest.get_node(vector.new(pos.x-1, pos.y, pos.z - size)).name == "crystal_generator:frame" then 
		--Not symmetrical Z
		return "Generator must be centered!"
	end

	zmin = pos.z - size
	zmax = pos.z + size

	sizeZ = size
	size = 0

	-- Check for side rows
	while minetest.get_node(vector.new(pos.x - 2 - size, pos.y, zmin)).name == "crystal_generator:frame" do
		if minetest.get_node(vector.new(pos.x - 2 - size, pos.y, zmax)).name == "crystal_generator:frame" then
			size = size + 1
		else
			--Not symmetrical X
			return "Generator must form a borderless rectangle!"
		end
	end
	if minetest.get_node(vector.new(pos.x - 2 - size, pos.y, zmax)).name == "crystal_generator:frame" then 
		--Not symmetrical X
		return "Generator must form a borderless rectangle!"
	end

	sizeX = size
	xmin = pos.x - 2 - sizeX

	for i = zmin + 1, zmax - 1 do
		if minetest.get_node(vector.new(xmin, pos.y, i)).name ~= "crystal_generator:frame" then
			--Not complete
			return "Generator must form a borderless rectangle!"
		end
	end

	-- Unique Generator Index - Unused

	-- local genIndex = os.time()
	-- math.randomseed(genIndex)
	-- local genIndex = tostring(os.time()) .. tostring(math.random(0, 9999))

	local top = crystal_generator.check_glass(pos, {xmin = xmin, zmin = zmin, xmax = xmax, zmax = zmax})

	--Set frame owner
	for i = zmin + 1, zmax - 1 do
		frame = minetest.get_meta({x = xmin, y = pos.y, z = i})
		frame:set_string("genIndex", genIndex);
		frame:set_int("genX", pos.x);
		frame:set_int("genY", pos.y);
		frame:set_int("genZ", pos.z);

		frame = minetest.get_meta({x = xmax, y = pos.y, z = i})
		frame:set_string("genIndex", genIndex);
		frame:set_int("genX", pos.x);
		frame:set_int("genY", pos.y);
		frame:set_int("genZ", pos.z);
	end
	for i = xmin + 1, xmax - 1 do
		frame = minetest.get_meta({x = i, y = pos.y, z = zmin})
		frame:set_string("genIndex", genIndex);
		frame:set_int("genX", pos.x);
		frame:set_int("genY", pos.y);
		frame:set_int("genZ", pos.z);

		frame = minetest.get_meta({x = i, y = pos.y, z = zmax})
		frame:set_string("genIndex", genIndex);
		frame:set_int("genX", pos.x);
		frame:set_int("genY", pos.y);
		frame:set_int("genZ", pos.z);
	end

	local meta = minetest.get_meta(pos)

	meta:set_int("casetop", top)
	
	meta:set_int("xmin", xmin)
	meta:set_int("xmax", xmax)
	meta:set_int("zmin", zmin)
	meta:set_int("zmax", zmax)

	meta:set_int("active", 0)
	meta:set_string("genIndex", genIndex)

	minetest.swap_node(pos, {name = "crystal_generator:machine_inactive"})
	crystal_generator.set_gen_info(pos)
	return "Generator set up successfully."
end

---------------------
--Generator Process--
---------------------
function crystal_generator.generator_process(pos)
	local meta = minetest.get_meta(pos)

	-- Check Casing
	meta:set_int("casetop", crystal_generator.check_glass(pos, 
		{xmin = meta:get_int("xmin"), 
		zmin = meta:get_int("zmin"), 
		xmax = meta:get_int("xmax"), 
		zmax = meta:get_int("zmax")}))

	meta:set_int("active", 2)

	local top = meta:get_int("casetop")
	local encased = true
	if top == 0 then
		encased = false
		top = 8 
	end

	--Spawn crystal particles
	for y = pos.y + top, pos.y, - 1 do
		for z = meta:get_int("zmin") + 1, meta:get_int("zmax") - 1 do
			for x = meta:get_int("xmin") + 1, meta:get_int("xmax") - 1 do

				node = minetest.get_node(vector.new(x, y, z)).name

				if encased then
					if node == "air" and math.random(0, 7) == 0 then
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
				else
					if node == "air" and math.random(0, 5) == 0 then
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

	if meta:get_int("time_left") and meta:get_int("time_left") > 0 then
		 meta:set_int("time_left", meta:get_int("time_left") - 1)
	else
		--Scan for new crystal
		power = (function() 
			local base_power = 200
			if not encased then base_power = base_power * 0.7 end
			local depleted = false

			for y = pos.y + top, pos.y, -1 do
				for z = meta:get_int("zmin") + 1, meta:get_int("zmax") - 1 do
					for x = meta:get_int("xmin") + 1, meta:get_int("xmax") - 1 do

						node = minetest.get_node(vector.new(x, y, z)).name

						if node == "caverealms:glow_crystal" or node == "caverealms:glow_emerald" or
							 node == "caverealms:glow_mese"		 or node == "caverealms:glow_ruby" or
							 node == "caverealms:glow_amethyst" then

							if not depleted then
								minetest.swap_node(vector.new(x, y, z), {name = "crystal_generator:depleted_crystal"})
								depleted = true
							else
								if node == "caverealms:glow_crystal"  then return base_power * 1.0 end
								if node == "caverealms:glow_emerald"  then return base_power * 1.2 end
								if node == "caverealms:glow_mese"     then return base_power * 2.5 end
								if node == "caverealms:glow_ruby"     then return base_power * 2.0 end
								if node == "caverealms:glow_amethyst" then return base_power * 1.5 end
							end

						end
					end
				end
			end
			return 0
		end)()

		if power > 0 then
			meta:set_int("MV_EU_supply", power)
			meta:set_int("time_left", 150)
		else
			meta:set_int("active", 0)
			meta:set_int("MV_EU_supply", 0)
			meta:set_int("time_left", 0)
			crystal_generator.set_gen_info(pos)
			minetest.swap_node(pos, {name = "crystal_generator:machine_inactive"})
		end
	end

	crystal_generator.set_gen_info(pos)
end

---------------------
--Frame Destruction--
---------------------
function crystal_generator.gen_frame_destroyed(pos)
	local meta = minetest.get_meta(pos)
	if meta:get_int("genX") ~= 0 or meta:get_int("genY") ~= 0 or meta:get_int("genZ") ~= 0 then

		local genPos = vector.new(meta:get_int("genX"), meta:get_int("genY"), meta:get_int("genZ"))
		local generator = minetest.get_node(genPos)

		if generator.name == "crystal_generator:machine_inactive" or generator.name == "crystal_generator:machine_active" then
			-- Disable the generator because a frame has been broken
			minetest.swap_node(genPos, {name = "crystal_generator:machine"})
		end
	end
end