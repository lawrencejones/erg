#!/usr/bin/env coffee

fs = require('fs')
path = require('path')

{ logger } = require('./logger')
{ Metrics } = require('./metrics')

erg = require('commander')
erg._name = 'erg'

erg
  .version(require(path.join(__dirname, '..', 'package.json'))['version'])

erg
  .command('show <metrics...>')
  .description 'generates distance/duration/split/wattage'
  .action (metrics) ->

    logger.info 'Calculating metrics ...'
    console.log Metrics.parse(metrics).toTable()
    logger.info 'Done!'

erg.parse(process.argv)
erg.outputHelp() if process.argv.length < 3
