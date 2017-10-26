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
		minetest.chat_send_player(placer:get_player_name(),
			crystal_generator.check_gen_setup(pos))
	end,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		minetest.chat_send_player(placer:get_player_name(),
			crystal_generator.check_gen_setup(pos))
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
		crystal_generator.toggle_gen_state(pos)
	end,
	technic_run = function() 
		--This has to be here for switching stations to
		--detect inactive generators on world start.
	end,
	groups = {cracky = 1, not_in_creative_inventory = 1},
	drop = "crystal_generator:machine"
})

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
		crystal_generator.toggle_gen_state(pos)
	end,
	technic_run = function(pos)
		crystal_generator.generator_process(pos)
	end,
	groups = {cracky = 1, not_in_creative_inventory = 1},
	drop = "crystal_generator:machine"
})

technic.register_machine("MV", "crystal_generator:machine_active", technic.producer)
technic.register_machine("MV", "crystal_generator:machine_inactive", technic.producer)

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
		crystal_generator.gen_frame_destroyed(pos)
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
	sounds = default.node_sound_glass_defaults()
})

minetest.register_node("crystal_generator:depleted_crystal", {
	description = "Depleted Crystal\nSeemingly out of energy,\nbut maybe it can be restored?",
	tiles = {
		"crystal_generator_depleted_crystal.png"
	},
	is_ground_content = true,
	groups = {cracky=3},
	sounds = default.node_sound_glass_defaults(),
	light_source = 6,
	paramtype = "light",
	use_texture_alpha = true,
	drawtype = "glasslike",
	sunlight_propagates = true,
})

minetest.register_node("crystal_generator:broken_crystal", {
	description = "Shattered Glow Crystal",
	tiles = {
		"crystal_generator_broken_crystal.png"
	},
	is_ground_content = true,
	groups = {cracky=3},
	sounds = default.node_sound_glass_defaults(),
	light_source = 6,
	paramtype = "light",
	use_texture_alpha = true,
	drawtype = "glasslike",
	sunlight_propagates = true,
})

minetest.register_node("crystal_generator:broken_emerald", {
	description = "Shattered Glow Emerald",
	tiles = {
		"crystal_generator_broken_emerald.png"
	},
	is_ground_content = true,
	groups = {cracky=3},
	sounds = default.node_sound_glass_defaults(),
	light_source = 6,
	paramtype = "light",
	use_texture_alpha = true,
	drawtype = "glasslike",
	sunlight_propagates = true,
})

minetest.register_node("crystal_generator:broken_amethyst", {
	description = "Shattered Glow Amethyst",
	tiles = {
		"crystal_generator_broken_amethyst.png"
	},
	is_ground_content = true,
	groups = {cracky=3},
	sounds = default.node_sound_glass_defaults(),
	light_source = 6,
	paramtype = "light",
	use_texture_alpha = true,
	drawtype = "glasslike",
	sunlight_propagates = true,
})

minetest.register_node("crystal_generator:broken_mese", {
	description = "Shattered Glow Mese",
	tiles = {
		"crystal_generator_broken_mese.png"
	},
	is_ground_content = true,
	groups = {cracky=3},
	sounds = default.node_sound_glass_defaults(),
	light_source = 6,
	paramtype = "light",
	use_texture_alpha = true,
	drawtype = "glasslike",
	sunlight_propagates = true,
})

minetest.register_node("crystal_generator:broken_ruby", {
	description = "Shattered Glow Ruby",
	tiles = {
		"crystal_generator_broken_ruby.png"
	},
	is_ground_content = true,
	groups = {cracky=3},
	sounds = default.node_sound_glass_defaults(),
	light_source = 6,
	paramtype = "light",
	use_texture_alpha = true,
	drawtype = "glasslike",
	sunlight_propagates = true,
})

dofile(minetest.get_modpath("crystal_generator") .. "/override_drops.lua")