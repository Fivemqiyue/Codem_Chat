fx_version 'cerulean'
game 'gta5'
author 'Lucid#3604'
files {
    'style.css',
    'script.js',
   

}



client_scripts {
    'config.lua',
    'client/main.lua'
}
server_scripts {
    'config.lua',
    'server/main.lua'
}

chat_theme 'gtao' {
    styleSheet = 'style.css',
    script = 'script.js',
    msgTemplates = {
        default = '<b>{0}</b><span>{1}</span>'
    }
}


lua54 'on'


escrow_ignore {
	'config.lua',
    'server/customThemes.lua'
	
}