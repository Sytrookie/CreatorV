FONTS = {
    ['digital7'] = -1,
}

for font, _ in pairs(FONTS) do
    RegisterFontFile(font)
    FONTS[font] = RegisterFontId(font)
    print('font added', font, FONTS[font])
end

-- https://github.com/antond15/gfx-font-converter
-- RegisterFontFile('digital7') -- File name without file extension
-- local fontId = RegisterFontId('digital7') -- Font name you entered in the convert script
-- local fontText = '<font face="digital7">This text will have the digital7 font</font>'