-- Action: On Init

---This modifier will be applied to the amount of heal that is being predicted
---@param predictedHeal number
---@return number newPredictedHeal
function aura_env.predictionModifier(predictedHeal)
    return predictedHeal * 0.15
end

-- SHARED CODE --

---A running total of the damage received by friendly units over the last 5 seconds.
---Keys are unit GUIDs, the values are the totals. Values default to `0` for all keys.
aura_env.recentDamageSums = {}

---Find a value matching `predicate` in an iterator. Currently only works with iterators returning single values.
---@generic S
---@generic V
---@param predicate fun(V?): boolean -- If true for a given value, the value will be returned
---@param iterator fun(S?, V?): V
---@param state S?
---@param var V?
---@return V?
function aura_env.find(predicate, iterator, state, var)
    while true do
        var = iterator(state, var)
        if var == nil then return nil end
        if predicate(var) then return var end
    end
end

aura_env.AnchorPointOption = {
    START = 1,
    CURRENT_HEALTH = 2,
    CURRENT_HEALTH_OVERFLOW = 3,
}

---Calculate the bounds of the health bar segment to display.
---@param health number -- Current health of the unit
---@param healthMax number -- Maximum health of the unit
---@param predictedHeal number -- Amount of healing that is predicted for that unit
---@return number lowerBound
---@return number upperBound
function aura_env.getBounds(health, healthMax, predictedHeal)
    -- if I would heal more than someones max health, I really don't care about specifics
    predictedHeal = math.min(predictedHeal, healthMax)

    -- place the heal prediction bar according to user preference, even though no one will ever change this option
    local lower, upper
    local anchorPoint = aura_env.config.anchorPoint
    if anchorPoint == aura_env.AnchorPointOption.START then
        lower = 0
        upper = predictedHeal
    elseif anchorPoint == aura_env.AnchorPointOption.CURRENT_HEALTH then
        lower = health
        upper = math.min(health + predictedHeal, healthMax)
    elseif anchorPoint == aura_env.AnchorPointOption.CURRENT_HEALTH_OVERFLOW then
        if health + predictedHeal <= healthMax then
            lower = health
            upper = health + predictedHeal
        else
            lower = healthMax - predictedHeal
            upper = healthMax
        end
    end

    return lower, upper
end
