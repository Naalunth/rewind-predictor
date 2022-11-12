-- Action: On Init
aura_env.SpellIds = {
    TEMPORAL_ARTIFICER = 381922,
}

---This modifier will be applied to the amount of heal that is being predicted
aura_env.MODIFIER = function(predictedHeal)
    if IsInRaid() then predictedHeal = predictedHeal * 0.5 end
    if IsPlayerSpell(aura_env.SpellIds.TEMPORAL_ARTIFICER) then predictedHeal = predictedHeal * 0.5 end
    return predictedHeal
end

aura_env.recentDamageSums = {}
