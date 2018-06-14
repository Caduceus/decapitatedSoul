local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_CARNIPHILA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_SMALLEARTH)
combat:setParameter(COMBAT_PARAM_PVPDAMAGE, 300)

function onGetFormulaValues(player, level, maglevel)
	local min = (level / 5) + (maglevel * 6.5) + 35
	local max = (level / 5) + (maglevel * 12.3) + 55
	return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(creature, var)
	return combat:execute(creature, var)
end