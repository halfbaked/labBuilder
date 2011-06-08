# Handles command line calls to labBuilder

# Dependencies
LabBuilder = require './labBuilder'
helpers = require './helpers'
fs = require 'fs'
nomnom = require 'nomnom'

NOMNOM_CONFIG = {
  labjs: {
    string: '-lb <url/to/lab.js>, --labjs=<url/to/lab.js>'
    help: 'Set location from where to download lab.js. Default: cdnjs.com'
    default: 'http://ajax.cdnjs.com/ajax/libs/labjs/1.2.0/LAB.min.js'
  }
  output: {
    string: '-o <labBuilderFile>, --output= <labBuilderFile>'
    help: 'Specify file to place generated output. Default prints to ./labBuilder.js'
    default: './labBuilder.js'
  }
  scripts: {
    string: '-s </location/of/json/file>, --scripts </location/of/json/file>'
    help: 'Specify where scripts for lab.js to load are located'
  }
  version: {
    string: '-v, --version'
    help: 'Returns labBuilder version'
    callback: ->
      return "version 0.1";            
  }
}

printLine = (line) -> process.stdout.write line + '\n'

exports.run = ->
  options = nomnom.opts(NOMNOM_CONFIG).parseArgs()
  console.log options

  if (options.scripts)     
    fs.readFile(options.scripts, encoding='utf8', (err, data) ->
      throw err if err
      scriptsJson = JSON.parse(helpers.trimString(data))
      LabBuilder.build options.labjs, scriptsJson, options.output
    )
   
