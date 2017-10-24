function crystal_generator_frame_destroyed (pos)
	local meta = minetest.get_meta(pos)
	if meta:get_int("genX") ~= 0 and meta:get_int("genY") ~= 0 and meta:get_int("genZ") ~= 0 then
		local genPos = {x = meta:get_int("genX"), y = meta:get_int("genY"), z = meta:get_int("genZ")}
		local generator = minetest.get_node(genPos)

		if generator.name == "crystal_generator:machine_inactive" or generator.name == "crystal_generator:machine_active" then
			-- Disable the generator because a frame has been broken
			minetest.swap_node(genPos, {name = "crystal_generator:machine"})
		end
	end
end