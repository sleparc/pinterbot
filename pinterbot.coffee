# You can spawn different bots with this thing
Pinterevilapi = require('./lib/pinterevilapi')
Account       = Pinterevilapi.Account


#
# Callbacks
#
popularPinsCallback = (err, window, $) ->
  console.log "in callback"
  pinIds = []
  $('.pin').each (i, elt) ->
    $elt = $(elt)
    dataId = $elt.attr("data-id")
    pinIds.push dataId if dataId
  return pinIds


#
# Main script
#
console.log 'Running pinterbot'

account = new Account('william.estoque@gmail.com', 'salarium17')
account.login ->
  console.log "logged in"
  thePins = []
  account.navigate("http://pinterest.com/popular/", popularPinsCallback)
  
  console.log thePins
