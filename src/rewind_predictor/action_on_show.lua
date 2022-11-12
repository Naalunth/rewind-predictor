-- update the size of the regions to fit the parent frames
if aura_env.region then
    local parentFrame = aura_env.region:GetParent()
    if parentFrame then
        if aura_env.config.shouldFillWidth and aura_env.region:GetWidth() ~= parentFrame:GetWidth() then
            aura_env.region:SetRegionWidth(parentFrame:GetWidth())
        end
        if aura_env.config.shouldFillHeight and aura_env.region:GetHeight() ~= parentFrame:GetHeight() then
            aura_env.region:SetRegionHeight(parentFrame:GetHeight())
        end
    end
end
