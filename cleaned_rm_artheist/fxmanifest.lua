fx_version 'cerulean'
games { 'rdr3', 'gta5' }

version '1.0.0'
description 'Rainmad ArtHeist'

shared_scripts {
    'config.lua'
}

server_scripts {
	'server.lua'
}

client_scripts {
	'client.lua'
}

files {
    'ui/app.js',
    'ui/index.html',
    'ui/style.css',
    'ui/*.png',
}

ui_page {
    'ui/index.html'
}

