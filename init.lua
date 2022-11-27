local radius = math.max(tonumber(minetest.settings:get("item_magnet.radius")) or 2, 1)

minetest.register_tool("item_magnet:magnet", {
	description = "Item Magnet",
	inventory_image = "item_magnet_magnet.png",
	on_use = function(itemstack, player, pointed_thing)
		if not player or not player:is_player() or player.is_fake_player then
			return
		end
		local pos = player:get_pos()
		local inv = player:get_inventory()
		local stuff_was_picked_up = false
		for _, obj in ipairs(minetest.get_objects_inside_radius(pos, radius)) do
			local ent = obj:get_luaentity()
			if ent and ent.name == "__builtin:item" then
				local item = ItemStack(ent.itemstring)
				if inv:room_for_item("main", item) then
					ent:on_punch(player)
					stuff_was_picked_up = true
				end
			end
		end
		if stuff_was_picked_up then
			itemstack:add_wear(655)
			return itemstack
		end
	end,
})

if minetest.get_modpath("default") then
	minetest.register_craft({
		output = "item_magnet:magnet",
		recipe = {
			{ "default:iron_lump", "", "default:iron_lump" },
			{ "default:iron_lump", "", "default:iron_lump" },
			{ "", "default:iron_lump", "" },
		},
	})
end
