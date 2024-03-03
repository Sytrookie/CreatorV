local txd = CreateRuntimeTxd('creatorv_txd')

Textures = {
    logo = 'cv'
}

for _, v in pairs(Textures) do
    CreateRuntimeTextureFromImage(txd, tostring(v), "assets/"..v..".png")
end