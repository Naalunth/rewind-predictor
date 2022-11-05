-- Action: On Init
---The time that will be rewound in seconds
aura_env.REWIND_TIME = 5

aura_env.SpellIds = {
    TEMPORAL_ARTIFICER = 381922,
}

---These modifiers will be applied to the amount of heal that is being predicted
aura_env.MODIFIERS = {
    function (predictedHeal)
        return IsInRaid() and predictedHeal * 0.5 or predictedHeal
    end,
    function (predictedHeal)
        return aura_env.isPlayerSpell(aura_env.SpellIds.TEMPORAL_ARTIFICER) and predictedHeal * 0.5 or predictedHeal
    end,
}

aura_env.Options = {
    ---@enum Options.AnchorPoint
    AnchorPoint = {
        START = 1,
        CURRENT_HEALTH = 2,
        CURRENT_HEALTH_OVERFLOW = 3,
    },
}

---Holds the next time we want to update our values
aura_env.nextUpdate = GetTime()
