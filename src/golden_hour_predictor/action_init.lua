-- Action: On Init

---This modifier will be applied to the amount of heal that is being predicted
aura_env.MODIFIER = function(predictedHeal)
    return predictedHeal * 0.15
end

aura_env.recentDamageSums = {}
