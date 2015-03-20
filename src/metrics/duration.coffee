class Duration

  @DURATION_REGEX: /^(\d+:)?(\d+):(\d+)(\.\d+)?$/

  # Expects <(hh):>?(mm):(ss)<.(ms)>?
  @fromString: (durationString='') =>

    throw new Error("Invalid duration string: [#{durationString}]") \
    unless @DURATION_REGEX.test(durationString)

    [ __, h, m, s, ms ] = durationString.match(@DURATION_REGEX)

    h = if h? then Number(h[..-2]) else 0
    ms = if ms? then Number("#{ms[1..]}000"[0..2]) else 0

    new @(3600 * h + 60 * Number(m) + Number(s) + ms / 1000)

  constructor: (@_s=0) ->

  multiply: (n) -> new Duration(@_s * n)

  toSeconds: -> @_s

  toString: ->
    "#{@hh}:#{@mm}:#{('00' + @ss).slice(-2)}.#{('000' + @ms).slice(-3)}"
      .replace(/^0:/, '')

Object.defineProperties Duration.prototype, {
  hh: get: -> Math.floor ( @_s / 3600 )
  mm: get: -> Math.floor ( @_s % 3600 ) / 60
  ss: get: -> Math.floor ( @_s % 60 )
  ms: get: -> Math.floor ( 1000 * ( @_s % 1 ) )
}

module.exports = { Duration }
