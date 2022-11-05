-- Event Type: TSU
-- Check On... Every Frame
-- This trigger cleans up damage events that are older than the threshold defined in the init action

---@diagnostic disable-next-line: miss-name
function(allStates)
    if GetTime() < aura_env.nextUpdate then return false end
    aura_env.nextUpdate = GetTime() + aura_env.config.updateInterval
    
    -- clean up damage events older than 5 seconds
    for guid, damageData in pairs(DamageTakenTracker.damageData) do
        while #damageData > 0 and damageData[1].time + aura_env.CLEAR_TIME < GetTime() do
            table.remove(damageData, 1)
        end
        if #damageData == 0 then
            DamageTakenTracker.damageData[guid] = nil
        end
    end
end
