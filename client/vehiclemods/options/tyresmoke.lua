local originalLabelIndex = 1

local function tyresmoke()
    ToggleVehicleMod(vehicle, 20, true)
    local r, g, b = GetVehicleTyreSmokeColor(vehicle)

    local rgbValues = {}
    local smokeLabels = {}
    for i, v in ipairs(VMODSConfig.TyreSmoke) do
        smokeLabels[i] = v.label
        rgbValues[i] = {r = v.r, g = v.g, b = v.b}
        if v.r == r and v.g == g and v.b == b then
            originalLabelIndex = i
        end
    end

    local option = {
        id = 'tyre_smoke',
        label = 'Tyre smoke',
        description = ('%s%s'):format(VMODSConfig.Currency, VMODSConfig.Prices['colors']),
        close = true,
        values = smokeLabels,
        rgbValues = rgbValues,
        set = function(index)
            local rgb = VMODSConfig.TyreSmoke[index]
            SetVehicleTyreSmokeColor(vehicle, rgb.r, rgb.g, rgb.b)
            return originalLabelIndex == index, ('%s installed'):format(VMODSConfig.TyreSmoke[index].label)
        end,
        restore = function()
            local rgb = VMODSConfig.TyreSmoke[originalLabelIndex]
            SetVehicleTyreSmokeColor(vehicle, rgb.r, rgb.g, rgb.b)
        end,
        defaultIndex = originalLabelIndex,
    }

    return option
end

return tyresmoke
