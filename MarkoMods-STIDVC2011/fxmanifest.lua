fx_version('cerulean')
games({ 'gta5' })
files {
	'**/weaponarchetypes.meta',
	'**/weaponcomponents.meta',
	'**/weaponanimations.meta',
	'**/pedpersonality.meta',
	'**/weapons.meta',
}
data_file 'WEAPON_METADATA_FILE' '**/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/weaponanimations.meta'
data_file 'WEAPON_COMPONENTS_FILE' '**/weaponcomponents.meta'
data_file 'WEAPONCOMPONENTSINFO_FILE' '**/weaponcomponents.meta'
data_file 'WEAPONINFO_FILE' '**/weapons.meta'
client_script 'cl_weaponNames.lua'
escrow_ignore {
	'stream/*.ytd',
	'meta/*.meta',
	'cl_weaponNames.lua'
}
lua54 'yes'
