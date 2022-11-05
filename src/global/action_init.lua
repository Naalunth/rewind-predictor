-- Action: On Init

DamageTakenTracker = {
    ---@alias DamageDataEntry {time: number, damage: number}

    ---The keys of this table are the GUIDs of the units being tracked.
    ---The values are arrays of time when damage happened. They are always sorted by time.
    ---@type {[string]: DamageDataEntry[]}
    damageData = {}
}

---@param s string
---@param suffix string
---@return boolean
function DamageTakenTracker.checkSuffix(s, suffix)
    return s:sub(-string.len(suffix)) == suffix
end

---@param s string
---@param suffix string
---@return string
function DamageTakenTracker.removeSuffix(s, suffix)
    return s:sub(1, -string.len(suffix) - 1)
end

---@param prefix string
---@return integer
function DamageTakenTracker.getPrefixParamCount(prefix)
    if prefix == "SWING" then
        return 0
    elseif prefix == "ENVIRONMENTAL" then
        return 1
    else
        return 3
    end
end

function DamageTakenTracker.isPlayerSpell(spellId)
    return IsPlayerSpell(spellId) or IsSpellKnown(spellId)
end
