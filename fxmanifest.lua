fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'YourName'
description 'Apartment Renting System for ESX using ox_lib and ox_target'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'shared/config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua'
}

