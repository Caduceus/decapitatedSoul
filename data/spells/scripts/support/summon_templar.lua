function onCastSpell(player, variant)

        local config = { 
			playerPos = player:getPosition(),
            guardian = "templar",
            deSpawn = 2 * 60
            }

                if #player:getSummons() >= 1 then
                        player:sendCancelMessage("You already have a guardian.")
                        player:sendMagicEffect(CONST_ME_POFF)
                        return false
                end
                
        local monster = Game.createMonster(config.guardian, config.playerPos)
			if monster then
				addEvent(function(cid)
				local monster = Monster(cid)
					if monster == nil then
					return false
				end
					monster:say("UNTIL WE MEET AGAIN!", TALKTYPE_MONSTER_YELL)
					monster:getPosition():sendMagicEffect(CONST_ME_POFF)
					monster:remove()
					end, config.deSpawn * 1000, monster:getId())
										
        -- Place the monster
         monster:setMaster(player)
         monster:say("".. player:getName() .."'s Guardian to the rescue!", TALKTYPE_MONSTER_YELL)
         config.playerPos:sendMagicEffect(CONST_ME_MAGIC_BLUE)
        return true
	end
end