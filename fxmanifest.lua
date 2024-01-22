fx_version "cerulean"

description "Server information"
author "notkuubik"
version '1.0.0'

lua54 'yes'

game "gta5"

ui_page 'web/index.html'

client_script "client/**/*"

shared_script "sharedconfig.lua"

server_script "server/**/*"

files {
  'web/index.html',
  'web/**/*',
  'locales/*.json'
}