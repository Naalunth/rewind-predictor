-- Event Type: Event
-- Events: CLEU
-- This trigger listens for all incoming damage events to allies and stores them

---@diagnostic disable-next-line: miss-name
function(_, _, subEvent, _, _, _, _, _, destGUID, _, destFlags, _, ...)
    local allyMask = bit.bor(COMBATLOG_OBJECT_AFFILIATION_MINE, COMBATLOG_OBJECT_AFFILIATION_PARTY, COMBATLOG_OBJECT_AFFILIATION_RAID)

    local function checkSuffix(s, suffix)
        return s:sub(-string.len(suffix)) == suffix
    end
    
    local function removeSuffix(s, suffix)
        return s:sub(1, -string.len(suffix) - 1)
    end
    
    local function getPrefixParamCount(prefix)
        if prefix == "SWING" then
            return 0
        elseif prefix == "ENVIRONMENTAL" then
            return 1
        else
            return 3
        end
    end
    
    -- track all damage events on allies
    if bit.band(destFlags, allyMask) ~= 0 and checkSuffix(subEvent, "_DAMAGE") then
        local prefix = removeSuffix(subEvent, "_DAMAGE")
        local damage = ({...})[getPrefixParamCount(prefix) + 1]
        if not aura_env.damageData[destGUID] then
            aura_env.damageData[destGUID] = {}
        end
        table.insert(aura_env.damageData[destGUID], {time = GetTime(), damage = damage})
        aura_env.nextUpdate = math.min(aura_env.nextUpdate, GetTime() + aura_env.CLEAR_TIME)

        WeakAuras.ScanEvents("RECENT_DAMAGE_TAKEN_CHANGED", aura_env.damageData)
    end
end
