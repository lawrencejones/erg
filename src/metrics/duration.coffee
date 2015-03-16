class Duration

  @DURATION_REGEX: /^(\d+:)?(\d+):(\d+)(\.\d+)?$/
  @BASE: {
    m: ['h', 60]
    s: ['m', 60]
    ms: ['s', 1000]
  }

  # Expects <(hh):>?(mm):(ss)<.(ms)>?
  @fromString: (durationString='') =>

    throw new Error("Invalid duration string: [#{durationString}]") \
    unless @DURATION_REGEX.test(durationString)

    [ __, h, m, s, ms ] = durationString.match(@DURATION_REGEX)

    h = if h? then Number(h[..-2]) else 0
    ms = if ms? then Number("#{ms[1..]}000"[0..2]) else 0

    new @(h, Number(m), Number(s), ms)

  constructor: (@h=0, @m=0, @s=0, @ms=0) ->
    @rebase()

  multiply: (n) ->
    for key in ['h', 'm', 's', 'ms']
      @[key] *= n
    @rebase()

  rebase: ->
    for key in ['ms', 's', 'm']
      [nextKey, max] = Duration['BASE'][key]
      if @[key] >= max
        @[nextKey] += Math.floor(@[key] / max)
        @[key] = @[key] % max
    return @

  toSeconds: ->
    3600 * @h + 60 * @m + @s + @ms / 1000

  toString: ->
    "#{@h}:#{@m}:#{('00' + @s).slice(-2)}.#{('000' + @ms).slice(-3)}"
      .replace(/^0:/, '')

  clone: -> new Duration(@h, @m, @s, @ms)

module.exports = { Duration }
