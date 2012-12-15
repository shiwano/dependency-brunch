_ = require 'underscore'
fs = require 'fs'

module.exports = class DependencyCompiler
  brunchPlugin: yes
  type: 'javascript'
  pattern: /^.*$/

  constructor: (@config) ->
    @dependencyConfig = {}

    for fileType in ['javascripts', 'stylesheets', 'templates']
      if @config.files[fileType]?.dependOn
        _.extend @dependencyConfig, @config.files[fileType].dependOn

  lint: (data, path, callback) ->
    try
      @_lint data, path, callback
    catch err
      error = err.stack
    finally
      callback error

  _lint: (data, path, callback) ->
    for dependencyPath, filePatterns of @dependencyConfig
      filePatterns = [filePatterns] unless _.isArray filePatterns

      for filePattern in filePatterns
        if _.isRegExp(filePattern) and path.match(filePattern)
          @updateTimeStampOf dependencyPath
        else if _.isString(filePattern) and path is filePattern
          @updateTimeStampOf dependencyPath

  updateTimeStampOf: (path) ->
    data = fs.readFileSync path, 'utf-8'
    fs.writeFileSync path, data
