_ = require('underscore')
Table = require('cli-table')

{ Wattage } = require('./wattage')
{ Distance } = require('./distance')
{ Duration } = require('./duration')

class Metrics

  @PARSERS: {
    'split': (split) -> Duration.fromString(split)
    'wattage': (wattage) -> Wattage.fromString(wattage)
    'distance': (distance) -> Distance.fromString(distance)
    'time': (time) -> Distance.fromString(time)
  }

  @DEPS: {
    'split': ['distance', 'time']
    'distance': ['time', 'split']
    'time': ['distance', 'split']
  }

  @parse: (metricStrings = []) =>

    metricKeyValues = metricStrings.map (metricString) ->
      [ key, value ] = metricString.match(/^(.+)=(.+)$/)[1..]

    rawMetrics = {}

    for [ metric, metricValue ] in metricKeyValues

      throw new Error("Metric type [#{metric}] is unsupported") \
      unless @PARSERS[metric]?

      rawMetrics[metric] = @PARSERS[metric](metricValue)

    new Metrics(rawMetrics)

  constructor: (rawMetrics) ->

    for metric in _.keys(Metrics.PARSERS)
      @[metric] = rawMetrics[metric]

    @time ?= @split.clone().multiply(@distance.value / 500)
    @wattage ?= Wattage.fromSplit(@split)

  toTable: ->
    table = new Table({
      head: ['Distance', 'Time', 'Split', 'Wattage']
      colWidths: [10, 20, 15, 15]
    })
    table.push [ @distance, @time, @split, @wattage ]
    table.toString()

module.exports = { Metrics, Duration, Distance, Wattage }
