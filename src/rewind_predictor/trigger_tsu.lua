-- Event Type: TSU
-- Check On... TRIGGER:2,RECENT_DAMAGE_TAKEN_CHANGED

---@diagnostic disable-next-line: miss-name
function(allStates, event, ...)
    -- first, figure out which unit actually changed
    local unit
    if event == "RECENT_DAMAGE_TAKEN_CHANGED" then
        aura_env.damageData = ({...})[1]
        for groupMember in WA_IterateGroupMembers() do
            if ({...})[2] == UnitGUID(groupMember) then
                unit = groupMember
                break
            end
        end
    elseif event == "TRIGGER" and ({...})[1] == 2 then
        unit = next(({...})[2])
    end

    if not unit then return false end

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
        return true
    else
        allStates[unit].changed = false
        return false
    end
end
