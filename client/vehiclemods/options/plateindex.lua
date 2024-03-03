local originalPlateIndex
local function plateIndex()
    originalPlateIndex = GetVehicleNumberPlateTextIndex(vehicle)

    local plateIndexLabels = {}
    for i, v in ipairs(VMODSConfig.PlateIndexes) do
        plateIndexLabels[i] = v.label
    end

    local option = {
        id = 'plate_index',
        label = 'Plate Index',
        description = ('%s%s'):format(VMODSConfig.Currency, VMODSConfig.Prices['cosmetic']),
        close = true,
        values = plateIndexLabels,
        set = function(index)
            SetVehicleNumberPlateTextIndex(vehicle, index - 1)
            return originalPlateIndex == index - 1, ('%s plate installed'):format(plateIndexLabels[index])
        end,
        restore = function()
            SetVehicleNumberPlateTextIndex(vehicle, originalPlateIndex)
        end,
        defaultIndex = originalPlateIndex + 1,
    }

    return option
end

return plateIndex