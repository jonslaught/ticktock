


loadLiveQuoteYahoo = (symbol) ->

  # http://developer.yahoo.com/yql/console/?q=show%20tables&env=store://datatables.org/alltableswithkeys#h=select%20symbol%2C%20LastTradeTime%2C%20LastTradeDate%2C%20LastTradePriceOnly%20from%20yahoo.finance.quotes%20where%20symbol%20%3D%20%27GOOG%27
  yahooUrl = "http://query.yahooapis.com/v1/public/yql?q=select%20symbol%2C%20LastTradeTime%2C%20LastTradeDate%2C%20LastTradePriceOnly%20from%20yahoo.finance.quotes%20where%20symbol%20%3D%20'#{symbol}'&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="

  query_time = now()
  response = Meteor.http.get(yahooUrl)

  if response.statusCode != 200
    # ruh roh
    return null
  else
    quote = response.data.query.results.quote
    data =
      symbol: symbol
      time: query_time
      price: quote.LastTradePriceOnly
    Prices.findOrInsert(data)
    return data

    # todo: parse the time from quote.LastTradeDate and LastTradeTime. But what's the time zone? could assume EST for now


loadStockInfoYahoo = (symbol) ->



Meteor.Router.add
  '/live/:symbol': (symbol) -> 
    prettify loadLiveQuoteYahoo(symbol)