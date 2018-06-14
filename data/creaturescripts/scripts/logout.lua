function onLogout(player)
	player:getPosition():sendMagicEffect(CONST_ME_EXPLOSIONHIT)
	player:setStorageValue(455577, -1)
	local playerId = player:getId()
	if nextUseStaminaTime[playerId] ~= nil then
		nextUseStaminaTime[playerId] = nil
	end

	local stats = player:inBossFight()
	if stats then
		-- Player logged out (or died) in the middle of a boss fight, store his damageOut and stamina
		local boss = Monster(stats.bossId)		
		if boss then
			local dmgOut = boss:getDamageMap()[playerId]
			if dmgOut then
				stats.damageOut = (stats.damageOut or 0) + dmgOut.total
			end
			stats.stamina = player:getStamina()
		end
	end

	return true
end