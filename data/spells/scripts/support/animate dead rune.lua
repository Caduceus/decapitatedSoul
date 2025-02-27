function onCastSpell(creature, variant, isHotkey)
	if not creature:isPlayer() then
		return false
	end

	local position = Variant.getPosition(variant)
	local tile = Tile(position)
	if tile and creature:getSkull() ~= SKULL_BLACK then
		local corpse = tile:getTopDownItem()
		if corpse then
			local itemType = corpse:getType()
			if itemType:isCorpse() and itemType:isMovable() then
				local monster = Game.createMonster("Skeleton", position)
				if monster then
					corpse:remove()
					monster:setMaster(creature)
					local hp = monster:getMaster():getMaxHealth()
					 local outfit = monster:getMaster():getOutfit()
					 local speed = monster:getMaster():getBaseSpeed()
						if hp > monster:getMaxHealth() then
							monster:setMaxHealth(hp)
							monster:addHealth(hp)
							monster:changeSpeed(speed)
							position:sendMagicEffect(CONST_ME_MAGIC_BLUE)
						end
					return true
				end
			end
		end
	end

	creature:getPosition():sendMagicEffect(CONST_ME_POFF)
	creature:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
	return false
end
