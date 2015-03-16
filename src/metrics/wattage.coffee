{ Duration } = require('./duration')

class Wattage

  @WATTAGE_REGEX: /^(\d+)[wW]?$/

  # Using Concept2 formula, assumes 500m split if no distance given
  # http://www.concept2.co.uk/indoor-rowers/training/calculators/watts-calculator
  @fromSplit: (split, distance=500) ->

    throw new Error('Split must be instanceof Duration') \
    unless split instanceof Duration

    new Wattage(2.8 / Math.pow(split.toSeconds() / distance, 3))

  @fromString: (wattString) =>

    throw new Error("Invalid watt string format [#{wattString}]") \
    unless @WATTAGE_REGEX.test(wattString)

    new Wattage(Number(wattString.match(@WATTAGE_REGEX)[1]))

  constructor: (watts) ->
    @watts = Math.floor(watts * 10) / 10

  toString: -> "#{@watts}W"

module.exports = { Wattage }
