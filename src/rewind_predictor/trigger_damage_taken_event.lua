-- Event Type: Event
-- Events: RECENT_DAMAGE_TAKEN_CHANGED

---@diagnostic disable-next-line: miss-name
function(_, damageData)
    aura_env.damageData = damageData or {}
end
