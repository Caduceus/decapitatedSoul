function Player:onBrowseField(position)
	return true
end

function Player:onLook(thing, position, distance)
	local description = "You see " .. thing:getDescription(distance)
			if LOOK_MARRIAGE_DESCR and thing:isCreature() then
        if thing:isPlayer() then
            description = description .. self:getMarriageDescription(thing)
        end
    end
    local itemBonus = itemBonusConfig[thing:getId()]
			if itemBonus then
				local vocBonuses = itemBonus[self:getVocation():getBase():getId()]
				if vocBonuses then
					for _, v in pairs(vocBonuses) do
						if v.string then
							description = string.format("%s\n%d %s", description, v.value, v.string) --("%s\n+%d %s", description, v.value, v.string)
						elseif v.strings then
							local strings = {"+".. v.value .." "}
							local size = #v.strings
							for i = 1, size do
								local string = v.strings[i]
								strings[#strings+1] = string .. (i ~= size and ", " or "")
							end
							description = string.format("%s\n%s", description, table.concat(strings))
						end
					end
				end
			end
	if self:getGroup():getAccess() then
		if thing:isItem() then
		local itemType = ItemType(thing:getId())
			description = string.format("%s\nItem ID: %d Client ID: %d", description, thing:getId(),itemType:getClientId())
			
						
			local actionId = thing:getActionId()
			if actionId ~= 0 then
				description = string.format("%s, Action ID: %d", description, actionId)
			end

			local uniqueId = thing:getAttribute(ITEM_ATTRIBUTE_UNIQUEID)
			if uniqueId > 0 and uniqueId < 65536 then
				description = string.format("%s, Unique ID: %d", description, uniqueId)
			end

			local itemType = thing:getType()

			local transformEquipId = itemType:getTransformEquipId()
			local transformDeEquipId = itemType:getTransformDeEquipId()
			if transformEquipId ~= 0 then
				description = string.format("%s\nTransforms to: %d (onEquip)", description, transformEquipId)
			elseif transformDeEquipId ~= 0 then
				description = string.format("%s\nTransforms to: %d (onDeEquip)", description, transformDeEquipId)
			end

			local decayId = itemType:getDecayId()
			if decayId ~= -1 then
				description = string.format("%s\nDecays to: %d", description, decayId)
			end
		elseif thing:isCreature() then
			local str = "%s\nHealth: %d / %d"
			if thing:getMaxMana() > 0 then
				str = string.format("%s, Mana: %d / %d", str, thing:getMana(), thing:getMaxMana())
			end
			description = string.format(str, description, thing:getHealth(), thing:getMaxHealth()) .. "." 
		end
		
		local position = thing:getPosition()
		description = string.format(
			"%s\nPosition: %d, %d, %d",
			description, position.x, position.y, position.z
		)
		local lookType = tonumber(1293)
		if thing:isPlayer() then
			description = string.format("%s\nSoul: %s, \nLooktype: %d ", description, thing:getSoul(), thing:getOutfit().lookType)
		end

		if thing:isCreature() then
			if thing:isPlayer() then
				description = string.format("%s\nIP: %s", description, Game.convertIpToString(thing:getIp()))
			end
		end
	end
	self:sendTextMessage(MESSAGE_INFO_DESCR, description)--MESSAGE_INFO_DESCR
end


function Player:onLookInBattleList(creature, distance)
	local description = "You see " .. creature:getDescription(distance)
	if self:getGroup():getAccess() then
		local str = "%s\nHealth: %d / %d"
		if creature:getMaxMana() > 0 then
			str = string.format("%s, Mana: %d / %d", str, creature:getMana(), creature:getMaxMana())
		end
		description = string.format(str, description, creature:getHealth(), creature:getMaxHealth()) .. "."

		local position = creature:getPosition()
		description = string.format(
			"%s\nPosition: %d, %d, %d",
			description, position.x, position.y, position.z 
		)

		if creature:isPlayer() then
			description = string.format("%s\nIP: %s", description, Game.convertIpToString(creature:getIp()))
		end
	end
	self:sendTextMessage(MESSAGE_INFO_DESCR, description)
end

function Player:onLookInTrade(partner, item, distance)
	self:sendTextMessage(MESSAGE_INFO_DESCR, "You see " .. item:getDescription(distance))
end

function Player:onLookInShop(itemType, count)
	return true
end

function Player:onMoveItem(item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	if item:getActionId() == NOT_MOVEABLE_ACTION or item:getActionId() == LILITH_PIANO or item:getActionId() == VLAD_PASSAGE then
		self:sendCancelMessage('Quit trying to thieve the ' .. item:getName() .. '!')
		self:say('The ' .. item:getName() .. ' is not yours!', TALKTYPE_MONSTER_SAY)
		return false
	end
	
    if toPosition.x == CONTAINER_POSITION and toCylinder and toCylinder:getId() == 26052 then
        self:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
        return false
    end

	if toPosition.x ~= CONTAINER_POSITION then
		return true
	end
	
	local ARROW_BOLT = {2543,2544,2545,2546,2547,3965,6529,7363,7364,7365,7838,7839,7840,7850,15648,15649,18303,18304,18435,18436,18437,23839}
	if toCylinder:getId() == 12425 and not isInArray(ARROW_BOLT, item:getId()) then
        self:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
        return false
    end
    
    local AMMO_BOX = {4392,8114}
    local BULLETS = {4391,8113}
	if  isInArray(AMMO_BOX, toCylinder:getId()) and not isInArray(BULLETS, item:getId()) then  
        self:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
        return false
    end
    
	if item:getTopParent() == self and bit.band(toPosition.y, 0x40) == 0 then	
		local itemType, moveItem = ItemType(item:getId())
		if bit.band(itemType:getSlotPosition(), SLOTP_TWO_HAND) ~= 0 and toPosition.y == CONST_SLOT_LEFT then
			moveItem = self:getSlotItem(CONST_SLOT_RIGHT)	
		elseif itemType:getWeaponType() == WEAPON_SHIELD and toPosition.y == CONST_SLOT_RIGHT then
			moveItem = self:getSlotItem(CONST_SLOT_LEFT)
			if moveItem and bit.band(ItemType(moveItem:getId()):getSlotPosition(), SLOTP_TWO_HAND) == 0 then
				return true
			end
		end

		if moveItem then
			local parent = item:getParent()
			if parent:getSize() == parent:getCapacity() then
				self:sendTextMessage(MESSAGE_STATUS_SMALL, Game.getReturnMessage(RETURNVALUE_CONTAINERNOTENOUGHROOM))
				return false
			else
				return moveItem:moveTo(parent)
			end
		end
	end
	
	if toPosition.x == CONTAINER_POSITION then
		local containerId = toPosition.y - 64
		local container = self:getContainerById(containerId)		
		if not container then
			return true 
		end

		-- Do not let the player insert items into either the Reward Container or the Reward Chest
		local itemId = container:getId()		
		if itemId == ITEM_REWARD_CONTAINER or itemId == ITEM_REWARD_CHEST then
			self:sendCancelMessage('Sorry, not possible.')
			return false
		end

		-- The player also shouldn't be able to insert items into the boss corpse		
		local tile = Tile(container:getPosition())
		for _, item in ipairs(tile:getItems()) do
			if item:getAttribute(ITEM_ATTRIBUTE_CORPSEOWNER) == 2^31 - 1 and item:getName() == container:getName() then
				self:sendCancelMessage('Sorry, not possible.')
				return false
			end
		end
	end

	-- Do not let the player move the boss corpse.
	if item:getAttribute(ITEM_ATTRIBUTE_CORPSEOWNER) == 2^31 - 1 then
		self:sendCancelMessage('Sorry, not possible.')
		return false
	end

    return true
end

function Player:onMoveCreature(creature, fromPosition, toPosition)
	return true
end

--[[function Player:onTurn(direction)
    if self:getGroup():getAccess() and self:getDirection() == direction then
        local nextPosition = self:getPosition()
        nextPosition:getNextPosition(direction)

        self:teleportTo(nextPosition, true)
    end

    return true
end]]--

local tempGhostPlayerEvents = tempGhostPlayerEvents or {}
local function removeGhost(cid)
    local player = Player(cid)
    if tempGhostPlayerEvents[cid] then
        if player then
            local tile = Tile(player:getPosition())
            if tile:hasFlag(TILESTATE_FLOORCHANGE) then
                tempGhostPlayerEvents[cid] = addEvent(removeGhost, 350, cid)
                return
            end

            local tileItems = tile:getItems() or {}
            table.insert(tileItems, tile:getGround())
         
            for _, item in ipairs(tileItems) do
                if item:hasProperty(CONST_PROP_BLOCKSOLID) then
                    tempGhostPlayerEvents[cid] = addEvent(removeGhost, 350, cid)
                    return
                end
            end
            player:setGhostMode(false, false)
        end

        tempGhostPlayerEvents[cid] = nil
    end
end

local playerLastTurn = playerLastTurn or {}
function Player:onTurn(direction)
    if not self:getGroup():getAccess() or self:getAccountType() < ACCOUNT_TYPE_GOD then
        return true
    end

    local lastTurn = playerLastTurn[self:getId()]
    if self:getDirection() ~= direction and (not lastTurn or os.mtime() - lastTurn > 200) then
        return true
    end

    local cid = self:getId()
    if not self:isInGhostMode() or tempGhostPlayerEvents[cid] then
        self:setGhostMode(true, false)
        stopEvent(tempGhostPlayerEvents[cid]) -- Stop previous event
        tempGhostPlayerEvents[cid] = addEvent(removeGhost, 350, self:getId())
    end

    playerLastTurn[self:getId()] = os.mtime()

    local pos = self:getPosition()
    pos:getNextPosition(direction)
    while not Tile(pos) and pos.z < 7 do
        pos.z = pos.z + 1
    end
    self:teleportTo(pos, true)

    return true
end

function Player:onTradeRequest(target, item)
	return true
end

function Player:onTradeAccept(target, item, targetItem)
	return true
end

local soulCondition = Condition(CONDITION_SOUL, CONDITIONID_DEFAULT)
soulCondition:setTicks(4 * 60 * 1000)
soulCondition:setParameter(CONDITION_PARAM_SOULGAIN, 1)

local function useStamina(player)
	local staminaMinutes = player:getStamina()
	if staminaMinutes == 0 then
		return
	end

	local playerId = player:getId()
	local currentTime = os.time()
	local timePassed = currentTime - nextUseStaminaTime[playerId]
	if timePassed <= 0 then
		return
	end

	if timePassed > 60 then
		if staminaMinutes > 2 then
			staminaMinutes = staminaMinutes - 2
		else
			staminaMinutes = 0
		end
		nextUseStaminaTime[playerId] = currentTime + 120
	else
		staminaMinutes = staminaMinutes - 1
		nextUseStaminaTime[playerId] = currentTime + 60
	end
	player:setStamina(staminaMinutes)
end

function Player:onGainExperience(source, exp, rawExp)
	if not source or source:isPlayer() then
		return exp
	end

	-- Soul regeneration
	local vocation = self:getVocation()
	if self:getSoul() < vocation:getMaxSoul() and exp >= self:getLevel() then
		soulCondition:setParameter(CONDITION_PARAM_SOULTICKS, vocation:getSoulGainTicks() * 1000)
		self:addCondition(soulCondition)
	end

	-- Apply experience stage multiplier
	exp = exp * Game.getExperienceStage(self:getLevel())

	-- Stamina modifier
	if configManager.getBoolean(configKeys.STAMINA_SYSTEM) then
		useStamina(self)

		local staminaMinutes = self:getStamina()
		if staminaMinutes > 2400 and self:isPremium() then
			exp = exp * 1.5
		elseif staminaMinutes <= 840 then
			exp = exp * 0.5
		end
	end

	return exp
end

function Player:onLoseExperience(exp)
	return exp
end

function Player:onGainSkillTries(skill, tries)
	if APPLY_SKILL_MULTIPLIER == false then
		return tries
	end

	if skill == SKILL_MAGLEVEL then
		return tries * configManager.getNumber(configKeys.RATE_MAGIC)
	end
	return tries * configManager.getNumber(configKeys.RATE_SKILL)
end

function Player:onWrapItem(item, position)
	local topCylinder = item:getTopParent()
	if not topCylinder then
		return
	end

	local tile = Tile(topCylinder:getPosition())
	if not tile then
		return
	end

	if not tile:getHouse() then
		self:sendCancelMessage("You can only wrap and unwrap this item inside a house.")
		return
	end

	local wrapId = item:getAttribute("wrapid")
	if wrapId == 0 then
		return
	end
	
	local oldId = item:getId()
	local kit = Game.createItem(wrapId, 1, item:getPosition())
	if kit then
		kit:setAttribute(ITEM_ATTRIBUTE_WRAPID, oldId)
		kit:decay()
		item:remove(1)
	end
end

function Player:onGainExperience(source, experience, rawExperience)
    if self:isVip() then
        experience = experience * 2
    end
    
    if self:getStorageValue(1233) >= os.time() then
        experience = experience * 2
    end

    if self:getStorageValue(1234) >= os.time() then
        experience = experience * 2
    end

    return experience * Game.getExperienceStage(self:getLevel())
end

local config = {
        -- base vocationId
        [1] = {
                -- skillId
                [SKILL_FIST] = {
                        -- [{skillLevel}] = skillRate
                        [{10, 30}] = 40,
                        [{31, 50}] = 30,
                        [{51, 70}] = 20,
                        [{71, 150}] = 10
                },
                [SKILL_CLUB] = {
                        [{10, 49}] = 30,
                        [{50, 99}] = 20,
                        [{100, 150}] = 10
                },
                [SKILL_SWORD] = {
                        [{10, 49}] = 30,
                        [{50, 99}] = 20,
                        [{100, 150}] = 10
                },
                [SKILL_AXE] = {
                        [{10, 49}] = 30,
                        [{50, 99}] = 20,
                        [{100, 150}] = 10
                },
                [SKILL_DISTANCE] = {
                        [{10, 49}] = 30,
                        [{50, 99}] = 20,
                        [{100, 150}] = 10
                },
                [SKILL_SHIELD] = {
                        [{10, 49}] = 30,
                        [{50, 99}] = 20,
                        [{100, 150}] = 10
                },
                [SKILL_FISHING] = {
                        [{10, 49}] = 30,
                        [{50, 99}] = 20,
                        [{100, 150}] = 10
                },
                [SKILL_MAGLEVEL] = {
                        [{10, 49}] = 30,
                        [{50, 99}] = 20,
                        [{100, 150}] = 10
                }
        }
}
  
local function getSkillRate(player, skillId)
        local targetVocation = config[player:getVocation():getBase():getId()]
        if targetVocation then
                local targetSkillStage = targetVocation[skillId]
                if targetSkillStage then
                        local skillLevel = skillId ~= SKILL_MAGLEVEL and player:getSkillLevel(skillId) or player:getBaseMagicLevel()
                        for level, rate in pairs(targetSkillStage) do
                                if skillLevel >= level[1] and skillLevel <= level[2] then
                                        return rate
                                end
                        end
                end
        end
 
        return skillId == SKILL_MAGLEVEL and configManager.getNumber(configKeys.RATE_MAGIC) or configManager.getNumber(configKeys.RATE_SKILL)
end
 
function Player:onGainSkillTries(skill, tries)
        if not APPLY_SKILL_MULTIPLIER then
                return tries
        end
 
        return tries * getSkillRate(self, skill)
end
