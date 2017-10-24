function crystal_generator_toggle_state (pos, player)
	local activeString
	local meta = minetest.get_meta(pos)

	if meta:get_int("active") == 1 then
		meta:set_int("active", 0)
		meta:set_int("generating", 0)
		activeString = "Inactive"
		minetest.swap_node(pos, {name = "crystal_generator:machine_inactive"})
	else
		meta:set_int("active", 1)
		activeString = "Active"
		minetest.swap_node(pos, {name = "crystal_generator:machine_active"})

		local encased = 1
		local top = 0

		local xmin = meta:get_int("xmin")
		local xmax = meta:get_int("xmax")
		local zmin = meta:get_int("zmin")
		local zmax = meta:get_int("zmax")

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
		
		minetest.chat_send_all(tostring(encased))
		meta:set_int("encased", encased)
	end


	meta:set_string("infotext", "Crystal Generator " .. activeString .. "\n" ..
		"Generating " .. tostring(meta:get_int("generating")) .. " EU. \n" ..
		"Bounds: " .. tostring(meta:get_int("xmin")) .. ", "
							 .. tostring(meta:get_int("xmax")) .. " to " 
							 .. tostring(meta:get_int("zmin")) .. ", " 
							 .. tostring(meta:get_int("zmax")) .. "\n" ..
		"ID: " .. meta:get_string("id"))
end