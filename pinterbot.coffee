_            = require('./lib/vendors/underscore')
util         = require('util')
EventEmitter = require('events').EventEmitter

# You can spawn different bots with this thing
Pinterevilapi = require('./lib/pinterevilapi')
Connection    = Pinterevilapi.Account


#
# Eventer
#
class Eventer extends EventEmitter
eventer = new Eventer()
eventer.setMaxListeners 100

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
    $boardSection = $(".attribution", $elt)
    boardUrl = $("a", $boardSection).last().attr("href")
    pins.push { id:dataId, board:boardUrl } if dataId
  _.initial(pins, 47)
  console.log pins
  eventer.emit 'response:pinIds'

setBoardCategoryCallback = (err, window, $) ->
  category = $('meta[property="pinterestapp:category"]').attr("content")
  console.log category
  console.log currentIndex
  pin = pins[currentIndex]
  pin.category = category
  pins[currentIndex] = pin
  categorized++
  if categorized == pins.length
    console.log pins
  console.log categorized + "===" + pins.length
  currentIndex++
  eventName = if categorized == pins.length then "finishCategorizing" else "response:setBoardCategory"
  console.log "event => " + eventName
  eventer.emit eventName


#
# Listener functions
#
getPopularPins = () ->
  console.log "logged in"
  connection.navigate "http://pinterest.com/popular/", popularPinsCallback

setBoardCategory = () ->
  return if currentIndex == pins.length
  pin = pins[currentIndex]

  console.log pin
  url = "http://pinterest.com" + pin.board
  eventer.on 'response:setBoardCategory', setBoardCategory
  connection.navigate url, setBoardCategoryCallback

showNewPins = () ->
  eventer.off 'response:setBoardCategory'
  console.log pins


myfunc = () ->
  _.each(pins, () ->
    connection.navigate url, setBoardCategoryCallback

#
# Main script
#
console.log 'Running pinterbot'

connection = new Connection('email@address.com', 'password')

pins = []
eventer.on 'login', getPopularPins
currentIndex = 0
categorized = 0
eventer.on 'response:pinIds', setBoardCategory
eventer.on 'finishCategorizing', showNewPins

connection.login loginCallback





