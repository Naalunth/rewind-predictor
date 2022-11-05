-- Event Type: TSU
-- Check On... RECENT_DAMAGE_TAKEN_CHANGED and health changes

---@diagnostic disable-next-line: miss-name
function(allStates)
    if GetTime() < aura_env.nextUpdate then return false end
    aura_env.nextUpdate = GetTime() + aura_env.config.updateInterval

    local hasAnyStateChanged = false
    local shownUnits = {}

    -- update all our indicators
    for unit in WA_IterateGroupMembers() do
        local guid = UnitGUID(unit)
        local predictedHeal = 0

        if guid then
            -- add up all the damage done to the unit
            local damageData = aura_env.damageData[guid] or {}
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
        local AnchorPointOption = {
            START = 1,
            CURRENT_HEALTH = 2,
            CURRENT_HEALTH_OVERFLOW = 3,
        }
        if anchorPoint == AnchorPointOption.START then
            lowBound = 0
            highBound = predictedHeal
        elseif anchorPoint == AnchorPointOption.CURRENT_HEALTH then
            lowBound = health
            highBound = math.min(health + predictedHeal, healthMax)
        elseif anchorPoint == AnchorPointOption.CURRENT_HEALTH_OVERFLOW then
            if health + predictedHeal <= healthMax then
                lowBound = health
                highBound = health + predictedHeal
            else
                lowBound = healthMax - predictedHeal
                highBound = healthMax
            end
        end

        if not allStates[unit]
            or allStates[unit].value ~= health
            or allStates[unit].total ~= healthMax
            or allStates[unit].additionalProgress[1].min ~= lowBound
            or allStates[unit].additionalProgress[1].max ~= highBound
        then
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
            hasAnyStateChanged = true
        else
            allStates[unit].changed = false
        end
        table.insert(shownUnits, unit)
    end

    -- clean up states that are no longer displayed
    for unit, state in pairs(allStates) do
        -- check if the unit is still displayed
        local isCurrentlyShown = false
        for _, shownUnit in ipairs(shownUnits) do
            if unit == shownUnit then
                isCurrentlyShown = true
                break
            end
        end

        -- and if it isn't, remove its state
        if not isCurrentlyShown then
            state.show = false
            state.changed = true
            hasAnyStateChanged = true
        end
    end

    return hasAnyStateChanged
end
