---@param vehicle number
---@param modType number
---@param modValue number
---@return string
return function (vehicle, modType, modValue)
    if VMODSConfig.ModLabels[modType] then
        for _, mod in ipairs(VMODSConfig.ModLabels[modType]) do
            if mod.id == modValue then return mod.label end
        end
    end

    if modValue == -1 then return 'Stock' end

    local label = GetModTextLabel(vehicle, modType, modValue)
    return (not label or label == '') and tostring(modValue) or GetLabelText(label)
end