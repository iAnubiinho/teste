fx_version 'cerulean'
games {'gta5'}
description 'MarkoMods.com RFB'
files{
	'**/markomods-rfb-components.meta',
	'**/markomods-rfb-archetypes.meta',
	'**/markomods-rfb-animations.meta',
	'**/markomods-rfb-pedpersonality.meta',
	'**/markomods-rfb.meta',
}
data_file 'WEAPONCOMPONENTSINFO_FILE' '**/markomods-rfb-components.meta'
data_file 'WEAPON_METADATA_FILE' '**/markomods-rfb-archetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/markomods-rfb-animations.meta'
data_file 'PED_PERSONALITY_FILE' '**/markomods-rfb-pedpersonality.meta'
data_file 'WEAPONINFO_FILE' '**/markomods-rfb.meta'
client_script 'cl_weaponNames.lua'
escrow_ignore {
	'stream/**/*.ytd',
	'data/**/*.meta',
	'cl_weaponNames.lua'
}
lua54 'yes'
