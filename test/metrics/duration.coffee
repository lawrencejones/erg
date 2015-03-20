{ Duration } = require('../../src/metrics/duration')

describe 'Metrics', -> \
describe 'Duration', ->

  context 'constructed from 3683.123 seconds', ->

    beforeEach -> @d = new Duration(3683.123)

    describe 'virtual fields', ->

      it 'yield 1 hour', ->
        @d.hh.should.equal(1)

      it 'yield 1 minute', ->
        @d.mm.should.equal(1)

      it 'yield 23 seconds', ->
        @d.ss.should.equal(23)

      it 'yield 123 ms', ->
        @d.ms.should.equal(123)

  describe '#toString', ->

    it 'generates hourly if required', ->
      new Duration(3600.123).toString().should.match /^1:/

    it 'excludes hourly if not large enough', ->
      new Duration(3599.123).toString().should.not.match /^1:/

