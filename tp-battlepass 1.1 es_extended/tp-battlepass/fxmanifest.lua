fx_version 'adamant'
game 'gta5'

author 'Nosmakos'
description 'Titans Productions Battlepass ESX 1.1'
version '1.1.0'

server_scripts {
	"@mysql-async/lib/MySQL.lua",
    '@es_extended/locale.lua',
	'locales/en.lua',
    'config.lua',
    'server/*.lua'
}

client_scripts {
    '@es_extended/locale.lua',
	'locales/en.lua',
    'config.lua',
    'client/*.lua'
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/js/script.js',
	'html/css/*.css',
	'html/font/Prototype.ttf',
    'html/img/background.jpg',
    'html/img/items/*.png',
}

dependency 'es_extended'
