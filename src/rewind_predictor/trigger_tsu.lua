-- Event Type: TSU
-- Check On... Every Frame

---@diagnostic disable-next-line: miss-name
function(allStates)
    if GetTime() < aura_env.nextUpdate then return false end
    aura_env.nextUpdate = GetTime() + aura_env.config.updateInterval

    -- clean up previous states, they will be overwritten
    for _, state in pairs(allStates) do
        state.show = false
        state.changed = true
    end

    -- update all our indicators
    for unit in WA_IterateGroupMembers() do
        local guid = UnitGUID(unit)
        local predictedHeal = 0

        if guid then
            -- add up all the damage done to the unit
            local damageData = DamageTakenTracker.damageData[guid] or {}
            for _, entry in ipairs(damageData) do
                if entry.time > GetTime() - aura_env.REWIND_TIME then
                    predictedHeal = predictedHeal + entry.damage
                end
            end
        end

        -- apply any additional logic that might modify the heal prediction
        for _, modifier in pairs(aura_env.MODIFIERS) do
            predictedHeal = modifier(predictedHeal)
        end

        local health = UnitHealth(unit)
        local healthMax = UnitHealthMax(unit)
        -- if I would heal more than someones max health, I really don't care about specifics
        predictedHeal = math.min(predictedHeal, healthMax)

        -- place the heal prediction bar according to user preference
        local lowBound, highBound
        local anchorPoint = aura_env.config.anchorPoint
        local APOption = DamageTakenTracker.Options.AnchorPoint
        if anchorPoint == APOption.START then
            lowBound = 0
            highBound = predictedHeal
        elseif anchorPoint == APOption.CURRENT_HEALTH then
            lowBound = health
            highBound = math.min(health + predictedHeal, healthMax)
        elseif anchorPoint == APOption.CURRENT_HEALTH_OVERFLOW then
            if health + predictedHeal <= healthMax then
                lowBound = health
                highBound = health + predictedHeal
            else
                lowBound = healthMax - predictedHeal
                highBound = healthMax
            end
        end

        allStates[unit] = {
            show = true,
            changed = true,
            unit = unit,
            progressType = "static",
            value = health,
            total = healthMax,
            additionalProgress = {
                {
                    min = lowBound,
                    max = highBound,
                },
            },
        }
    end
    return true
end
