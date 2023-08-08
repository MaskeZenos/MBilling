fx_version "adamant" 
game "gta5" 

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    "server/***/*.lua"
}

client_scripts {
    'RageUI/RMenu.lua',
    'RageUI/menu/RageUI.lua',
    'RageUI/menu/Menu.lua',
    'RageUI/menu/MenuController.lua',
    'RageUI/components/*.lua',
    'RageUI/menu/elements/*.lua',
    'RageUI/menu/items/*.lua',
    'RageUI/menu/panels/*.lua',
    "client/***/*.lua"
}




