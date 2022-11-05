-- Event Type: Event
-- Events: CLEU:SWING_DAMAGE:RANGE_DAMAGE:SPELL_DAMAGE:SPELL_PERIODIC_DAMAGE:SPELL_BUILDING_DAMAGE:ENVIRONMENTAL_DAMAGE
-- This trigger listens for all incoming damage events to allies and stores them

---@diagnostic disable-next-line: miss-name
function(_, _, subEvent, _, _, _, _, _, destGUID, _, destFlags, _, ...)
    local allyMask = bit.bor(COMBATLOG_OBJECT_AFFILIATION_MINE, COMBATLOG_OBJECT_AFFILIATION_PARTY, COMBATLOG_OBJECT_AFFILIATION_RAID)

    -- track all damage events on allies
    if bit.band(destFlags, allyMask) ~= 0 then
        local prefixParameterCount
        if subEvent == "SWING_DAMAGE" then
            prefixParameterCount = 0
        elseif subEvent == "ENVIRONMENTAL_DAMAGE" then
            prefixParameterCount = 1
        else
            prefixParameterCount = 3
        end

        local damage = ({...})[prefixParameterCount + 1]
        if not aura_env.damageData[destGUID] then
            aura_env.damageData[destGUID] = {}
        end
        table.insert(aura_env.damageData[destGUID], {time = GetTime(), damage = damage})
        aura_env.nextUpdate = math.min(aura_env.nextUpdate, GetTime() + aura_env.CLEAR_TIME)

        WeakAuras.ScanEvents("RECENT_DAMAGE_TAKEN_CHANGED", aura_env.damageData)
    end
end
