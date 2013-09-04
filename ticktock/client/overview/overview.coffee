
# User
############

@currentInvestor = (reactive=true) ->
  
  if reactive
    investor_id = Session.get('viewingUserId')
    investor = Investors.findOne investor_id
  else
    Deps.nonreactive ->
      investor_id = Session.get('viewingUserId')
      investor = Investors.findOne investor_id

  return investor

Stock::history = ->
  if history = Session.get('history')
    (sq for time, sq of history.stocks[@symbol])
  else
    []

Investor::history = ->
  if history = Session.get('history')
    (iq for time, iq of history.investors[@_id])
  else
    []


# Timing
###############

today = Stock.lastTradingDay()

Session.setDefault('clock_end', Stock.tradingClose today)
Session.setDefault('clock_start', Stock.tradingOpen today)
Session.setDefault('clock_now', Stock.tradingOpen today)

# Subscriptions
#################

subHistory = ->
  Session.set 'history', null
  onReady = ->
    Session.set 'history', History.findOne()

  safeSubscribe 'history', Session.get('sub_start'), Session.get('sub_end'), 5, onReady

subPrices = ->
  safeSubscribe 'pricesTime', Session.get('sub_end')

subscriptionTimer = ->
  Session.set('sub_start', Session.get('clock_start'))
  Session.set('sub_end', Session.get('clock_end'))

Meteor.setIntervalInstant _.throttle(subscriptionTimer,1000), 100

Deps.autorun ->
  subPrices()
  subHistory()
  
  