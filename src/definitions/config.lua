---@meta
aura_env.config = {
    ---How many seconds between updating the predictions?
    ---@type number
    updateInterval = nil,

    ---Should the bar fill the height of the unit frame?
    ---@type boolean
    shouldFillHeight = nil,

    ---Should the bar fill the width of the unit frame?
    ---@type boolean
    shouldFillWidth = nil,

    ---@type Options.AnchorPoint
    anchorPoint = nil,
    
    ---@enum Options.AnchorPoint
    AnchorPoint = {
        START = 1,
        CURRENT_HEALTH = 2,
        CURRENT_HEALTH_OVERFLOW = 3,
    },
}
