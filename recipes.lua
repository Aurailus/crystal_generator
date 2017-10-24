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
    output = "crystal_generator:machine" .. " 1",
    recipe = {
      {"default:steel_ingot", "technic:lv_cable", "default:steel_ingot"},
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