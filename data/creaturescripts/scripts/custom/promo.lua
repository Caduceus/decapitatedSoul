function onLogin(player)
	if player:getAccountStorageValue(accountStorage.returnPlayerPromo) == false or player:getAccountStorageValue(accountStorage.returnPlayerPromo) == 2 then
	return true
end
	if player:getAccountStorageValue(accountStorage.returnPlayerPromo) == 1 then
		player:popupFYI("  Welcome back to Decapitated Soul, " .. player:getName() .. "! We have been hard at work creating new content for you to try out! As a token of our appreciation for your return, we have given you 7 free VIP days and a Tibia Coin. Are you ready for all that awaits?")
		player:addVipDays(7)
		player:addItem(24774, 1)
		player:setAccountStorageValue(accountStorage.returnPlayerPromo, 2)
	return true
	end
end
