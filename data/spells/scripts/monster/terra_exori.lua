local combat = {}

    for i = 1, 5 do
        combat[i] = Combat()
        combat[i]:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
        combat[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_BIGPLANTS)
        combat[i]:setFormula(COMBAT_FORMULA_LEVELMAGIC, -2.0, -100, -1.6, -100)
    end


    local area = {
        {
			{0, 0, 1, 1, 1, 1, 1, 0, 0},
			{0, 1, 0, 0, 0, 0, 0, 1, 0},
			{1, 0, 0, 0, 0, 0, 0, 0, 1},
			{1, 0, 0, 0, 0, 0, 0, 0, 1},
			{1, 0, 0, 0, 2, 0, 0, 0, 1},
			{1, 0, 0, 0, 0, 0, 0, 0, 1},
			{1, 0, 0, 0, 0, 0, 0, 0, 1},
			{0, 1, 0, 0, 0, 0, 0, 1, 0},
			{0, 0, 1, 1, 1, 1, 1, 0, 0}
        },
        {
            {0, 1, 1, 1, 1, 1, 0},
			{1, 1, 0, 0, 0, 1, 1},
			{1, 0, 0, 0, 0, 0, 1},
			{1, 0, 0, 2, 0, 0, 1},
			{1, 0, 0, 0, 0, 0, 1},
			{1, 1, 0, 0, 0, 1, 1},
			{0, 1, 1, 1, 1, 1, 0}
        },
        {
            {0, 1, 1, 1, 0},
			{1, 1, 0, 1, 1},
			{1, 0, 2, 0, 1},
			{1, 1, 0, 1, 1},
			{0, 1, 1, 1, 0}
        },
        {
            {0, 1, 1, 1, 0},
			{1, 1, 0, 1, 1},
			{1, 0, 2, 0, 1},
			{1, 1, 0, 1, 1},
			{0, 1, 1, 1, 0}
        },
        {
            {0, 1, 0},
			{1, 2, 1},
			{0, 1, 0}
        }
    }
 
       for x, _ in ipairs(area) do
        combat[x]:setArea(createCombatArea(area[x]))
    end

     function executeCombat(p, i)
        if not p.creature then
            return true
        end
        if not p.creature:isCreature() then
             return false
        end
        p.combat[i]:execute(p.creature, p.var)
    end

   function onCastSpell(creature, var)
     local p = {creature = creature, var = var, combat = combat}
     local time_ = {1, 1200, 1600, 2200, 2600}
     for t, _ in ipairs(time_) do
         addEvent(executeCombat, time_[t], p, t)
     end
     return true
end
