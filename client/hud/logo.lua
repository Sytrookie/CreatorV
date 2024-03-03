-- local SetDrawOrigin = SetDrawOrigin
local DrawSprite = DrawSprite
local SetScriptGfxAlignParams = SetScriptGfxAlignParams


CreateThread(function()
    while true do
        Wait(10 * FRAMETIME)
        SetScriptGfxAlignParams(0.0, 0.0, 0.0, 0.0)
        -- SetDrawOrigin(coords.x, coords.y, coords.z) -- for 3d shit
        DrawSprite('creatorv_txd', Textures.logo, 0.015, 0.05, 0.0185, 0.03333333333333333, 0, 255, 255, 255, 255)
    end
end)