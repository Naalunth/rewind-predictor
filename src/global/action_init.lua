-- Action: On Init
---The time before damage taken events get deleted.
aura_env.CLEAR_TIME = 5

---@alias DamageDataEntry {time: number, damage: number}

---A running total of the damage received by friendly units over the last 5 seconds.
---Keys are unit GUIDs, the values are the totals. Values default to `0` for all keys.
---@type {[string]: number}
aura_env.recentDamageSums = {}
setmetatable(aura_env.recentDamageSums, {__index = function() return 0 end})

-- used for filtering for allies
aura_env.allyMask = bit.bor(COMBATLOG_OBJECT_AFFILIATION_MINE, COMBATLOG_OBJECT_AFFILIATION_PARTY, COMBATLOG_OBJECT_AFFILIATION_RAID)
