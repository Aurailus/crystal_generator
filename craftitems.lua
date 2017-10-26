-- Fragments
minetest.register_craftitem("crystal_generator:fragment_crystal", {
	description = "Glow Crystal Fragment",
	inventory_image = "crystal_fragment_3.png",
	groups = {fragment_crystal = 1}
})
minetest.register_craftitem("crystal_generator:fragment_emerald", {
	description = "Glow Emerald Fragment",
	inventory_image = "crystal_fragment_2.png",
	groups = {fragment_crystal = 1}
})
minetest.register_craftitem("crystal_generator:fragment_amethyst", {
	description = "Glow Amethyst Fragment",
	inventory_image = "crystal_fragment_4.png",
	groups = {fragment_crystal = 1},
	stack_max = 999
})
minetest.register_craftitem("crystal_generator:fragment_mese", {
	description = "Glow Mese Fragment",
	inventory_image = "crystal_fragment_1.png",
	groups = {fragment_crystal = 1},
	stack_max = 999
})
minetest.register_craftitem("crystal_generator:fragment_ruby", {
	description = "Glow Ruby Fragment",
	inventory_image = "crystal_fragment_0.png",
	groups = {fragment_crystal = 1},
	stack_max = 999
})