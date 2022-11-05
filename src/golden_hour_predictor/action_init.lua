-- Action: On Init
---The time that will be rewound in seconds
aura_env.REWIND_TIME = 5

---These modifiers will be applied to the amount of heal that is being predicted
aura_env.MODIFIERS = {
    function (predictedHeal)
        return predictedHeal * 0.15
    end,
}

---Holds the next time we want to update our values
aura_env.nextUpdate = GetTime()
