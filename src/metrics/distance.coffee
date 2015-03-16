class Distance

  @DISTANCE_REGEX: /^(\d+)(km|m)$/

  @fromString: (distanceString='') =>

    throw new Error("Invalid distance string: #{distanceString}") \
    unless @DISTANCE_REGEX.test(distanceString)

    [ __, value, unit ] = distanceString.match(@DISTANCE_REGEX)

    value = Number(value)
    if unit is 'km' then value *= 1000

    new @(value)

  constructor: (@value=0) ->

  toString: ->
    if @value > 1000
      "#{Math.floor(@value / 1000)}km"
    else "#{@value}m"

module.exports = { Distance }
