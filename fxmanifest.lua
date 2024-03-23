fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Bob\'s Mods'
description 'Chicken job for civilians in the city.'
version '1.00'

shared_script 'shared/config.lua'
client_script {
  'client/client.lua',
  'client/c_functions.lua',
}
server_script {
  'server/server.lua',
  'server/s_functions.lua',
  'server/chickenFarmer.lua',
  'server/chickenDealer.lua'
}
