local originalWindowTint
local function windowTint()
    originalWindowTint = GetVehicleWindowTint(vehicle)

    local windowTintLabels = {}
    for i, v in ipairs(VMODSConfig.WindowTints) do
        windowTintLabels[i] = v.label
    end

    local option = {
        id = 'window_tint',
        label = 'Window Tint',
        description = ('%s%s'):format(VMODSConfig.Currency, VMODSConfig.Prices['colors']),
        close = true,
        values = windowTintLabels,
        set = function(index)
            SetVehicleWindowTint(vehicle, index - 1)
            return originalWindowTint == index - 1, ('%s windows installed'):format(windowTintLabels[index])
        end,
        restore = function()
            SetVehicleWindowTint(vehicle, originalWindowTint)
        end,
        defaultIndex = originalWindowTint + 1,
    }

    return option
end

return windowTint