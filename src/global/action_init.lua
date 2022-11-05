-- Action: On Init
---Holds the next time we want to update our values
aura_env.nextUpdate = GetTime()

---The time before damage taken events get deleted.
aura_env.CLEAR_TIME = 5

DamageTakenTracker = {
    SpellIds = {
        TEMPORAL_ARTIFICER = 381922,
    },

    Options = {
        ---@enum Options.AnchorPoint
        AnchorPoint = {
            START = 1,
            CURRENT_HEALTH = 2,
            CURRENT_HEALTH_OVERFLOW = 3,
        },
    },

    ---@alias DamageDataEntry {time: number, damage: number}

    ---The keys of this table are the GUIDs of the units being tracked.
    ---The values are arrays of time when damage happened. They are always sorted by time.
    ---@type {[string]: DamageDataEntry[]}
    damageData = {},
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

function DamageTakenTracker.dump(o, limit, depth)
    depth = depth or 0
    limit = limit or 3
    if type(o) == "table" then
        if depth > limit then return "{...}" end
        local s = "{\n"
        local tabs = string.rep("\t", depth + 1);
        for k, v in pairs(o) do
            s = s .. tabs .. "[" .. DamageTakenTracker.dump(k, limit, depth + 1) .. "] = " .. DamageTakenTracker.dump(v, limit, depth + 1) .. ",\n"
        end
        return s .. string.rep("\t", depth) .. "}"
    elseif type(o) == "string" then
        return "\"" .. o .. "\""
    else
        return tostring(o)
    end
end
