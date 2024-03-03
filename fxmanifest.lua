-- Resource Metadata
fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'

-- Resource Info
author 'Sytrookie'
description 'CreatorV is a resource that allows you to create and test quick'
website 'https://github.com/Sytrookie/CreatorV'

ui_page 'web/index.html'

shared_script '@ox_lib/init.lua'
shared_scripts {
    'shared/*.lua',
}

files {
    'data/*.lua',
}

files {
    'client/vehiclemods/**/*.lua',
    'client/vehiclemods/*.lua',
    'web/**/*',
    'carcols_gen9.meta',
    'carmodcols_gen9.meta',
    'assets/*.png',
    'assets/**/*.png'
}
data_file 'CARCOLS_GEN9_FILE' 'carcols_gen9.meta'
data_file 'CARMODCOLS_GEN9_FILE' 'carmodcols_gen9.meta'

client_scripts {
    'client/*.lua',
    'client/**/*.lua',
    'client/vehiclemods/menus/main.lua',
    'client/vehiclemods/zones.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
    'server/**/*.lua',
    'server/vehiclemods/server.lua',
}

dependencies {
    'ox_lib',
    'interact',
    '/server:7290',
    '/onesync',
}
