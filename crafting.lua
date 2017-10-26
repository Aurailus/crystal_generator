-- Generator Frames
minetest.register_craft({
    output = "crystal_generator:frame" .. " 8",
    recipe = {
      {"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
      {"technic:cast_iron_ingot", "technic:cast_iron_ingot", "technic:cast_iron_ingot"},
      {"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"}
    }
})

-- Generator Block
minetest.register_craft({
    output = "crystal_generator:machine",
    recipe = {
      {"default:steel_ingot", "technic:mv_cable", "default:steel_ingot"},
      {"technic:cast_iron_ingot", "default:mese", "technic:cast_iron_ingot"},
      {"default:steel_ingot", "technic:chromium_block", "default:steel_ingot"}
    }
})

-- Protective Glass
minetest.register_craft({
    output = "crystal_generator:glass" .. " 32",
    recipe = {
      {"default:glass", "default:glass", "default:glass"},
      {"default:glass", "default:obsidian_shard", "default:glass"},
      {"default:glass", "default:glass", "default:glass"}
    }
})

-- Broken Crystal Repair
minetest.register_craft({
	output = "caverealms:glow_crystal",
	recipe = {
		{"crystal_generator:broken_crystal", "default:mese_crystal_fragment"}, 
		{"default:mese_crystal_fragment", "crystal_generator:broken_crystal"}
	}
})
minetest.register_craft({
	output = "caverealms:glow_emerald",
	recipe = {
		{"crystal_generator:broken_emerald", "default:mese_crystal_fragment"},
		{"default:mese_crystal_fragment", "crystal_generator:broken_emerald"}
	}
})
minetest.register_craft({
	output = "caverealms:glow_amethyst",
	recipe = {
		{"crystal_generator:broken_amethyst", "default:mese_crystal_fragment"},
		{"default:mese_crystal_fragment", "crystal_generator:broken_amethyst"}
	}
})
minetest.register_craft({
	output = "caverealms:glow_mese",
	recipe = {
		{"crystal_generator:broken_mese", "default:mese_crystal_fragment"},
		{"default:mese_crystal_fragment", "crystal_generator:broken_mese"}
	}
})
minetest.register_craft({
	output = "caverealms:glow_ruby",
	recipe = {
		{"crystal_generator:broken_ruby", "default:mese_crystal_fragment"},
		{"default:mese_crystal_fragment", "crystal_generator:broken_ruby"}
	}
})

-- Broken Crystal Crafting
minetest.register_craft({
	output = "crystal_generator:broken_crystal",
	recipe = {
		{"crystal_generator:fragment_crystal", "crystal_generator:fragment_crystal"},
		{"crystal_generator:fragment_crystal", "crystal_generator:fragment_crystal"}
	}
})
minetest.register_craft({
	output = "crystal_generator:broken_emerald",
	recipe = {
		{"crystal_generator:fragment_emerald", "crystal_generator:fragment_emerald"},
		{"crystal_generator:fragment_emerald", "crystal_generator:fragment_emerald"}
	}
})
minetest.register_craft({
	output = "crystal_generator:broken_amethyst",
	recipe = {
		{"crystal_generator:fragment_amethyst", "crystal_generator:fragment_amethyst"},
		{"crystal_generator:fragment_amethyst", "crystal_generator:fragment_amethyst"}
	}
})
minetest.register_craft({
	output = "crystal_generator:broken_mese",
	recipe = {
		{"crystal_generator:fragment_mese", "crystal_generator:fragment_mese"},
		{"crystal_generator:fragment_mese", "crystal_generator:fragment_mese"}
	}
})
minetest.register_craft({
	output = "crystal_generator:broken_ruby",
	recipe = {
		{"crystal_generator:fragment_ruby", "crystal_generator:fragment_ruby"},
		{"crystal_generator:fragment_ruby", "crystal_generator:fragment_ruby"}
	}
})