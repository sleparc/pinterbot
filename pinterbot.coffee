util         = require('util')
EventEmitter = require('events').EventEmitter

# You can spawn different bots with this thing
Pinterevilapi = require('./lib/pinterevilapi')
Account       = Pinterevilapi.Account


#
# Eventer
#
class Eventer extends EventEmitter
eventer = new Eventer()


#
# Callbacks
#
loginCallback = () ->
  eventer.emit 'login'

popularPinsCallback = (err, window, $) ->
  console.log "processing popular"
  $('.pin').each (i, elt) ->
    $elt = $(elt)
    dataId = $elt.attr("data-id")
    pinIds.push dataId if dataId
  eventer.emit 'response:pinIds'


#
# Listener functions
#
logPinIds = () ->
  console.log pinIds

getPopularPins = () ->
  console.log "logged in"
  account.navigate "http://pinterest.com/popular/", popularPinsCallback

#
# Main script
#
console.log 'Running pinterbot'

account = new Account('william.estoque@gmail.com', 'salarium17')

pinIds = []
eventer.on 'login', getPopularPins
eventer.on('response:pinIds', logPinIds)

account.login loginCallback





