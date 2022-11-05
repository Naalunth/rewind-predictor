-- Event Type: TSU
-- Check On... Every Frame
-- This trigger cleans up damage events that are older than the threshold defined in the init action

---@diagnostic disable-next-line: miss-name
function()
    if GetTime() < aura_env.nextUpdate then return false end

    -- if no damage events are left, then this will wait for the combat log to change this value again
    aura_env.nextUpdate = GetTime() + 999999
    
    -- clean up damage events older than the clear time
    for guid, damageData in pairs(aura_env.damageData) do
        while #damageData > 0 and damageData[1].time + aura_env.CLEAR_TIME < GetTime() do
            table.remove(damageData, 1)
        end
        if #damageData == 0 then
            aura_env.damageData[guid] = nil
        else
            -- set the next time this needs to update to whenever the next entry runs out
            aura_env.nextUpdate = math.min(aura_env.nextUpdate, damageData[1].time + aura_env.CLEAR_TIME)
        end
    end

    WeakAuras.ScanEvents("RECENT_DAMAGE_TAKEN_CHANGED", aura_env.damageData)

    return false
end
