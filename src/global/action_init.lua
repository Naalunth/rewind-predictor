-- Action: On Init
---The time before damage taken events get deleted.
aura_env.CLEAR_TIME = 5

---Holds the next time we want to update our values.
aura_env.nextUpdate = 0

---@alias DamageDataEntry {time: number, damage: number}

---The keys of this table are the GUIDs of the units being tracked.
---The values are arrays of time when damage happened. They are always sorted by time.
---@type {[string]: DamageDataEntry[]}
aura_env.damageData = {}
