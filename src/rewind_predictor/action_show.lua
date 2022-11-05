-- Action: On Show
-- adjust the width to fill the unit frame
local parentFrame = aura_env.region:GetParent()
if parentFrame then
    if aura_env.config.shouldFillWidth then
        aura_env.region:SetRegionWidth(parentFrame:GetWidth())
    end
    if aura_env.config.shouldFillHeight then
        aura_env.region:SetRegionHeight(parentFrame:GetHeight())
    end
end
