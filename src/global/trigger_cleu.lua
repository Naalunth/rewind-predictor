-- Event Type: Event
-- Events: CLEU

---@diagnostic disable-next-line: miss-name
function(_, _, subEvent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...)
    local allyMask = bit.bor(COMBATLOG_OBJECT_AFFILIATION_MINE, COMBATLOG_OBJECT_AFFILIATION_PARTY, COMBATLOG_OBJECT_AFFILIATION_RAID)

    -- track all damage events on allies
    if bit.band(destFlags, allyMask) ~= 0 and DamageTakenTracker.checkSuffix(subEvent, "_DAMAGE") then
        local prefix = DamageTakenTracker.removeSuffix(subEvent, "_DAMAGE")
        local damage = ({...})[DamageTakenTracker.getPrefixParamCount(prefix) + 1]
        if not DamageTakenTracker.damageData[destGUID] then
            DamageTakenTracker.damageData[destGUID] = {}
        end
        local entry = {time = GetTime(), damage = damage}
        table.insert(DamageTakenTracker.damageData[destGUID], entry)
    end
end
