-- Event Type: TSU
-- Check On... TRIGGER:2,RECENT_DAMAGE_TAKEN_CHANGED

---@diagnostic disable-next-line: miss-name
function(allStates, event, ...)
    -- first, figure out which unit actually changed
    local unit, guid, predictedHeal, health, healthMax
    local params = {...}
    if event == "RECENT_DAMAGE_TAKEN_CHANGED" then
        aura_env.recentDamageSums, guid, predictedHeal = unpack(params)
        unit = aura_env.find(function(u) return guid == UnitGUID(u) end, WA_IterateGroupMembers())
        if not unit then return false end
        healthMax = UnitHealthMax(unit)
        health = UnitHealth(unit)
    elseif event == "TRIGGER" and params[1] == 2 then
        local unitData
        unit, unitData = next(params[2])
        guid = UnitGUID(unit)
        predictedHeal = guid and aura_env.recentDamageSums[guid] or 0
        health = unitData.health
        healthMax = unitData.total
    else return false end

    -- apply any additional logic that might modify the heal prediction
    predictedHeal = aura_env.predictionModifier(predictedHeal)

    -- remove the clone for the unit if no heal is predicted
    if predictedHeal == 0 then
        if not allStates[unit] then
            return false
        else
            allStates[unit].show = false
            allStates[unit].changed = true
            return true
        end
    end

    -- get the area of the bar to display
    local lowerBound, upperBound = aura_env.getBounds(health, healthMax, predictedHeal)

    -- change the clone if it needs changing, which it probably will generally speaking
    if not allStates[unit]
        or allStates[unit].total ~= healthMax
        or allStates[unit].additionalProgress[1].min ~= lowerBound
        or allStates[unit].additionalProgress[1].max ~= upperBound
    then
        allStates[unit] = {
            show = true,
            changed = true,
            unit = unit,
            progressType = "static",
            total = healthMax,
            additionalProgress = {
                {
                    min = lowerBound,
                    max = upperBound,
                },
            },
        }
        return true
    else
        return false
    end
end
