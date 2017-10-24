function crystal_generator_check_setup (pos, placer)
	local player = placer:get_player_name()
	local xmin, xmax, zmin, zmax
	local sizeX, sizeZ

	-- Check for any frames
	if minetest.get_node(vector.new(pos.x-1, pos.y, pos.z)).name == "crystal_generator:frame" then
		local size = 0
		local equal = true

		xmax = pos.x - 1

		-- Check for front row of frames
		while minetest.get_node(vector.new(pos.x-1, pos.y, pos.z + size)).name == "crystal_generator:frame" do
			if minetest.get_node(vector.new(pos.x-1, pos.y, pos.z - size)).name == "crystal_generator:frame" then --Check for symmetry
				equal = true
				size = size + 1
			else
				equal = false
				break
			end
		end
		if minetest.get_node(vector.new(pos.x-1, pos.y, pos.z - size)).name == "crystal_generator:frame" then equal = false end
		if equal then
			zmin = pos.z - size
			zmax = pos.z + size

			sizeZ = size

			equal = true --Reset check vals
			size = 0

			-- Check for side rows
			while minetest.get_node(vector.new(pos.x - 2 - size, pos.y, zmin)).name == "crystal_generator:frame" do
				if minetest.get_node(vector.new(pos.x - 2 - size, pos.y, zmax)).name == "crystal_generator:frame" then --Check for symmetry
					equal = true
					size = size + 1
				else
					equal = false
					break
				end
			end
			if minetest.get_node(vector.new(pos.x - 2 - size, pos.y, zmax)).name == "crystal_generator:frame" then equal = false end

			if equal then
				sizeX = size
				xmin = pos.x - 2 - sizeX

				equal = true
				for i = zmin + 1, zmax - 1 do
					if minetest.get_node(vector.new(xmin, pos.y, i)).name ~= "crystal_generator:frame" then
						equal = false
					end
				end

				if equal then
					local genIndex = os.time()
					math.randomseed(genIndex)
					local genIndex = tostring(os.time()) .. tostring(math.random(0, 9999))

					local encased = 1
					local top = 0
					for i = 1, 10 do
						if minetest.get_node(vector.new(xmin+1, pos.y + i, zmin)).name == "crystal_generator:glass" then
							top = i
						end
					end

					if top ~= 0 then
						for x = xmin + 1, xmax - 1 do
							for z = zmin + 1, zmax - 1 do
								if minetest.get_node(vector.new(x, pos.y + top + 1, z)).name ~= "crystal_generator:glass" then
									encased = 0
									break
								end
							end
							if encased == 0 then break end
						end

						for x = xmin + 1, xmax - 1 do
							for y = 1, top do
								if minetest.get_node(vector.new(x, pos.y + y, zmin)).name ~= "crystal_generator:glass" then
									encased = 0
									break
								end
								if minetest.get_node(vector.new(x, pos.y + y, zmax)).name ~= "crystal_generator:glass" then
									encased = 0
									break
								end
							end
							if encased == 0 then break end
						end

						for z = zmin + 1, zmax - 1 do
							for y = 1, top do
								if minetest.get_node(vector.new(xmin, pos.y + y, z)).name ~= "crystal_generator:glass" then
									encased = 0
									break
								end
								if minetest.get_node(vector.new(xmax, pos.y + y, z)).name ~= "crystal_generator:glass" then
									encased = 0
									break
								end
							end
							if encased == 0 then break end
						end
					else
						encased = 0
					end

					for i = zmin + 1, zmax - 1 do
						minetest.get_meta(vector.new(xmin, pos.y, i)):set_string("genIndex", genIndex);
						minetest.get_meta(vector.new(xmin, pos.y, i)):set_int("genX", pos.x);
						minetest.get_meta(vector.new(xmin, pos.y, i)):set_int("genY", pos.y);
						minetest.get_meta(vector.new(xmin, pos.y, i)):set_int("genZ", pos.z);

						minetest.get_meta(vector.new(xmax, pos.y, i)):set_string("genIndex", genIndex);
						minetest.get_meta(vector.new(xmax, pos.y, i)):set_int("genX", pos.x);
						minetest.get_meta(vector.new(xmax, pos.y, i)):set_int("genY", pos.y);
						minetest.get_meta(vector.new(xmax, pos.y, i)):set_int("genZ", pos.z);
					end
					for i = xmin + 1, xmax - 1 do
						minetest.get_meta(vector.new(i, pos.y, zmin)):set_string("genIndex", genIndex);
						minetest.get_meta(vector.new(i, pos.y, zmin)):set_int("genX", pos.x);
						minetest.get_meta(vector.new(i, pos.y, zmin)):set_int("genY", pos.y);
						minetest.get_meta(vector.new(i, pos.y, zmin)):set_int("genZ", pos.z);

						minetest.get_meta(vector.new(i, pos.y, zmax)):set_string("genIndex", genIndex);
						minetest.get_meta(vector.new(i, pos.y, zmax)):set_int("genX", pos.x);
						minetest.get_meta(vector.new(i, pos.y, zmax)):set_int("genY", pos.y);
						minetest.get_meta(vector.new(i, pos.y, zmax)):set_int("genZ", pos.z);
					end

					minetest.chat_send_player(player, "Generator set up successfully.");

					local meta = minetest.get_meta(pos)

					meta:set_int("encased", encased)
					if encased ~= 0 then 
						meta:set_int("top", top)
					end
					
					meta:set_int("xmin", xmin)
					meta:set_int("xmax", xmax)
					meta:set_int("zmin", zmin)
					meta:set_int("zmax", zmax)

					meta:set_int("active", 0)
					meta:set_string("id", genIndex)

					meta:set_string("infotext", "Crystal Generator Inactive\n" ..
						"Generating 0 EU. \n" ..
						"Bounds: " .. tostring(meta:get_int("xmin")) .. ", "
											 .. tostring(meta:get_int("xmax")) .. " to " 
											 .. tostring(meta:get_int("zmin")) .. ", " 
											 .. tostring(meta:get_int("zmax")) .. "\n" ..
						"ID: " .. meta:get_string("id"))

					minetest.swap_node(pos, {name = "crystal_generator:machine_inactive"})
				else
					minetest.chat_send_player(player, "Frames must form a cornerless rectangle!")
				end
			else
				minetest.chat_send_player(player, "Frames must form a cornerless rectangle!")
			end
		else
			minetest.chat_send_player(player, "Generator must be centered!")
		end
	else
		minetest.chat_send_player(player, "No Frame Structure Detected!")
	end
end