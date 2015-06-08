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
    'duration': (duration) -> Duration.fromString(duration)
  }

  @DEPS: {
    'split': ['distance', 'duration']
    'distance': ['duration', 'split']
    'duration': ['distance', 'split']
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

    @split ?= @duration.multiply(500 / @distance.value)
    @duration ?= @split.multiply(@distance.value / 500)
    @wattage ?= Wattage.fromSplit(@split)

  toTable: ->
    table = new Table({
      head: ['Distance', 'Duration', 'Split', 'Wattage']
      colWidths: [10, 20, 15, 15]
    })
    table.push [ @distance, @duration, @split, @wattage ]
    table.toString()

module.exports = { Metrics, Duration, Distance, Wattage }
