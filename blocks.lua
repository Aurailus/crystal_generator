dofile(minetest.get_modpath("crystal_generator") .. "/scripts/check_setup.lua")
dofile(minetest.get_modpath("crystal_generator") .. "/scripts/toggle_state.lua")
dofile(minetest.get_modpath("crystal_generator") .. "/scripts/node_destroyed.lua")

minetest.register_node("crystal_generator:machine", {
	description = "Crystal Generator\nA device to extract radioactive\nenergy from a glow crystal.",
	tiles = {
		"crystal_generator_machine_top.png",
		"crystal_generator_machine_bottom.png",
		"crystal_generator_machine_off.png",
		"crystal_generator_machine_back.png",
		"crystal_generator_machine_side_right.png",
		"crystal_generator_machine_side_left.png"
	},
	on_punch = function(pos, node, placer, pointed_thing)
		crystal_generator_check_setup(pos, placer)
	end,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		crystal_generator_check_setup(pos, placer)
	end,
	groups = {cracky = 1, creative = 1}
})

minetest.register_node("crystal_generator:machine_inactive", {
	description = "Error",
	tiles = {
		"crystal_generator_machine_top.png",
		"crystal_generator_machine_bottom.png",
		"crystal_generator_machine_on.png",
		"crystal_generator_machine_back.png",
		"crystal_generator_machine_side_right.png",
		"crystal_generator_machine_side_left.png"
	},
	on_punch = function(pos, node, placer, pointed_thing)
		crystal_generator_toggle_state(pos, placer)
	end,
	groups = {cracky = 1, creative = 1},
	drop = "crystal_generator:machine"
})

local run = function(pos, node)
	local meta = minetest.get_meta(pos)
	local c = 0 
	local e = 0
	local m = 0
	local r = 0
	local a = 0

	local top = meta:get_int("top")
	if top == 0 then top = 10 end

	for x = meta:get_int("xmin") + 1, meta:get_int("xmax") - 1 do
		for z = meta:get_int("zmin") + 1, meta:get_int("zmax") - 1 do
			for y = pos.y, pos.y + top do
				node = minetest.get_node(vector.new(x, y, z)).name

				if node == "caverealms:glow_crystal"  then c = c + 1 end
				if node == "caverealms:glow_emerald"  then e = e + 1 end
				if node == "caverealms:glow_mese"     then m = m + 1 end
				if node == "caverealms:glow_ruby"     then r = r + 1 end
				if node == "caverealms:glow_amethyst" then a = a + 1 end

				if node == "air" then
					if meta:get_int("encased") == 1 then
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
					else
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

	power = (c * 0.8 + e * 1 + m * 2.5 + r * 2 + a * 1.2) * 6 * math.min(meta:get_int("encased") + 0.7, 1)
	if div > 0 then power = power / div end
	power = power - (power/20) + (math.random()*(power/10))

	meta:set_int("generating", power)
	meta:set_int("LV_EU_supply", power)

	-- minetest.chat_send_all("Quantities: " .. c .. ", " .. e .. ", " .. m .. ", " .. r .. ", " .. a)

	meta:set_string("infotext", "Crystal Generator Active\n" ..
	"Generating " .. tostring(meta:get_int("generating")) .. " EU. \n" ..
	"Bounds: " .. tostring(meta:get_int("xmin")) .. ", "
						 .. tostring(meta:get_int("xmax")) .. " to " 
						 .. tostring(meta:get_int("zmin")) .. ", " 
						 .. tostring(meta:get_int("zmax")))
	if meta:get_int("encased") then
		meta:set_string("infotext", meta:get_string("infotext") .. "\n" ..
			"WARNING: This generator is not enclosed properly. \n It will generate less power and damage players!")
	end
end

minetest.register_node("crystal_generator:machine_active", {
	description = "Error",
	tiles = {
		"crystal_generator_machine_top.png",
		"crystal_generator_machine_bottom.png",
		{name = "crystal_generator_machine_active.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=6}},
		"crystal_generator_machine_back.png",
		"crystal_generator_machine_side_right.png",
		"crystal_generator_machine_side_left.png"
	},
	on_punch = function(pos, node, placer, pointed_thing)
		crystal_generator_toggle_state(pos, placer)
	end,
	technic_run = run,
	groups = {cracky = 1, creative = 1},
	drop = "crystal_generator:machine"
})

technic.register_machine("LV", "crystal_generator:machine_active", technic.producer)

minetest.register_node("crystal_generator:frame", {
	description = "Generator Frame\nUsed to lay out the borders\nof a Crystal Generator.",
	tiles = {
		"crystal_generator_machine_bottom.png",
		"crystal_generator_machine_bottom.png",
		"crystal_generator_border.png",
		"crystal_generator_border.png",
		"crystal_generator_border.png",
		"crystal_generator_border.png"
	},
	on_destruct = function(pos)
		crystal_generator_frame_destroyed(pos)
	end,
	groups = {cracky = 1, creative = 1}
})

minetest.register_node("crystal_generator:glass", {
	description = "Protective Glass\nBlock light and radioactive waves.",
	tiles = {
		"crystal_generator_glass.png"
	},
	drawtype = "glasslike",
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_glass_defaults(),
	drop = ""
})