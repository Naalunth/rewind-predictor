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
        return IsPlayerSpell(aura_env.SpellIds.TEMPORAL_ARTIFICER) and predictedHeal * 0.5 or predictedHeal
    end,
}

---Holds the next time we want to update our values
aura_env.nextUpdate = GetTime()

aura_env.damageData = {}
