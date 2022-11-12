-- Event Type: TSU
-- Check On... TRIGGER:2,RECENT_DAMAGE_TAKEN_CHANGED

---@diagnostic disable-next-line: miss-name
function(allStates, event, ...)
    -- first, figure out which unit actually changed
    local unit, guid, predictedHeal
    local params = {...}
    if event == "RECENT_DAMAGE_TAKEN_CHANGED" then
        aura_env.recentDamageSums, guid, predictedHeal = unpack(params)
        for groupMember in WA_IterateGroupMembers() do
            if guid == UnitGUID(groupMember) then
                unit = groupMember
                break
            end
        end
    elseif event == "TRIGGER" and params[1] == 2 then
        unit = next(params[2])
        guid = UnitGUID(unit)
        predictedHeal = guid and aura_env.recentDamageSums[guid] or 0
    end

    if not unit then return false end

    -- remove the clone for the unit if no heal is predicted
    if predictedHeal == 0 then
        if not allStates[unit] then
            return false
        else
            allStates[unit] = {
                show = false,
                changed = true,
            }
            return true
        end
    end

    -- apply any additional logic that might modify the heal prediction
    predictedHeal = aura_env.MODIFIER(predictedHeal)

    local health = UnitHealth(unit)
    local healthMax = UnitHealthMax(unit)
    -- if I would heal more than someones max health, I really don't care about specifics
    predictedHeal = math.min(predictedHeal, healthMax)

    -- place the heal prediction bar according to user preference, even though no one will ever change this option
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

    -- change the clone if it needs changing, which it probably will generally speaking
    if not allStates[unit]
        or allStates[unit].total ~= healthMax
        or allStates[unit].additionalProgress[1].min ~= lowBound
        or allStates[unit].additionalProgress[1].max ~= highBound
    then
        allStates[unit] = {
            show = true,
            changed = true,
            unit = unit,
            progressType = "static",
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
