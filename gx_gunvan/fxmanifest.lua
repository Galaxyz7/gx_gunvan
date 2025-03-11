lua54 "yes" -- needed for Reaper

fx_version 'cerulean'
game 'gta5'

author 'YourName'
description 'ESX Gun Van Script with OX Inventory'
version '1.0.0'
shared_script '@es_extended/imports.lua'
-- Define shared scripts
shared_scripts {
    '@es_extended/imports.lua', -- Required for ESX compatibility
    'config.lua',
    '@ox_lib/init.lua',
}

-- Server scripts
server_scripts {
    '@oxmysql/lib/MySQL.lua', -- If using oxmysql (optional)
    'server.lua'
}

-- Client scripts
client_scripts {
    'client.lua'
}

-- Dependencies
dependencies {
    'es_extended',
    'ox_inventory',
    'ox_lib' -- For notifications
}

lua54 'yes'
