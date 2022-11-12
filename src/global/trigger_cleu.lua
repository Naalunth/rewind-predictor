-- Event Type: Event
-- Events: CLEU:SWING_DAMAGE:RANGE_DAMAGE:SPELL_DAMAGE:SPELL_PERIODIC_DAMAGE:SPELL_BUILDING_DAMAGE:ENVIRONMENTAL_DAMAGE
-- This trigger listens for all incoming damage events to allies and stores them

---@diagnostic disable-next-line: miss-name
function(_, _, subEvent, _, _, _, _, _, destGUID, _, destFlags, _, ...)
    -- track all damage events on allies
    if bit.band(destFlags, aura_env.allyMask) ~= 0 then
        local prefixParameterCount
        if subEvent == "SWING_DAMAGE" then
            prefixParameterCount = 0
        elseif subEvent == "ENVIRONMENTAL_DAMAGE" then
            prefixParameterCount = 1
        else
            prefixParameterCount = 3
        end

        local damage = ({...})[prefixParameterCount + 1]
        local absorbed = ({...})[prefixParameterCount + 6]
        local totalDamage = damage + absorbed

        local recentDamageSums = aura_env.recentDamageSums

        -- adding the damage and notifying everyone who cares
        recentDamageSums[destGUID] = recentDamageSums[destGUID] + totalDamage
        WeakAuras.ScanEvents("RECENT_DAMAGE_TAKEN_CHANGED", recentDamageSums, destGUID, recentDamageSums[destGUID])

        -- after 5 seconds, remove this instance from the running total again and send out an event
        C_Timer.After(aura_env.CLEAR_TIME, function ()
            ---@type number?
            local newDamageSum = recentDamageSums[destGUID] - totalDamage
            -- crop down really small damage residuals, even if they should rarely become an issue
            -- the tables values default to zero
            if newDamageSum < 0.1 then newDamageSum = nil end
            recentDamageSums[destGUID] = newDamageSum
            WeakAuras.ScanEvents("RECENT_DAMAGE_TAKEN_CHANGED", recentDamageSums, destGUID, recentDamageSums[destGUID])
        end)
    end
end
